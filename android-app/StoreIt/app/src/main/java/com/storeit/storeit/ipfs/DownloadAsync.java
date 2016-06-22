package com.storeit.storeit.ipfs;

import android.app.NotificationManager;
import android.content.Context;
import android.os.AsyncTask;
import android.support.v7.app.NotificationCompat;

import com.storeit.storeit.R;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;

public class DownloadAsync extends AsyncTask<String, Void, Boolean> {
    private NotificationManager mNotifyManager;
    private android.support.v4.app.NotificationCompat.Builder mBuilder;
    private int id = 1;
    private Context mContext;

    public DownloadAsync(Context context) {
        mContext = context;
    }

    protected void onPreExecute() {
        super.onPreExecute();

        mNotifyManager = (NotificationManager) mContext.getSystemService(Context.NOTIFICATION_SERVICE);
        mBuilder = new NotificationCompat.Builder(mContext)
                .setContentTitle("StoreIt")
                .setContentText("Download in progress")
                .setSmallIcon(R.drawable.ic_insert_drive_file_black_24dp);
        mBuilder.setProgress(0, 0, true);

        mNotifyManager.notify(id, mBuilder.build());
    }

    @Override
    protected void onPostExecute(Boolean response) {
        if (!response) {
            mBuilder.setContentText("Error while downloading...")
                    .setProgress(0, 0, false);
        } else {
            mBuilder.setContentText("Download finished")
                    .setProgress(0, 0, false);
        }
        mNotifyManager.notify(id, mBuilder.build());
    }

    @Override
    protected Boolean doInBackground(String... params) {
        String fileName = params[0];
        String path = params[1];
        String hash = params[2];
        IPFS ipfs = new IPFS("toto");

        File filePath = new File(path);
        File file = new File(filePath, fileName);

        FileOutputStream outputStream;
        try {
            outputStream = new FileOutputStream(file);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
            return false;
        }
        return ipfs.downloadFile(outputStream, hash);
    }
}
