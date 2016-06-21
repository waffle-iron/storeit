package com.storeit.storeit.services;

import android.app.Service;
import android.content.Intent;
import android.os.Binder;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.util.Log;
import com.google.gson.Gson;
import com.neovisionaries.ws.client.WebSocket;
import com.neovisionaries.ws.client.WebSocketAdapter;
import com.neovisionaries.ws.client.WebSocketException;
import com.neovisionaries.ws.client.WebSocketExtension;
import com.neovisionaries.ws.client.WebSocketFactory;
import com.storeit.storeit.protocol.LoginHandler;
import com.storeit.storeit.protocol.command.CommandManager;
import com.storeit.storeit.protocol.command.JoinCommand;
import com.storeit.storeit.protocol.command.JoinResponse;

import java.io.IOException;

/*
* This service handle the websocket connection
* It communicate with the ui of the app
*/
public class SocketService extends Service {

    private final IBinder myBinder = new LocalBinder();

    public static final String SERVER = "ws://192.168.0.102:8001";
    private static final int TIMEOUT = 5000;
    public static final String LOGTAG = "SocketService";

    private boolean mConnected = false;

    private Handler handler = new Handler(Looper.getMainLooper());
    private WebSocket webSocket = null;

    private LoginHandler mLoginHandler;

    private class SocketManager implements Runnable {
        @Override
        public void run() {

            // Loop on connection
            mConnected = false;

            try {
                webSocket = new WebSocketFactory()
                        .setConnectionTimeout(TIMEOUT)
                        .createSocket(SERVER)
                        .addListener(new WebSocketAdapter() {

                            public void onTextMessage(WebSocket websocket, String message) {
                                int cmdType = CommandManager.getCommandType(message);
                                switch (cmdType){
                                    case CommandManager.JOIN:
                                        Log.v(LOGTAG, "Join command received :)");
                                        if (mLoginHandler != null){

                                            Gson gson = new Gson();
                                            JoinResponse response = gson.fromJson(message, JoinResponse.class);
                                            mLoginHandler.handleJoin(response);
                                        }

                                        break;
                                    case CommandManager.FDEL:
                                        break;
                                    case CommandManager.FADD:
                                        break;
                                    case CommandManager.FUPT:
                                        break;
                                    default:
                                        Log.v(LOGTAG, "Invalid command received :/");
                                        break;
                                }

                            }
                        })
                        .addExtension(WebSocketExtension.PERMESSAGE_DEFLATE)
                        .connect();
                mConnected = true;
            } catch (WebSocketException | IOException e) {
                e.printStackTrace();
            }
        }
    }

    public  void sendJOIN(String authType, String token){
        Gson gson = new Gson();
        JoinCommand cmd = new JoinCommand(0, authType, token);
        webSocket.sendText(gson.toJson(cmd));
    }

    public void setmLoginHandler(LoginHandler handler){
        mLoginHandler = handler;
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


    @Override
    public void onDestroy() {
        super.onDestroy();

        Log.v(LOGTAG, "On destroy :o");
    }

    public boolean isConnected() {
        return mConnected;
    }
}
