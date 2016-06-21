package com.storeit.storeit.adapters;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.MimeTypeMap;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;
import com.storeit.storeit.R;
import com.storeit.storeit.protocol.StoreitFile;

import java.io.File;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Deque;
import java.util.Map;

public class ExplorerAdapter extends RecyclerView.Adapter<ExplorerAdapter.ViewHolder> {

    private StoreitFile[] mFiles;
    private Deque<StoreitFile> historyStack = new ArrayDeque<>();
    private Context context;
    private String storeitPath;

    public static class ViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
        TextView fileNameTextView;
        ImageView fileTypeImageView;
        Context contxt;

        public ViewHolder(View itemView, int ViewType, Context c) {
            super(itemView);
            contxt = c;
            itemView.setClickable(true);
            itemView.setOnClickListener(this);
            fileNameTextView = (TextView) itemView.findViewById(R.id.file_item_row_name);
            fileTypeImageView = (ImageView) itemView.findViewById(R.id.explorer_image_file_type);
        }

        @Override
        public void onClick(View v) {
            Toast.makeText(contxt, "The Item Clicked is: " + getPosition(), Toast.LENGTH_SHORT).show();
        }
    }

    public ExplorerAdapter(StoreitFile file, Context passedContext, String path) {

        ArrayList<StoreitFile> files = new ArrayList<>();

        for (Map.Entry<String, StoreitFile> entry : file.getFiles().entrySet()) { // list all files from current folder
            files.add(entry.getValue());
        }

        historyStack.push(file);

        mFiles = files.toArray(new StoreitFile[files.size()]); // Store file list
        this.context = passedContext;
        storeitPath = path;
    }

    public void backPressed() {

         if (historyStack.size() <= 1) // Check if this is not the root
            return;

        ArrayList<StoreitFile> files = new ArrayList<>();
        historyStack.pop();
        StoreitFile parentDir = historyStack.peek();

        for (Map.Entry<String, StoreitFile> entry : parentDir.getFiles().entrySet()) { // list all files from current folder
            files.add(entry.getValue());
        }
        mFiles = files.toArray(new StoreitFile[files.size()]); // Store file list
        notifyDataSetChanged();
    }

    public void fileClicked(int position){

        if (mFiles[position].getKind() == 1) // Check if is a directory or a file
        {
            Intent intent = new Intent(Intent.ACTION_VIEW);
            File file = new File(storeitPath + File.separator + mFiles[position].getPath());

            String extension = MimeTypeMap.getFileExtensionFromUrl(Uri.fromFile(file).toString());
            String mimetype = MimeTypeMap.getSingleton().getMimeTypeFromExtension(extension);
            intent.setDataAndType(Uri.fromFile(file), mimetype);

            context.startActivity(intent);

            return;
        }


        ArrayList<StoreitFile> files = new ArrayList<>();

        historyStack.push(mFiles[position]);

        for (Map.Entry<String, StoreitFile> entry : mFiles[position].getFiles().entrySet()) { // list all files from current folder
            files.add(entry.getValue());
        }
        mFiles = files.toArray(new StoreitFile[files.size()]); // Store file list

        notifyDataSetChanged();
    }

    @Override
    public ExplorerAdapter.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.file_item_row, parent, false);
        return new ViewHolder(v, viewType, context);
    }

    @Override
    public void onBindViewHolder(ExplorerAdapter.ViewHolder holder, int position) {
        holder.fileNameTextView.setText(mFiles[position].getFileName()); // Get file name
        if (mFiles[position].getKind() == 0) { // Directory, we use folder icon
            holder.fileTypeImageView.setImageResource(R.drawable.ic_folder_black_24dp);
        } else { // File, we use file icon
            holder.fileTypeImageView.setImageResource(R.drawable.ic_insert_drive_file_black_24dp);
        }
    }

    @Override
    public int getItemCount() {
        return mFiles.length;
    }
}
