package com.storeit.storeit;

import java.io.BufferedOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;

/**
 * Created by loulo on 03/05/2016.
 */
public class IPFS {

    private String url;

    public IPFS(String url){
        this.url = url;
    }

    public void addBytes(String fileName, Byte[] data){

        URL url = null;
        HttpURLConnection client = null;

        try {
            url = new URL(url + "/toto");
            client = (HttpURLConnection) url.openConnection();

            client.setRequestMethod("POST");
            client.setRequestProperty("key", "value");
            client.setDoOutput(true);

            OutputStream outputPost = new BufferedOutputStream(client.getOutputStream());
          //   writeStream(outputPost);
        } catch (ProtocolException e) {
            e.printStackTrace();
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

    }
}
