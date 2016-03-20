package com.storeit.storeit.protocol;

import java.util.ArrayList;

/**
 * Created by loulo on 19/01/2016.
 */
public class StoreitFile {
    private String path;
    private String unique_hash;
    private int kind;
    private ArrayList<String> chunks_hashes;
    private ArrayList<StoreitFile> files;

    public StoreitFile(String path, String unique_hash, int kind) {
        this.path = path;
        this.unique_hash = unique_hash;
        this.kind = kind;
        this.chunks_hashes = new ArrayList<>();
        this.files = new ArrayList<>();
    }

    public ArrayList<StoreitFile> getFiles() {
        return files;
    }

    public void addFile(StoreitFile file) {
        this.files.add(file);
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public String getUnique_hash() {
        return unique_hash;
    }

    public void setUnique_hash(String unique_hash) {
        this.unique_hash = unique_hash;
    }

    public int getKind() {
        return kind;
    }

    public void setKind(int kind) {
        this.kind = kind;
    }

    public ArrayList<String> getChunksHashes() {
        return chunks_hashes;
    }

    public void addChunkHash(String chunks_hash) {
        this.chunks_hashes.add(chunks_hash);
    }

    public String toJson() {
        return "{}";
    }
}
