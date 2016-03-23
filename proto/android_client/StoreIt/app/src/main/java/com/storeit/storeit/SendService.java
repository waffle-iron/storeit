package com.storeit.storeit;

import android.app.IntentService;
import android.content.Intent;
import android.util.Log;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.SocketAddress;
import java.net.UnknownHostException;

/**
 * Created by loulo on 23/03/2016.
 */
public class SendService extends IntentService {
    public SendService() {
        super("SendService");
    }

    @Override
    protected void onHandleIntent(Intent intent) {

        Log.v("SendService", "Hello");

        String ip = intent.getStringExtra("ip");
        int port = intent.getIntExtra("port", 7642);
        String hash = intent.getStringExtra("hash");

        Socket socket = new Socket();
        BufferedWriter writer = null;

        InetAddress addr;
        try {
            addr = InetAddress.getByName(ip);
            SocketAddress sockaddr = new InetSocketAddress(addr, port);
            socket.connect(sockaddr, 5000);
            writer  = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));
        } catch (UnknownHostException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        if (writer == null)
        {
            Log.e("SendService", "writer == null");
            return;
        }


        try {
            writer.write("fuck you\r\n");
            writer.flush();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
