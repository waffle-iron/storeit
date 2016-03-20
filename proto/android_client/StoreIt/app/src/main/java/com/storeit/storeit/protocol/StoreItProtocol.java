package com.storeit.storeit.protocol;

import android.util.Log;
import android.widget.TabHost;

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

    public static final int CHDELETE = 0, CHSEND = 1, JOIN = 2, LEAVE = 3;

    public class NetworkCommand
    {
        public int type;
        public String data;
    }

    public String createJoinCommand(String username, String password, int port, StoreitFile file) {
        lastCommand = "Join";

        String hashes = "None";
        String cmd = "JOIN " + username + " " + port + " None " + file.toJson() + "\r\n";

        return cmd;
    }

    public void createLeaveCommand() {

    }

    public void handleCHDELETE(String[] tokens){

    }

    public void handleCHSEND(String[] tokens){

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
