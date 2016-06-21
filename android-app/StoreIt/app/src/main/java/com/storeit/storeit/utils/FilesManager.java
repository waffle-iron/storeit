package com.storeit.storeit.utils;

import android.content.Context;
import android.widget.Toast;

import com.storeit.storeit.protocol.StoreitFile;

import java.io.File;
import java.util.Map;

/**
 * Handle file creation and deletion
 */
public class FilesManager {
    private File mDataDir;

    public FilesManager(Context ctx) {
        File path[] = ctx.getExternalFilesDirs(null);

        File storeitFolder = new File(path[1].getAbsolutePath() + "/storeit");
        if (!storeitFolder.exists()) {
            if (!storeitFolder.mkdirs()){
                Toast.makeText(ctx, "An error occured while creating storeit folder...", Toast.LENGTH_LONG).show();
            }
        }
        mDataDir = new File(path[1].getAbsolutePath());
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

    public String toLocalPath(String path){
        return path.replace(mDataDir.getPath(), ".");
    }

    private String recursiveSearch(String hash, StoreitFile root){
        for (Map.Entry<String, StoreitFile> entry : root.getFiles().entrySet()){
            if (entry.getValue().getKind() == 0)
                recursiveSearch(hash, entry.getValue());
            else if (entry.getValue().getUnique_hash().equals(hash))
                return entry.getValue().getPath();
        }
        return "";
    }

    public String getFileByHash(String hash, StoreitFile file){
        return mDataDir + recursiveSearch(hash, file);
    }

    public String getFolderPath(){
        return mDataDir.getPath();
    }

    public StoreitFile makeTree() {
        StoreitFile rootFile = new StoreitFile(toLocalPath(mDataDir.getPath() + "/storeit"), "0", 0);
        listDir(new File(mDataDir + "/storeit"), rootFile);
        return rootFile;
    }
}
