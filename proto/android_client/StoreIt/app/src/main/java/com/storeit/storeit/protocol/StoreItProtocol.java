package com.storeit.storeit.protocol;

import android.util.Log;
import android.widget.TabHost;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.util.ArrayList;

/**
 * Created by loulo on 19/01/2016.
 */
public class StoreItProtocol {

    private static final String TAG = "StoreItProtocol";
    private String lastCommand = "";
    private static final String[] mCommands = {
            "CHDELETE",
            "CHSEND",
    };
    private  StoreitHandler storeitHandler;

    public static final int CHDELETE = 0, CHSEND = 1, JOIN = 2, LEAVE = 3;

    public void setStoreitHandler(StoreitHandler storeitHandler){
        this.storeitHandler = storeitHandler;
    }


    public class NetworkCommand
    {
        public int type;
        public String data;
    }

    public String createJoinCommand(String username, String password, int port, StoreitFile file) {
        lastCommand = "Join";


        Gson gson = new Gson();


        String jsonFile = gson.toJson(file);
        Log.v(TAG, jsonFile);

        String hashes = "None";
        String cmd = "JOIN " + username + " " + port + " None " + jsonFile + "\r\n";

        return cmd;
    }

    public void createLeaveCommand() {

    }

    public void handleCHDELETE(String[] tokens){

    }

    public void handleCHSEND(String[] tokens){
        int send = Integer.valueOf(tokens[1]);
        String chunk_name = tokens[2];

        String[] infos = tokens[3].split(":");
        if (infos.length != 2)
            return ;

        String ip = infos[0];
        int port = Integer.parseInt(infos[1]);

        if (storeitHandler != null)
            storeitHandler.handleCHSEND(send, chunk_name, ip, port);
    }

    public void commandReceived(String command) {
        String[] tokens = command.split("[\\s+\\t+]");

        if (tokens.length == 0) {
            Log.d(TAG, "empty command received");
            return;
        }

        // @Todo Find alternative to function pointer array
        int i = 0;
        for (String cmd : mCommands) {
            if (tokens[0].equals(cmd))
                break;
            i++;
        }

        switch (i) {
            case CHDELETE:
                handleCHDELETE(tokens);
                break;
            case CHSEND:
                handleCHSEND(tokens);
                break;
            default:
                Log.d(TAG, "Not implemented : " + command);
        }
    }
}
