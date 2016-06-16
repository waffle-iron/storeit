package com.storeit.storeit.activities;

import android.os.Bundle;
import android.preference.PreferenceActivity;
import android.preference.PreferenceFragment;

import com.storeit.storeit.R;

/**
 * Created by loulo on 16/06/2016.
 */
public class StoreItPreferences extends PreferenceActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getFragmentManager().beginTransaction().replace(android.R.id.content, new MyPreferenceFragment()).commit();
    }

    public static class MyPreferenceFragment extends PreferenceFragment
    {
        @Override
        public void onCreate(final Bundle savedInstanceState)
        {
            super.onCreate(savedInstanceState);
            addPreferencesFromResource(R.xml.preferences);
        }
    }
}

/*
  SharedPreferences SP = PreferenceManager.getDefaultSharedPreferences(getBaseContext());
  String strUserName = SP.getString("username", "NA");
  boolean bAppUpdates = SP.getBoolean("applicationUpdates",false);
  String downloadType = SP.getString("downloadType","1");
*/