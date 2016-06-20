package com.storeit.storeit.ipfs;

import android.app.NotificationManager;
import android.content.Context;
import android.os.AsyncTask;
import android.support.v7.app.NotificationCompat;
import android.util.Log;

import com.storeit.storeit.R;

import java.io.File;

public class UploadAsync extends AsyncTask<String, Void, String> {

    private NotificationManager mNotifyManager;
    private android.support.v4.app.NotificationCompat.Builder mBuilder;
    private int id = 1;
    private Context mContext;

    public UploadAsync(Context context){
        mContext = context;
    }

    protected void onPreExecute() {
        super.onPreExecute();

        mNotifyManager = (NotificationManager)mContext.getSystemService(Context.NOTIFICATION_SERVICE);
        mBuilder = new NotificationCompat.Builder(mContext)
                .setContentTitle("StoreIt")
                .setContentText("Upload in progress")
                .setSmallIcon(R.drawable.ic_insert_drive_file_black_24dp);
        mBuilder.setProgress(0, 0, true);

        mNotifyManager.notify(id, mBuilder.build());
    }

    @Override
    protected void onPostExecute(String response) {


        if (response.equals("")) {
            mBuilder.setContentText("Upload failed...")
                    .setProgress(0, 0, false);
        } else {
            mBuilder.setContentText(response)
                    .setProgress(0, 0, false);
            Log.v("IPFS", response);
        }

        mNotifyManager.notify(id, mBuilder.build());
    }

    @Override
    protected String doInBackground(String... params) {

        String fileName = params[0];
        IPFS ipfs = new IPFS("toto");
        return ipfs.sendFile(new File(fileName));
    }
}