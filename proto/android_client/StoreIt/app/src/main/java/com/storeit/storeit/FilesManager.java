package com.storeit.storeit;

import android.content.Context;
import android.os.Environment;
import android.util.Log;
import com.storeit.storeit.protocol.HashManager;
import com.storeit.storeit.protocol.StoreitFile;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.security.NoSuchAlgorithmException;
import java.util.Map;

/**
 * Handle file creation and deletion
 */
public class FilesManager {

    private static final String LOGTAG = "FileManager";

    private Context mContext; // Used for getting file path to data
    private File mDataDir;

    public FilesManager(Context ctx) {
        File path[] = ctx.getExternalFilesDirs(Environment.DIRECTORY_DOCUMENTS);

        File storeitFolder = new File(path[1].getAbsolutePath() + "/storeit");
        if (!storeitFolder.exists()) {
            storeitFolder.mkdirs();
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
                InputStream in ;

                String unique_hash = "";

                try {
                    in = new BufferedInputStream(new FileInputStream(file));
                    unique_hash = HashManager.getChecksum(in);
                    in.close();
                } catch (FileNotFoundException e) {
                    e.printStackTrace();
                } catch (NoSuchAlgorithmException e) {
                    e.printStackTrace();
                } catch (IOException e) {
                    e.printStackTrace();
                }

                StoreitFile stFile = new StoreitFile(toLocalPath(file.getPath()), unique_hash, 1);
                rootFile.addFile(stFile);
            }
        }
    }

    private String toLocalPath(String path){
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

        String path = mDataDir + recursiveSearch(hash, file);
        return path;
    }

    public StoreitFile makeTree() {
        StoreitFile rootFile = new StoreitFile(toLocalPath(mDataDir.getPath() + "/storeit"), "0", 0);
        listDir(new File(mDataDir + "/storeit"), rootFile);
        return rootFile;
    }
}
