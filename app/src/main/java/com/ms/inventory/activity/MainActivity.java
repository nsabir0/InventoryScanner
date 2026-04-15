package com.ms.inventory.activity;

import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.content.Intent;
import android.os.Bundle;
import android.text.InputType;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.ms.inventory.R;
import com.ms.inventory.utils.DBHelper;
import com.ms.inventory.utils.PreferenceManager;

import java.net.NetworkInterface;
import java.util.Collections;
import java.util.List;

/**
 * @noinspection deprecation
 */
public class MainActivity extends AppCompatActivity {

	private static final String TAG = "MainActivity";


	PreferenceManager pref;
	DBHelper DB;
	String sessionId;
	List<String> sessionIds;
	int totalDatabaseItem;

	TextView tvItemQty, tvSession;
 	Button btnImport, btnAdjust,btnDeleteSession;

	private long pressedTime;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);

		DB = new DBHelper(this);
		pref = new PreferenceManager(this);
		sessionId = pref.getSession();
		sessionIds = pref.getSessionIds();

		btnImport = findViewById(R.id.btn_import);
		btnAdjust = findViewById(R.id.btn_adjust);
		tvItemQty = findViewById(R.id.tv_qty);
		tvSession = findViewById(R.id.tv_session);
		btnDeleteSession = findViewById(R.id.btn_delete_session);

		if (pref.isOnlineMode()) {
			btnImport.setVisibility(View.GONE);
//			tvItemQty.setVisibility(View.GONE);
		} else {
			btnImport.setVisibility(View.VISIBLE);
//			tvItemQty.setVisibility(View.VISIBLE);
		}


		if (sessionIds.isEmpty() || sessionIds.get(0).isEmpty()) {
			tvSession.setText(R.string.no_session_selected);
			btnDeleteSession.setVisibility(View.GONE);
		} else {
			tvSession.setText(String.format("Running Sessions: %s", String.join(", ", sessionIds)));
			btnDeleteSession.setVisibility(View.VISIBLE);
		}

		//		if (pref.getSession().isEmpty()) {
//			tvSession.setText(R.string.no_session_selected);
//		} else {
//			tvSession.setText(String.format("Session - %s", pref.getSession()));
//		}

//		Log.e(TAG, "onCreate: mac: " + getMacAddress());

		if (!TextUtils.isEmpty(getMacAddress())) {
			pref.setMacAddress(getMacAddress());
		}

		btnDeleteSession.setOnClickListener(v -> deleteRunningSessions());
	}

	private void deleteRunningSessions() {
		if (sessionIds.isEmpty()) {
			Toast.makeText(this, "No Sessions Found", Toast.LENGTH_SHORT).show();
			return;
		}
		AlertDialog.Builder d = new AlertDialog.Builder(this);
		d.setTitle("Confirmation");
		d.setMessage("Do you want to Delete All the running sessions?");
		d.setNegativeButton("No", (dialog, which) -> dialog.dismiss());

		d.setPositiveButton("Yes", (dialog, which) -> showPasswordDialog());
		d.create().show();
	}

	private void showPasswordDialog() {
		AlertDialog.Builder builder = new AlertDialog.Builder(this);
		builder.setTitle("Enter Password");

		final EditText input = new EditText(this);
		input.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);
		LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
				LinearLayout.LayoutParams.MATCH_PARENT,
				LinearLayout.LayoutParams.MATCH_PARENT
		);
		input.setLayoutParams(params);
		builder.setView(input);

		builder.setPositiveButton("Proceed", (dialog, id) -> {
			String enteredPassword = input.getText().toString();
			String savedPassword = pref.getOfflineUserPassword();

			if (enteredPassword.equals(savedPassword)) {
				DB.deleteScannedData();
				DB.deleteInventoryData();
				DB.addUsedSessions(pref.getSessionIds());
				pref.setSessionIds(null);
				Toast.makeText(MainActivity.this, "Session Deleted successfully.", Toast.LENGTH_LONG).show();

				Intent intent = new Intent(MainActivity.this, LoginActivity.class);
				intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
				dialog.cancel();
				finish();
				startActivity(intent);
			} else {
				Toast.makeText(getApplicationContext(), "Incorrect Password", Toast.LENGTH_SHORT).show();
			}
		});
		builder.setNegativeButton("Cancel", (dialog, id) -> dialog.cancel());

		AlertDialog dialog = builder.create();
		dialog.show();
	}

	public String getMacAddress() {
		try {
			List<NetworkInterface> all = Collections.list(NetworkInterface.getNetworkInterfaces());
			for (NetworkInterface nif : all) {
				if (!nif.getName().equalsIgnoreCase("wlan0")) continue;

				byte[] macBytes = nif.getHardwareAddress();
				if (macBytes == null) {
					return "";
				}

				StringBuilder res1 = new StringBuilder();
				for (byte b : macBytes) {
					res1.append(String.format("%02X:", b));
				}

				int re1=res1.length();

				if (re1 > 0) {
					res1.deleteCharAt(res1.length() - 1);
				} else {
					AlertDialog.Builder builder = new AlertDialog.Builder(this);
					builder.setTitle("Mac Address")
							.setCancelable(false)
							.setMessage("No mac address found!")
							.setPositiveButton("Try Again", (dialog, which) -> {
								dialog.dismiss();
								getMacAddress();
							})
							.setNegativeButton("Cancel", (dialog, which) -> dialog.dismiss())
							.create().show();
				}

				return res1.toString();
			}
		} catch (Exception ignored) {
		}

		return null;
//		return "02:00:00:00:00:00";
	}

	@Override
	protected void onResume() {
		super.onResume();

		updateItems();    //counting items
	}

	@SuppressLint("SetTextI18n")
	private void updateItems() {

		try {
			totalDatabaseItem = DB.countTableItem();
		} catch (Exception e) {
			Log.e(TAG, "count Inventory TableItem error: ", e);
		}

		long qty = totalDatabaseItem;

		if (qty > 0) {
			tvItemQty.setText("Total Items:  " + qty);
		} else {
			tvItemQty.setText(R.string.no_items_are_found);
		}
	}

	public void onClick(View v) {

		int id = v.getId();
		if (id == R.id.btn_item) {
			startActivity(new Intent(this, ScanActivity.class));
		} else if (id == R.id.btn_adjust) {
			startActivity(new Intent(this, AdjustActivity.class));
		} else if (id == R.id.btn_import) {
			startActivity(new Intent(this, ImportActivity.class));
		}
	}

	@Override
	public void onBackPressed() {
		if (pressedTime + 2000 > System.currentTimeMillis()) {
			super.onBackPressed();
			logout();
		} else {
			Toast.makeText(getBaseContext(), "Press back again to exit", Toast.LENGTH_SHORT).show();
		}
		pressedTime = System.currentTimeMillis();
	}


	private void logout() {
		Intent intent = new Intent(MainActivity.this, LoginActivity.class);
		startActivity(intent);
		finish();
	}

}
