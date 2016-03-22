package com.storeit.storeit;

import android.app.Service;
import android.content.Intent;
import android.os.Binder;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.util.Log;

import com.squareup.otto.Bus;
import com.storeit.storeit.protocol.StoreItProtocol;
import com.storeit.storeit.protocol.StoreitFile;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.SocketAddress;

/*
* This service handle the tcp connection
* It communicate with the ui of the app
*/
public class SocketService extends Service {

    private final IBinder myBinder = new LocalBinder();

    public static final String SERVERIP = "51.254.99.47"; //your computer IP address should be written here
    public static final int SERVERPORT = 7641;

    public static final String LOGTAG = "SocketService";

    private Bus bus = OttoManager.getBus();

    PrintWriter mSocketWriter;
    Socket mSocket;
    private boolean mConnected = false;
    private StoreItProtocol mProtocol = new StoreItProtocol();

    Handler handler = new Handler(Looper.getMainLooper());

    private class SocketManager implements Runnable {
        @Override
        public void run() {
            mSocket = new Socket();

            // Loop on connection
            mConnected = connectToServer(mSocket, SERVERIP, SERVERPORT);
            while (!mConnected) {
                mConnected = connectToServer(mSocket, SERVERIP, SERVERPORT);
                try {
                    Thread.sleep(5000);
                } catch (InterruptedException e) {
                }
            }
        }
    }

    @Override
    public IBinder onBind(Intent intent) {
        Log.v(LOGTAG, "OnBind :)");
        return myBinder;
    }

    public class LocalBinder extends Binder {
        public SocketService getService() {
            return SocketService.this;

        }
    }

    @Override
    public void onCreate() {
        super.onCreate();

        Thread t = new Thread(new SocketManager());
        t.start();


    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        super.onStartCommand(intent, flags, startId);

        return START_STICKY;
    }

    void sendJoin(String username, String password) {
        String cmd = mProtocol.createJoinCommand(username, password, 7641, new StoreitFile("/toto/tata", "super_hash", 0));

        if (mSocketWriter != null && !mSocketWriter.checkError()) {
            mSocketWriter.print(cmd);
            mSocketWriter.flush();
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();

        Log.v(LOGTAG, "On destroy :o");

        try {
            mSocket.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        mSocket = null;
    }

    boolean connectToServer(Socket socket, String ip, int port) {
        InetAddress addr;
        try {
            addr = InetAddress.getByName(ip);
            SocketAddress sockaddr = new InetSocketAddress(addr, port);
            socket.connect(sockaddr, 5000);
        } catch (IOException e) {
            Log.e(LOGTAG, "Error while connecting socket");
            handler.post(new Runnable() {
                @Override
                public void run() {
                    bus.post("Error while connecting to socket...");
                }
            });
            return false;
        }

        mConnected = true;

        BufferedReader mSocketReader;
        try {
            mSocketWriter = new PrintWriter(new BufferedWriter(new OutputStreamWriter(socket.getOutputStream())), true);
            mSocketReader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
        } catch (IOException e) {
            Log.e(LOGTAG, "Error while getting stream from socket");
            return false;
        }

        while (mConnected) {
            if (!socket.isBound() || socket.isClosed() || !socket.isConnected()) {
                mConnected = false;
                break;
            }

            String data = "";
            try {
                data = mSocketReader.readLine();
                Log.v(LOGTAG, "Received data : " + data);
            } catch (IOException e) {
                mConnected = false;
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        bus.post("Connection Lost :(");
                    }
                });
            }

            final String str = data;

            if (str != null && !str.equals("")) {
                mProtocol.commandReceived(str);
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        bus.post(str);
                    }
                });
            } else
                mConnected = false;
        }
        return true;
    }

    public boolean isConnected(){
        return mConnected;
    }
}
