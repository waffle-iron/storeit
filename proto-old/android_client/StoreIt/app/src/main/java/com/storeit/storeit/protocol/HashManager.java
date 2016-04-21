package com.storeit.storeit.protocol;

import android.util.Log;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.security.DigestInputStream;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.Security;
import java.security.Signature;
import java.security.SignatureException;
import java.util.ArrayList;
import java.util.List;

/**
 * Utility class for hasing and unhashing files
 * Uses sah256 for now
 */
public class HashManager {

    private static final int BUFFER_SIZE = 2048;

    private static byte[] getChecksumByte(InputStream in) throws NoSuchAlgorithmException, IOException {
        MessageDigest md = MessageDigest.getInstance("SHA-256");

        DigestInputStream dis = new DigestInputStream(in, md);
        byte[] buffer = new byte[BUFFER_SIZE];
        try {
            while (dis.read(buffer) != -1){
            }
            dis.close();
        } finally {
            in.close();
        }
        return md.digest();
    }

    public static String getChecksum(InputStream in) throws IOException, NoSuchAlgorithmException {
        byte[] digest = getChecksumByte(in);
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < digest.length; i++){
            sb.append(String.format("%x", digest[i]));
        }
        return sb.toString();
    }
}
