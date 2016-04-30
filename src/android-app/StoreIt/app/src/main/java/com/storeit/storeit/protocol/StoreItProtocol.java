package com.storeit.storeit.protocol;

import android.util.Log;

import com.google.gson.Gson;

/**
 * Created by loulo on 19/01/2016.
 */
public class StoreItProtocol {

    private static final String TAG = "StoreItProtocol";
    private String lastCommand = "";
    private static final String[] mCommands = {
            "CDEL",
            "CSND",
            "FADD"
    };
    private IStoreitClient storeitClient;

    public static final int CDEL = 0, CSND = 1, JOIN = 2, LEAVE = 3;

    public void setStoreitClient(IStoreitClient storeitClient){
        this.storeitClient = storeitClient;
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
        String hashes = "None";
        String cmd = "JOIN ";
        String params =  username + " " + port + " " + hashes + " " + jsonFile;
        cmd += params.length() + " " + params;

        Log.v(TAG, cmd);

        return cmd;
    }

    public void handleFADD(String[] tokens){

    }

    public void handleCDEL(String[] tokens){

    }

    public void handleCSND(String[] tokens){
        int send = Integer.valueOf(tokens[2]);
        String chunk_name = tokens[3];

        String[] infos = tokens[4].split(":");
        if (infos.length != 2)
            return ;

        String ip = infos[0];
        int port = Integer.parseInt(infos[1]);

        if (storeitClient != null)
            storeitClient.handleCHSEND(send, chunk_name, ip, port);
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
            case CDEL:
                handleCDEL(tokens);
                break;
            case CSND:
                handleCSND(tokens);
                break;
            default:
                Log.d(TAG, "Not implemented : " + command);
        }
    }
}
