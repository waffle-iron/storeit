package com.storeit.storeit;

import android.util.Log;

import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.net.URLConnection;
import java.nio.charset.Charset;
import java.security.cert.CRL;

import static java.lang.System.currentTimeMillis;

/**
 * Created by loulo on 03/05/2016.
 */
public class IPFS {

    private String m_nodeUrl;
    private static final String CRLF = "\r\n";
    private static final String CHARSET = "UTF-8";
    private static final int CONNECT_TIMEOUT = 15000;
    private static final int READ_TIMEOUT = 10000;


    public IPFS(String url){
        m_nodeUrl = url;
    }

    public String sendBytes(File uploadFile){

        HttpURLConnection connection;
        OutputStream outputStream;
        PrintWriter writer;
        String boundary;

        URL url = null;
        long start;


        try {
            url = new URL("http://192.168.0.102:5001/api/v0/add?stream-cannels=true");

            boundary = "---------------------------" + currentTimeMillis();
            connection = (HttpURLConnection) url.openConnection();
            connection.setConnectTimeout(CONNECT_TIMEOUT);
            connection.setReadTimeout(READ_TIMEOUT);
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Accept-Charset", CHARSET);
            connection.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary);
            connection.setUseCaches(false);
            connection.setDoInput(true);
            connection.setDoOutput(true);

            outputStream = connection.getOutputStream();
            writer = new PrintWriter(new OutputStreamWriter(outputStream, CHARSET),
                    true);

            /*
            curl 'http://192.168.0.102:5001/api/v0/add?stream-cannels=true'
            -H 'content-type: multipart/form-data; boundary=a831rwxi1a3gzaorw1w2z49dlsor'
            -H 'Connection: keep-alive'
            \--data-binary $'--a831rwxi1a3gzaorw1w2z49dlsor\r\nContent-Type: application/octet-stream\r\nContent-Disposition: file; name="file"; filename="Hello.txt"\r\n\r\nhello--a831rwxi1a3gzaorw1w2z49dlsor--'
            --compressed
             */

            writer.append("--").append(boundary).append(CRLF)
                    .append("Content-Type: application/octet-stream").append(CRLF)
                    .append("Content-Disposition : file; name=\"file\"; filename=\"" + uploadFile.getName() + "\"").append(CRLF)
                    .append("Content-Transfer-Encoding: binary").append(CRLF)
                    .append(CRLF);

            writer.flush();
            outputStream.flush();


            try (final FileInputStream inputStream = new FileInputStream(uploadFile);) {
                final byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = inputStream.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, bytesRead);
                }
                outputStream.flush();
            }
            writer.append(CRLF);

            writer.append(CRLF).append("--").append(boundary).append("--")
                    .append(CRLF);
            writer.close();

            final int status = connection.getResponseCode();

            if (status != HttpURLConnection.HTTP_OK) {
                Log.v("IPFS", "HTTP PAS OK");
                return "";
            }

            InputStream is = connection.getInputStream();

            final ByteArrayOutputStream response = new ByteArrayOutputStream();
            final byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = is.read(buffer)) != -1) {
                response.write(buffer, 0, bytesRead);
            }

            return response.toString(CHARSET);

        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        } catch (ProtocolException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return "";
    }


}
