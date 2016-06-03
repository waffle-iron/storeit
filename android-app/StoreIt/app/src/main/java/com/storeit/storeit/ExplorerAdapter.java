package com.storeit.storeit;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;
import com.storeit.storeit.protocol.StoreitFile;
import java.util.ArrayList;
import java.util.Map;

/**
 * Created by loulo on 24/05/2016.
 */
public class ExplorerAdapter extends RecyclerView.Adapter<ExplorerAdapter.ViewHolder> {

    private StoreitFile[] mFiles;
    Context context;

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

    ExplorerAdapter(StoreitFile file, Context passedContext) {

        ArrayList<StoreitFile> files = new ArrayList<>();

        for (Map.Entry<String, StoreitFile> entry : file.getFiles().entrySet()) { // list all files from current folder
            files.add(entry.getValue());
        }

        mFiles = files.toArray(new StoreitFile[files.size()]); // Store file list
        this.context = passedContext;
    }

    public void fileClicked(int position){

        ArrayList<StoreitFile> files = new ArrayList<>();

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
        holder.fileNameTextView.setText(mFiles[position].getPath()); // Get file name
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
