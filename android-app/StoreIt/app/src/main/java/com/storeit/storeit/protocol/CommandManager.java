package com.storeit.storeit.protocol;

/**
 * Created by loulo on 02/05/2016.
 */
public class CommandManager {

    public final static int JOIN = 0, QUIT = 1, FDEL = 2, FADD = 3, FUPT = 4;
    private static final String[] cmds = {
            "JOIN",
            "QUIT",
            "FDL",
            "FADD",
            "FUPT"
    };

    public static int getCommandType(String cmd) {
        String[] tokens = cmd.split("\\s");

        for (int i = 0; i < cmds.length; i++){
            if (tokens[0].equals(cmds[i])){
                return i;
            }
        }
        return -1;
    }
}
