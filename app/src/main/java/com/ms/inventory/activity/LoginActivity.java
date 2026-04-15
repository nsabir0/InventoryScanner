package com.ms.inventory.activity;

import android.app.ProgressDialog;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.android.volley.Request;
import com.android.volley.toolbox.StringRequest;
import com.ms.inventory.R;
import com.ms.inventory.utils.AppController;
import com.ms.inventory.utils.DBHelper;
import com.ms.inventory.utils.PreferenceManager;
import com.ms.inventory.utils.Utils;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Objects;

/**
 * @noinspection deprecation
 */
public class LoginActivity extends AppCompatActivity {

    private static final String TAG = "LoginActivity";

    DBHelper DB;
    ProgressDialog progressDialog;
    EditText edtUser, editPassword;
    View point;
    TextView tvAppVersion, textMode;

    String showTotalScanQty;
    String showTempScanQty;

    private PreferenceManager pref;
    private SharedPreferences.OnSharedPreferenceChangeListener preferenceChangeListener;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        if (getSupportActionBar() != null) {
            getSupportActionBar().hide();
        }

        DB = new DBHelper(LoginActivity.this);
        showTotalScanQty = DB.getTotalScanQty();
        showTempScanQty = DB.getTempTotalScanQty();
        pref = new PreferenceManager(this);
        progressDialog = new ProgressDialog(this);
        progressDialog.setMessage("Please wait...");
        progressDialog.setCancelable(false);

        edtUser = findViewById(R.id.edt_user);
        editPassword = findViewById(R.id.edit_password);
        point = findViewById(R.id.point);
        tvAppVersion = findViewById(R.id.tv_app_version);
        textMode = findViewById(R.id.text_mode);

        edtUser.setOnEditorActionListener((v, actionId, event) -> {
            if (actionId == EditorInfo.IME_ACTION_GO || actionId == EditorInfo.IME_ACTION_DONE) {

                loginData();
                return true;
            }
            return false;
        });

        updateAppVersion();
        updateAppModeUI();

//        if (pref.isOnlineMode()) {
//            point.setBackgroundResource(R.drawable.circle_shape_green);
//            textMode.setText(R.string.online_mode);
//        } else {
//            point.setBackgroundResource(R.drawable.circle_shape);
//            textMode.setText(R.string.offline_mode);
//        }

        // Updating AppMode UI according to Preferences Settings
        preferenceChangeListener = (sharedPreferences, key) -> {
            if (Objects.equals(key, "pref_key_working_mode")) {
                updateAppModeUI();
            }
        };
        pref.registerOnSharedPreferenceChangeListener(preferenceChangeListener);

        textMode.setOnClickListener(v -> {
            boolean isCurrentlyOnline = pref.isOnlineMode();
            pref.setOnlineMode(!isCurrentlyOnline);
        });

        point.setOnClickListener(v -> {
            boolean isCurrentlyOnline = pref.isOnlineMode();
            pref.setOnlineMode(!isCurrentlyOnline);
        });

    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        pref.unregisterOnSharedPreferenceChangeListener(preferenceChangeListener);
    }

    private void updateAppModeUI() {
        if (pref.isOnlineMode()) {
            point.setBackgroundResource(R.drawable.circle_shape_green);
            textMode.setText(R.string.online_mode);
        } else {
            point.setBackgroundResource(R.drawable.circle_shape);
            textMode.setText(R.string.offline_mode);
        }
    }

    private void updateAppVersion() {
        PackageManager manager = getPackageManager();
        PackageInfo info;

        try {
            info = manager.getPackageInfo(getPackageName(), 0);
            String versionTxt = "v" + info.versionName;
            tvAppVersion.setText(versionTxt);
        } catch (PackageManager.NameNotFoundException e) {
//            e.printStackTrace();
            Log.e("TAG", "Item Row: ", e);
        }
    }

    public void onClick(View v) {

        if (v.getId() == R.id.btn_save) {
//			goToImportActivity();
            loginData();
        } else if (v.getId() == R.id.btn_setting) {
            //startActivity(new Intent(this, SettingActivity.class));
            Intent intent = new Intent(this, MainPreferencesActivity.class);
//            intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
//            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//            finish();
            startActivity(intent);
        }

    }

    private void goToMainActivity() {
        finish();
        Intent intent;
        if (!pref.isOnlineMode() || pref.isOnlineMode() && showTotalScanQty != null || pref.isOnlineMode() && showTempScanQty != null) {
            intent = new Intent(LoginActivity.this, MainActivity.class);
        } else {
            intent = new Intent(LoginActivity.this, SessionActivity.class);
        }
        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        startActivity(intent);
    }

    private void loginData() {
        //if (pref.isOnlineMode()){
        if (pref.getOutletCode().isEmpty() || pref.getZoneName().isEmpty()) {
            Utils.errorDialog(this, "Missing Configure", "One or more settings is missing.", true);
            return;
        }

        if (pref.isOnlineMode() && pref.getHost().isEmpty()) {
            Utils.errorDialog(this, "IP Missing", "IP address is not found. Please enter it first.", true);
            return;
        }
        //}

        final String userName = edtUser.getText().toString();
        final String userPassword = editPassword.getText().toString();
//		final String deviceId= DeviceUtils.getDeviceId(this);

        if (userName.isEmpty()) {
            edtUser.setError(getString(R.string.user_name_emp_field_err));
        } else if (userPassword.isEmpty()) {
            editPassword.setError(getString(R.string.emp_pass_field_err));
        } else {
            progressDialog.show();

            if (pref.isOnlineMode()) {

                String url = pref.getBaseUrl() + "data/";

                String endUrl = String.format("login?userName=%s&password=%s", userName, userPassword);
                String fullUrl = url + endUrl;

                StringRequest stringRequest = new StringRequest(Request.Method.GET, fullUrl,
                        response -> {
                            progressDialog.dismiss();
                            Log.e(TAG, "loginDataResponse: " + response);

                            try {
                                JSONObject jsonResponse = new JSONObject(response);
                                boolean status = jsonResponse.getBoolean("Status");
                                if (status) {
                                    pref.saveOfflineUserInfo(userName, userPassword);
                                    pref.setUser(userName);
                                    goToMainActivity();
                                } else {
                                    String message = jsonResponse.getString("Message");
                                    Toast.makeText(LoginActivity.this, message, Toast.LENGTH_SHORT).show();
                                }
                            } catch (JSONException e) {
                                Log.e(TAG, "onErrorResponse: " + e);
                                Toast.makeText(LoginActivity.this, "JSON parsing error", Toast.LENGTH_SHORT).show();
                            }
                        }, error -> {
                    progressDialog.dismiss();
                    Log.e(TAG, "onErrorResponse: " + error.getMessage());
                    Toast.makeText(LoginActivity.this, "Failed: " + error.getMessage(), Toast.LENGTH_SHORT).show();
                });

                // Add the request to the RequestQueue.
                AppController.getInstance().addToRequestQueue(stringRequest);
            } else {
                progressDialog.dismiss();

                if (pref.getOfflineUserName().equalsIgnoreCase("") &&
                        pref.getOfflineUserPassword().equalsIgnoreCase("")) {

                    Toast.makeText(this, "Please login first in online mode", Toast.LENGTH_SHORT).show();

                } else if (pref.getOfflineUserName().equalsIgnoreCase(userName) &&
                        pref.getOfflineUserPassword().equalsIgnoreCase(userPassword)) {

                    goToMainActivity();
                } else {
                    Toast.makeText(this, "Invalid user & password combination.", Toast.LENGTH_SHORT).show();
                }
            }


        }
    }
}
