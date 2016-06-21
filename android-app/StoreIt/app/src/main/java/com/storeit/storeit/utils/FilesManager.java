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

    private StoreitFile rootFile;

    public FilesManager(Context ctx) {

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

        File jsonFile = new File(storageLocation + "/.storeit.json");

        // If file doesn't exists (first time)
        if (!jsonFile.exists()) {

            Log.v("FilesManager", "creating .storeit");

            FileOutputStream outputStream;

            rootFile = new StoreitFile(toLocalPath(mDataDir.getPath() + "/storeit"), "0", 0);

            try {
                if (!jsonFile.createNewFile()){
                    Log.v("FilesManager", "error creating .storeit");
                }
                outputStream = new FileOutputStream(jsonFile);
                Gson gson = new Gson();
                outputStream.write(gson.toJson(rootFile, StoreitFile.class).getBytes());

            } catch (IOException e) {
                e.printStackTrace();
            }
        } else { // Read the file

            Log.v("FilesManager", "reading .storeit");

            StringBuilder text = new StringBuilder();
            String line;

            try {
                BufferedReader br;
                br = new BufferedReader(new FileReader(jsonFile));
                while ((line = br.readLine()) != null) {
                    text.append(line);
                    text.append('\n');
                }

                Gson gson = new Gson();
                rootFile = gson.fromJson(text.toString(), StoreitFile.class);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    private void listDir(File root, StoreitFile rootFile) {
        File[] files = root.listFiles();

        for (File file : files) {
            if (file.isDirectory()) {
                StoreitFile dir = new StoreitFile(toLocalPath(file.getPath()), "0", 0);
                rootFile.addFile(dir);
                listDir(file, dir);
            } else {
                String unique_hash = "UNIQUE_HASH";
                StoreitFile stFile = new StoreitFile(toLocalPath(file.getPath()), unique_hash, 1);
                rootFile.addFile(stFile);
            }
        }
    }

    public String toLocalPath(String path) {
        return path.replace(mDataDir.getPath(), ".");
    }

    private String recursiveSearch(String hash, StoreitFile root) {
        for (Map.Entry<String, StoreitFile> entry : root.getFiles().entrySet()) {
            if (entry.getValue().getKind() == 0)
                recursiveSearch(hash, entry.getValue());
            else if (entry.getValue().getUnique_hash().equals(hash))
                return entry.getValue().getPath();
        }
        return "";
    }

    public String getFileByHash(String hash, StoreitFile file) {
        return mDataDir + recursiveSearch(hash, file);
    }

    public String getFolderPath() {
        return mDataDir.getPath();
    }

    public StoreitFile makeTree() {
        StoreitFile rootFile = new StoreitFile(toLocalPath(mDataDir.getPath() + "/storeit"), "0", 0);
        listDir(new File(mDataDir + "/storeit"), rootFile);
        return rootFile;
    }
}
