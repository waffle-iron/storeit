package com.storeit.storeit;

import android.app.IntentService;
import android.content.Intent;
import android.util.Log;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.SocketAddress;
import java.net.UnknownHostException;

/**
 * Created by loulo on 23/03/2016.
 */
public class ReceiveService extends IntentService {

    private final String LOGTAG = "ReceiveService";

    public ReceiveService() {
        super("ReceiveService");
    }

    @Override
    protected void onHandleIntent(Intent intent) {

        // Get parameters from intent
        String ip = intent.getStringExtra("ip");
        int port = intent.getIntExtra("port", 7642);
        String chunkPath = intent.getStringExtra("chunkPath");

        // Chunk file
        File chunFile = new File(chunkPath);
        InputStream in = null;

        // chunk stream
        try {
            in = new BufferedInputStream(new FileInputStream(chunFile));
        } catch (FileNotFoundException e) {
            Log.e(LOGTAG, "chunk: " + chunkPath + " not found...");
            return ;
        }

        // Read whole file
        // Todo : send small packet
        byte[] buffer = new byte[(int)chunFile.length()];
        try {
            in.read(buffer);
        } catch (IOException e) {
            Log.e(LOGTAG, "Error while reading chunk");
        }

        Socket socket = new Socket();
        OutputStream out = null;

        InetAddress addr;
        try {
            addr = InetAddress.getByName(ip);
            SocketAddress sockaddr = new InetSocketAddress(addr, port);
            socket.connect(sockaddr, 5000);
            out = socket.getOutputStream();
        } catch (UnknownHostException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        if (out == null)
        {
            Log.e("SendService", "out == null");
            return;
        }

        String cmd = "CSTR " + buffer.length + " ";

        try {
            out.write(cmd.getBytes());
            out.write(buffer);
            out.flush();
        } catch (Exception e) {
            Log.v("SendService", "Write failed...");
        }
    }
}
