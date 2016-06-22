package com.storeit.storeit.utils;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import android.util.Log;
import android.widget.Toast;

import com.google.gson.Gson;
import com.storeit.storeit.protocol.StoreitFile;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.util.Map;

/**
 * Handle file creation and deletion
 */
public class FilesManager {
    private File mDataDir;
    private StoreitFile mRootFile;

    public FilesManager(Context ctx, StoreitFile rootFile) {

        SharedPreferences SP = PreferenceManager.getDefaultSharedPreferences(ctx);
        String storageLocation = SP.getString("pref_key_storage_location", "");


        if (storageLocation.equals("")) {
            File path[] = ctx.getExternalFilesDirs(null);
            storageLocation = path[0].getAbsolutePath();
        }

        File storeitFolder = new File(storageLocation + "/storeit");
        if (!storeitFolder.exists()) {
            if (!storeitFolder.mkdirs()) {
                Toast.makeText(ctx, "An error occured while creating storeit folder...", Toast.LENGTH_LONG).show();
            }

        }

        mDataDir = new File(storageLocation);
        mRootFile = rootFile;
    }

    public boolean exist(StoreitFile file){

        File requestedFile = new File(mDataDir.getAbsolutePath() + "/" + file.getPath());
        return requestedFile.exists();
    }

    public StoreitFile getRoot(){
        return mRootFile;
    }

    public String getFolderPath() {
        return mDataDir.getPath();
    }
}
