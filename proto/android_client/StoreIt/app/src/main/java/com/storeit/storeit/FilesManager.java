package com.storeit.storeit;

import android.content.Context;
import android.os.Environment;
import android.util.Log;

import java.io.File;
import java.io.FileOutputStream;

/**
 * Handle file creation and deletion
 */
public class FilesManager {

    private static final String LOGTAG = "FileManager";

    private Context mContext; // Used for getting file path to data
    private File mDataDir;

    public FilesManager(Context ctx){
        File path[] = ctx.getExternalFilesDirs(Environment.DIRECTORY_DOCUMENTS);
        mDataDir = path[1];
    }

    private void recursiveListFile(File root){
        File[] files = root.listFiles();

        for (File file : files){
            if (file.isDirectory()){
                Log.d(LOGTAG, "[" + file.getAbsoluteFile() + "] : ");
                recursiveListFile(file);
            }else{
                Log.d(LOGTAG, "-" + file.getAbsoluteFile());
            }
        }
    }

    public void listFiles(){
        recursiveListFile(mDataDir);
    }
}
