package com.storeit.storeit;

import android.app.Activity;
import android.app.NotificationManager;
import android.content.ClipData;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.support.design.widget.FloatingActionButton;
import android.support.v4.app.Fragment;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.app.NotificationCompat;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.GestureDetector;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;

import com.nononsenseapps.filepicker.FilePickerActivity;

import java.io.File;
import java.util.ArrayList;

public class MainActivity extends AppCompatActivity {

    String TITLES[] = {"Home", "My files", "My account", "Settings"};
    int ICONS[] = {R.drawable.ic_cloud_black_24dp, R.drawable.ic_folder_black_24dp, R.drawable.ic_account_box_black_24dp, R.drawable.ic_settings_applications_black_24dp};

    String NAME = "Louis Mondesir";
    String EMAIL = "louis.mondesir@gmail.com";
    int PROFILE = R.drawable.header_profile_picture;


    static int FILE_CODE_RESULT = 1005;

    static final int HOME_FRAGMENT = 1, FILES_FRAGMENT = 2, ACCOUNT_FRAGMENT = 3, SETTINGS_FRAGMENT = 4;

    RecyclerView mRecyclerView;
    RecyclerView.Adapter mAdapter;
    RecyclerView.LayoutManager mLayoutManager;
    DrawerLayout Drawer;

    ActionBarDrawerToggle mDrawerToggle;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Toolbar toolbar = (Toolbar) findViewById(R.id.tool_bar);
        setSupportActionBar(toolbar);

        mRecyclerView = (RecyclerView) findViewById(R.id.RecyclerView);

        assert mRecyclerView != null;


        final GestureDetector mGestureDetector = new GestureDetector(MainActivity.this, new GestureDetector.SimpleOnGestureListener() {

            @Override
            public boolean onSingleTapUp(MotionEvent e) {
                return true;
            }

        });

        mRecyclerView.setHasFixedSize(true);

        mAdapter = new MyAdapter(TITLES, ICONS, NAME, EMAIL, PROFILE, this);
        mRecyclerView.setAdapter(mAdapter);


        mRecyclerView.addOnItemTouchListener(new RecyclerView.OnItemTouchListener() {
            @Override
            public boolean onInterceptTouchEvent(RecyclerView recyclerView, MotionEvent motionEvent) {
                View child = recyclerView.findChildViewUnder(motionEvent.getX(), motionEvent.getY());


                if (child != null && mGestureDetector.onTouchEvent(motionEvent)) {
                    Drawer.closeDrawers();
                    onTouchDrawer(recyclerView.getChildLayoutPosition(child));
                    return true;
                }

                return false;
            }

            @Override
            public void onTouchEvent(RecyclerView recyclerView, MotionEvent motionEvent) {

            }

            @Override
            public void onRequestDisallowInterceptTouchEvent(boolean disallowIntercept) {

            }
        });

        mLayoutManager = new LinearLayoutManager(this);
        mRecyclerView.setLayoutManager(mLayoutManager);

        Drawer = (DrawerLayout) findViewById(R.id.DrawerLayout);
        mDrawerToggle = new ActionBarDrawerToggle(this, Drawer, toolbar, R.string.drawer_open, R.string.drawer_close) {
            @Override
            public void onDrawerOpened(View drawerView) {
                super.onDrawerOpened(drawerView);
                // code here will execute once the drawer is opened( As I dont want anything happened whe drawer is
                // open I am not going to put anything here)
            }

            @Override
            public void onDrawerClosed(View drawerView) {
                super.onDrawerClosed(drawerView);
                // Code here will execute once drawer is closed
            }


        }; // Drawer Toggle Object Made
        Drawer.addDrawerListener(mDrawerToggle); // Drawer Listener set to the Drawer toggle

        mDrawerToggle.syncState();               // Finally we set the drawer toggle sync State

        FloatingActionButton fbtn = (FloatingActionButton) findViewById(R.id.add_file_button);
        assert fbtn != null;
        fbtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent i = new Intent(MainActivity.this, FilePickerActivity.class);
                i.putExtra(FilePickerActivity.EXTRA_ALLOW_MULTIPLE, false);
                i.putExtra(FilePickerActivity.EXTRA_ALLOW_CREATE_DIR, false);
                i.putExtra(FilePickerActivity.EXTRA_MODE, FilePickerActivity.MODE_FILE);

                i.putExtra(FilePickerActivity.EXTRA_START_PATH, Environment.getExternalStorageDirectory().getPath());
                startActivityForResult(i, FILE_CODE_RESULT);
            }
        });

        openFragment(new HomeFragment());
        ActionBar bar = getSupportActionBar();
        if (bar != null)
            bar.setTitle("Home");
    }

    public void onTouchDrawer(final int position) {

        ActionBar actionBar = getSupportActionBar();

        switch (position) {
            case HOME_FRAGMENT:
                openFragment(new HomeFragment());
                if (actionBar != null)
                    actionBar.setTitle("Home");
                break;
            case FILES_FRAGMENT:
                openFragment(new FileViewerFragment());
                if (actionBar != null)
                    actionBar.setTitle("My Files");
                break;
            case ACCOUNT_FRAGMENT:
                break;
            case SETTINGS_FRAGMENT:
                break;
            default:
                break;
        }
    }

    public void openFragment(final Fragment fragment) {
        android.support.v4.app.FragmentManager fm = getSupportFragmentManager();
        android.support.v4.app.FragmentTransaction ft = fm.beginTransaction();
        ft.replace(R.id.fragment_container, fragment);
        ft.commit();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == FILE_CODE_RESULT && resultCode == Activity.RESULT_OK) {
            if (data.getBooleanExtra(FilePickerActivity.EXTRA_ALLOW_MULTIPLE, false)) {
                ClipData clip = data.getClipData();

                if (clip != null) {
                    for (int i = 0; i < clip.getItemCount(); i++) {
                        Uri uri = clip.getItemAt(i).getUri();

                        Log.v("MainActivity", "lalala " + uri.toString());
                    }
                }
            } else {
                Uri uri = data.getData();
                Log.v("MainActivity", "icici " + uri.toString());
                new IpfsPost().execute(uri.getPath());

            }
        }
    }

    class IpfsPost extends AsyncTask<String, Void, String> {

        private NotificationManager mNotifyManager;
        private android.support.v4.app.NotificationCompat.Builder mBuilder;
        private int id = 1;

        protected void onPreExecute() {
            super.onPreExecute();

            mNotifyManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
            mBuilder = new NotificationCompat.Builder(MainActivity.this)
                    .setContentTitle("StoreIt upload")
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
            return ipfs.sendBytes(new File(fileName));
        }
    }
}
