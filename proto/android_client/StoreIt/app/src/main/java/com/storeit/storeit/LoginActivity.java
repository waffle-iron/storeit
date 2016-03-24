package com.storeit.storeit;
import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.IBinder;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;
import com.squareup.otto.Bus;
import com.squareup.otto.Subscribe;
import com.storeit.storeit.protocol.StoreItProtocol;
import com.storeit.storeit.protocol.StoreitFile;
import com.storeit.storeit.protocol.StoreitHandler;

/*
* Login Activity
* Create tcp service if it's not launched
*/
public class LoginActivity extends Activity implements StoreitHandler {

    private boolean mIsBound = false;
    private SocketService mBoundService = null;

    private ServiceConnection mConnection = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            mBoundService = ((SocketService.LocalBinder) service).getService();
            mIsBound = true;
            mBoundService.setStoreitHandler(LoginActivity.this);
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
            mBoundService = null;
            mIsBound = false;
        }
    };

    @Subscribe
    public void getMessage(String s) {
        Toast.makeText(LoginActivity.this, s, Toast.LENGTH_LONG).show();
    }

    @Subscribe
    public void getMessage(StoreItProtocol.NetworkCommand c) {

    }

    @Override
    protected void onStart() {
        super.onStart();

        Intent intent = new Intent(this, SocketService.class);
        bindService(intent, mConnection, Context.BIND_AUTO_CREATE);
    }

    @Override
    protected void onStop() {
        super.onStop();

        Bus bus = OttoManager.getBus();
        bus.unregister(this);

        if (mIsBound) {
            unbindService(mConnection);
            mIsBound = false;
        }
    }

    FilesManager filesManager;
    StoreitFile file;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        filesManager = new FilesManager(this);

        Bus bus = OttoManager.getBus();
        bus.register(this);

//        filesManager.listFiles();

        final EditText email = (EditText) findViewById(R.id.login_input_email);
        final EditText password = (EditText) findViewById(R.id.login_input_password);
        Button btn = (Button) findViewById(R.id.login_btn);

        btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (mBoundService != null) {
                    if (!mBoundService.isConnected()) {
                        Toast.makeText(LoginActivity.this, "No internet connection", Toast.LENGTH_SHORT).show();
                        return;
                    }

                    if (email.getText().toString().isEmpty()) {
                        Toast.makeText(LoginActivity.this, "Please enter a login", Toast.LENGTH_SHORT).show();
                        return;
                    }

                    if (password.getText().toString().isEmpty()) {
                        Toast.makeText(LoginActivity.this, "Please enter a password", Toast.LENGTH_LONG).show();
                        return;
                    }

                    file = filesManager.makeTree();
                    mBoundService.sendJoin(email.getText().toString(), password.getText().toString(), file);
/*
                    Intent intent = new Intent(LoginActivity.this, HomeActivity.class);
                    intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                    startActivity(intent);
                    */
                }
            }
        });
    }

    @Override
    public void handleCHSEND(int send, String hash, String ip, int port) {
        if (send == 1) {
            String chunkPath = filesManager.getFileByHash(hash, file);
            Intent serviceIntent = new Intent(this, SendService.class);
            serviceIntent.putExtra("ip", ip);
            serviceIntent.putExtra("port", port);
            serviceIntent.putExtra("chunkPath", chunkPath);
            startService(serviceIntent);
        }
    }
}

