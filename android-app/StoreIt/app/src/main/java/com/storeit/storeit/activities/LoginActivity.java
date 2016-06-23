package com.storeit.storeit.activities;

import android.accounts.AccountManager;
import android.app.Activity;
import android.app.Dialog;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.net.Uri;
import android.os.Bundle;
import android.os.IBinder;
import android.util.Log;
import android.view.View;
import android.widget.Toast;

import com.google.android.gms.appindexing.Action;
import com.google.android.gms.appindexing.AppIndex;
import com.google.android.gms.auth.GoogleAuthUtil;
import com.google.android.gms.auth.GooglePlayServicesAvailabilityException;
import com.google.android.gms.auth.UserRecoverableAuthException;
import com.google.android.gms.common.AccountPicker;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.common.SignInButton;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.gson.Gson;
import com.storeit.storeit.R;
import com.storeit.storeit.oauth.GetUsernameTask;
import com.storeit.storeit.protocol.FileCommandHandler;
import com.storeit.storeit.protocol.LoginHandler;
import com.storeit.storeit.protocol.command.FileCommand;
import com.storeit.storeit.protocol.command.JoinResponse;
import com.storeit.storeit.services.SocketService;

/*
* Login Activity
* Create tcp service if it's not launched
*/
public class LoginActivity extends Activity {

    static final int REQUEST_CODE_PICK_ACCOUNT = 1000;
    static final int REQUEST_CODE_RECOVER_FROM_PLAY_SERVICES_ERROR = 1001;

    private boolean mIsBound = false;
    private SocketService mBoundService = null;
    private String mEmail;
    String SCOPE = "oauth2:https://www.googleapis.com/auth/userinfo.profile";
    private GoogleApiClient client;

    private LoginHandler mLoginHandler = new LoginHandler() {
        @Override
        public void handleJoin(JoinResponse response) {
            if (response.getCode() == 1) {
                Intent intent = new Intent(LoginActivity.this, MainActivity.class);

                // Stringify fileobject in order to pass it to other activity. It will be save on disk
                // So passing as string is fine
                Gson gson = new Gson();
                String homeJson = gson.toJson(response.getParameters().getHome());

                intent.putExtra("home", homeJson);
                intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                startActivity(intent);
            } else {
                Toast.makeText(LoginActivity.this, "Invalid login or password", Toast.LENGTH_LONG).show();
            }
        }
    };

    private void pickUserAccount() {
        String[] accountTypes = new String[]{GoogleAuthUtil.GOOGLE_ACCOUNT_TYPE};
        Intent intent = AccountPicker.newChooseAccountIntent(null, null,
                accountTypes, true, "Please choose account", null, null, null);
        startActivityForResult(intent, REQUEST_CODE_PICK_ACCOUNT);
    }

    private void getUsername() {
        if (mEmail == null) {
            pickUserAccount();
        } else {
            new GetUsernameTask(LoginActivity.this, mEmail, SCOPE).execute();
        }
    }

    // Google+ token received, sending join cmd
    public void tokenReceived(final String token) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                mBoundService.sendJOIN("google", token);
            }
        });
    }

    public void handleException(final Exception e) {

        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (e instanceof GooglePlayServicesAvailabilityException) {
                    int statusCode = ((GooglePlayServicesAvailabilityException) e)
                            .getConnectionStatusCode();
                    Dialog dialog = GooglePlayServicesUtil.getErrorDialog(statusCode,
                            LoginActivity.this,
                            REQUEST_CODE_RECOVER_FROM_PLAY_SERVICES_ERROR);
                    dialog.show();
                } else if (e instanceof UserRecoverableAuthException) {
                    Intent intent = ((UserRecoverableAuthException) e).getIntent();
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
            mBoundService.setmLoginHandler(mLoginHandler);
            mIsBound = true;
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
            mBoundService = null;
            mIsBound = false;
        }
    };

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == REQUEST_CODE_PICK_ACCOUNT) {
            if (resultCode == RESULT_OK) {
                mEmail = data.getStringExtra(AccountManager.KEY_ACCOUNT_NAME);
                getUsername();
            } else if (resultCode == RESULT_CANCELED) {
                Toast.makeText(this, "Error while obtaining account", Toast.LENGTH_SHORT).show();
            }
        } else if ((
                requestCode == REQUEST_CODE_RECOVER_FROM_PLAY_SERVICES_ERROR)
                && resultCode == RESULT_OK) {
            getUsername();
        }
    }

    @Override
    protected void onStart() {
        super.onStart();

        client.connect();
        Action viewAction = Action.newAction(
                Action.TYPE_VIEW,
                "Login Page",
                Uri.parse("http://host/path"),
                Uri.parse("android-app://com.storeit.storeit/http/host/path")
        );
        AppIndex.AppIndexApi.start(client, viewAction);

        Intent socketService = new Intent(this, SocketService.class);
        bindService(socketService, mConnection, Context.BIND_AUTO_CREATE);
    }

    @Override
    protected void onStop() {
        super.onStop();
        Action viewAction = Action.newAction(
                Action.TYPE_VIEW,
                "Login Page",
                Uri.parse("http://host/path"),
                Uri.parse("android-app://com.storeit.storeit/http/host/path")
        );
        AppIndex.AppIndexApi.end(client, viewAction);

/*        if (mIsBound) {
            unbindService(mConnection);
            mIsBound = false;
        }
        */
        client.disconnect();
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        SignInButton button = (SignInButton) findViewById(R.id.google_login);
        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                pickUserAccount();
            }
        });
        client = new GoogleApiClient.Builder(this).addApi(AppIndex.API).build();
    }
}