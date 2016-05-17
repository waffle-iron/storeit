package com.storeit.storeit;

import android.accounts.AccountManager;
import android.app.Activity;
import android.app.Dialog;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.IBinder;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.google.android.gms.auth.GoogleAuthUtil;
import com.google.android.gms.auth.GooglePlayServicesAvailabilityException;
import com.google.android.gms.auth.UserRecoverableAuthException;
import com.google.android.gms.common.AccountPicker;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.storeit.storeit.protocol.LoginHandler;
import com.storeit.storeit.protocol.StoreitFile;

/*
* Login Activity
* Create tcp service if it's not launched
*/
public class LoginActivity extends Activity implements LoginHandler {

    private boolean mIsBound = false;
    private SocketService mBoundService = null;

    private String mEmail;
    String SCOPE = "oauth2:https://www.googleapis.com/auth/userinfo.profile";

    static final int REQUEST_CODE_PICK_ACCOUNT = 1000;
    static final int REQUEST_CODE_RECOVER_FROM_PLAY_SERVICES_ERROR = 1001;

    private void pickUserAccount(){
        String[] accountTypes = new String[]{GoogleAuthUtil.GOOGLE_ACCOUNT_TYPE};
        Intent intent = AccountPicker.newChooseAccountIntent(null, null,
                accountTypes, true, "Please choose account", null, null, null);
        startActivityForResult(intent, REQUEST_CODE_PICK_ACCOUNT);
    }

    private void getUsername(){
        if (mEmail == null){
            pickUserAccount();
        } else{
            new GetUsernameTask(LoginActivity.this, mEmail, SCOPE).execute();
        }

    }

    public void handleException(final Exception e) {
        // Because this call comes from the AsyncTask, we must ensure that the following
        // code instead executes on the UI thread.
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (e instanceof GooglePlayServicesAvailabilityException) {
                    // The Google Play services APK is old, disabled, or not present.
                    // Show a dialog created by Google Play services that allows
                    // the user to update the APK
                    int statusCode = ((GooglePlayServicesAvailabilityException)e)
                            .getConnectionStatusCode();
                    Dialog dialog = GooglePlayServicesUtil.getErrorDialog(statusCode,
                            LoginActivity.this,
                            REQUEST_CODE_RECOVER_FROM_PLAY_SERVICES_ERROR);
                    dialog.show();
                } else if (e instanceof UserRecoverableAuthException) {
                    // Unable to authenticate, such as when the user has not yet granted
                    // the app access to the account, but the user can fix this.
                    // Forward the user to an activity in Google Play services.
                    Intent intent = ((UserRecoverableAuthException)e).getIntent();
                    startActivityForResult(intent,
                            REQUEST_CODE_RECOVER_FROM_PLAY_SERVICES_ERROR);
                }
            }
        });
    }

    private ServiceConnection mConnection = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            mBoundService = ((SocketService.LocalBinder) service).getService();
            mIsBound = true;
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
            mBoundService = null;
            mIsBound = false;
        }
    };

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data){
        if (requestCode == REQUEST_CODE_PICK_ACCOUNT){
            if (resultCode == RESULT_OK){
                mEmail = data.getStringExtra(AccountManager.KEY_ACCOUNT_NAME);
                getUsername();
            }
            else if (resultCode == RESULT_CANCELED){
                Toast.makeText(this, "Error while obtaining account", Toast.LENGTH_SHORT).show();
            }
        } else if ((
                requestCode == REQUEST_CODE_RECOVER_FROM_PLAY_SERVICES_ERROR)
                && resultCode == RESULT_OK) {
            // Receiving a result that follows a GoogleAuthException, try auth again
            getUsername();
        }
    }

    @Override
    protected void onStart() {
        super.onStart();

     //   Intent intent = new Intent(this, SocketService.class);
     //   bindService(intent, mConnection, Context.BIND_AUTO_CREATE);
    }

    @Override
    protected void onStop() {
        super.onStop();

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

//        filesManager = new FilesManager(this);

        /*
        RequestQueue queue = Volley.newRequestQueue(this);
        String url = "http://192.168.0.102:5001/api/v0/swarm/peers";


        StringRequest stringRequest = new StringRequest(Request.Method.GET, url,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        Log.v("toto", response);
                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Log.v("toto", error.toString());
            }
        });

        queue.add(stringRequest);
        */

        final EditText email = (EditText) findViewById(R.id.login_input_email);
        final EditText password = (EditText) findViewById(R.id.login_input_password);
        Button btn = (Button) findViewById(R.id.login_btn);

        btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                pickUserAccount();

                /*
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

                    mBoundService.sendJOIN(email.getText().toString(), "", file);
                }*/
            }
        });
    }

    @Override
    public void handleJoin(String cmd) {

        int success = 0;

        String[] tokens = cmd.split("\\s");
        if (tokens.length != 2)
            success = 0;
        else
            success = Integer.parseInt(tokens[1]);

        if (success == 1) {
            Intent intent = new Intent(LoginActivity.this, HomeActivity.class);
            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
            startActivity(intent);
        }
        else{
            Toast.makeText(LoginActivity.this, "Invalid login or password", Toast.LENGTH_LONG).show();
        }
    }
}