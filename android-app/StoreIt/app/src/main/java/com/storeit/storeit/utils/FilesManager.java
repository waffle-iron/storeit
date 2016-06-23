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
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Map;

/**
 * Handle file creation and deletion
 */
public class FilesManager {
    private File mDataDir;
    private StoreitFile mRootFile;
    private static final String LOGTAG = "FilesManager";

    public FilesManager(Context ctx, StoreitFile rootFile) {

        SharedPreferences SP = PreferenceManager.getDefaultSharedPreferences(ctx);
        String storageLocation = SP.getString("pref_key_storage_location", "");

        if (storageLocation.equals("")) {
            File path[] = ctx.getExternalFilesDirs(null);
            storageLocation = path[0].getAbsolutePath();
        }

        mDataDir = new File(storageLocation);

        File storeitFolder = new File(storageLocation + "/storeit");
        if (!storeitFolder.exists()) {
            if (!storeitFolder.mkdirs()) {
                Toast.makeText(ctx, "An error occured while creating storeit folder...", Toast.LENGTH_LONG).show();
            }
            File jsonFile = new File(storageLocation + "/storeit.json");

            Log.d(LOGTAG, "Creating root json file");
            try {
                if (!jsonFile.exists()){
                    if (!jsonFile.createNewFile()) {
                        Log.v(LOGTAG, "Error creating .storeit");
                    }
                }
                FileWriter fw = new FileWriter(jsonFile);
                Gson gson = new Gson();
                fw.write(gson.toJson(rootFile, StoreitFile.class));
                fw.close();
            } catch (IOException e) {
                e.printStackTrace();
            }

        } else {
            StoreitFile currentRoot;
            StringBuilder text = new StringBuilder();
            String line;

            File jsonFile = new File(storageLocation + "/storeit.json");

            try {
                BufferedReader br;
                br = new BufferedReader(new FileReader(jsonFile));
                while ((line = br.readLine()) != null) {
                    text.append(line);
                    text.append('\n');
                }

                Gson gson = new Gson();
                currentRoot = gson.fromJson(text.toString(), StoreitFile.class);
                compareRoot(currentRoot, rootFile);

                FileWriter fw = new FileWriter(jsonFile, false);
                fw.write(gson.toJson(rootFile, StoreitFile.class));
                fw.close();

            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        mRootFile = rootFile;
    }

    // Delete a directory and its content
    public static boolean deleteContents(File dir) {
        File[] files = dir.listFiles();
        boolean success = true;
        if (files != null) {
            for (File file : files) {
                if (file.isDirectory()) {
                    success &= deleteContents(file);
                }
                if (!file.delete()) {
                    Log.e(LOGTAG, "Failed to delete " + file);
                    success = false;
                }
            }
        }
        return success;
    }

    // Recursively compare new tree with existing tree
    public void recursiveCmp(StoreitFile existingFile, StoreitFile newRoot) {

        if (!existingFile.getPath().equals("/storeit")) { // Don't delete root
            StoreitFile f = getFileByHash(existingFile.getIPFSHash(), newRoot); // Look for the actual file
            if (f == null) { // If the file doesn't exist anymore
                File fileToDelete = new File(mDataDir.getAbsolutePath() + File.separator + existingFile.getPath());
                if (fileToDelete.exists()) {
                    if (existingFile.isDirectory()) { // Delete directory
                        deleteContents(fileToDelete);
                    } else { // Delete file
                        if (!fileToDelete.delete()) {
                            Log.e(LOGTAG, "Error while deleting " + fileToDelete);
                        }
                    }

                }
            }
        }

        for (Map.Entry<String, StoreitFile> entry : existingFile.getFiles().entrySet()) {
            if (entry.getValue().isDirectory()) {
                recursiveCmp(entry.getValue(), newRoot);
            }
        }
    }

    public void compareRoot(StoreitFile currentRoot, StoreitFile newRoot) {
        recursiveCmp(currentRoot, newRoot);
    }

    public boolean exist(StoreitFile file) {

        File requestedFile = new File(mDataDir.getAbsolutePath() + "/" + file.getPath());
        return requestedFile.exists();
    }

    public StoreitFile getRoot() {
        return mRootFile;
    }

    public String getFolderPath() {
        return mDataDir.getPath();
    }

    private StoreitFile recursiveSearch(String hash, StoreitFile root) {
        for (Map.Entry<String, StoreitFile> entry : root.getFiles().entrySet()) {
            if (entry.getValue().isDirectory())
                recursiveSearch(hash, entry.getValue());
            else if (entry.getValue().getIPFSHash().equals(hash))
                return entry.getValue();
        }
        return null;
    }

    public StoreitFile getFileByHash(String hash, StoreitFile file) {
        return recursiveSearch(hash, file);
    }
}
