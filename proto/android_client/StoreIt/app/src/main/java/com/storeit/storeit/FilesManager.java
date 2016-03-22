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
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.security.NoSuchAlgorithmException;
import java.util.Deque;

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

    private void recursiveListFile(File root) {
        File[] files = root.listFiles();

        for (File file : files) {
            if (file.isDirectory()) {
                Log.d(LOGTAG, "[" + file.getAbsoluteFile() + "] : ");
                recursiveListFile(file);
            } else {
                Log.d(LOGTAG, "-" + file.getAbsoluteFile());
            }
        }
    }

    public void listFiles() {
        recursiveListFile(mDataDir);
    }

    private void goDown(File root, StoreitFile rootFile) {
        File[] files = root.listFiles();

        for (File file : files) {
            if (file.isDirectory()) {
                StoreitFile dir = new StoreitFile(file.getPath(), "0", 0);
                rootFile.addFile(dir);
                goDown(file, dir);
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

                Log.v(LOGTAG, file.getPath() + " : " + unique_hash);

                StoreitFile stFile = new StoreitFile(file.getPath(), unique_hash, 1);
                rootFile.addFile(stFile);
            }
        }
    }

    public StoreitFile makeTree() {
        StoreitFile rootFile = new StoreitFile(mDataDir.getPath() + "/storeit", "0", 0);
        goDown(new File(mDataDir + "/storeit"), rootFile);

        return rootFile;
    }
}
