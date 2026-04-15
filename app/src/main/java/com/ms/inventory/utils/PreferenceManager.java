package com.ms.inventory.utils;

import android.content.Context;
import android.content.SharedPreferences;
import android.text.TextUtils;
import android.util.Log;

import com.ms.inventory.model.Configuration;
import com.orm.SugarContext;
import com.orm.SugarRecord;

import java.util.Arrays;
import java.util.List;

/**
 * @noinspection deprecation
 */
public class PreferenceManager {

	SharedPreferences pref;
	SharedPreferences.Editor editor;

	public PreferenceManager(Context context) {
		SugarContext.init(context);
		//pref = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE);
		pref = android.preference.PreferenceManager.getDefaultSharedPreferences(context);
		editor = pref.edit();
	}

	public void registerOnSharedPreferenceChangeListener(SharedPreferences.OnSharedPreferenceChangeListener listener) {
		pref.registerOnSharedPreferenceChangeListener(listener);
	}

	public void unregisterOnSharedPreferenceChangeListener(SharedPreferences.OnSharedPreferenceChangeListener listener) {
		pref.unregisterOnSharedPreferenceChangeListener(listener);
	}

	public boolean isOnlineMode() {
		String mode = pref.getString("pref_key_working_mode", "Online");
		return mode.equalsIgnoreCase("Online");
	}

	public void setOnlineMode(boolean isOnline) {
		editor.putString("pref_key_working_mode", isOnline ? "Online" : "Offline");
		editor.apply();
	}

	public void setUser(String user) {
		SharedPreferences.Editor editor = pref.edit();
		editor.putString("USER", user);
		editor.apply();
	}

	public String getUser() {
		return pref.getString("USER", "");
	}

	public void setSession(String session) {
		SharedPreferences.Editor editor = pref.edit();
		editor.putString("session", session);
		editor.apply();
	}

	public String getSession() {
		return pref.getString("session", "");
	}

	public void setSessionIds(List<String> sessionIds) {
		SharedPreferences.Editor editor = pref.edit();
		if (sessionIds == null) {
			editor.remove("SESSION_IDS");
		} else {
			String sessionIdsString = TextUtils.join(",", sessionIds);
			editor.putString("SESSION_IDS", sessionIdsString);
		}
		editor.apply();
	}

	public List<String> getSessionIds() {
		String sessionIdsString = pref.getString("SESSION_IDS", "");
		return Arrays.asList(sessionIdsString.split(","));
	}


	public void saveData(String host, String deviceId, String zoneName, String outletCode) {
		SharedPreferences.Editor editor = pref.edit();
		editor.putString("HOST", host);
		editor.putString("DEVICE_ID", deviceId);
		editor.putString("ZONE_NAME", zoneName);
		editor.putString("OUTLET_CODE", outletCode);
		editor.apply();

		try {
			long count = SugarRecord.count(Configuration.class);

			if (count > 0) {
				SugarRecord.deleteAll(Configuration.class);
			}
		} catch (Exception e) {
			Log.e("Abir001", "save SugarRecord: ", e);
		}

		try {
			Configuration config = new Configuration(1, host, deviceId, zoneName, outletCode);
			config.save();
		} catch (Exception e) {
			Log.e("Abir001", "save Configuration: ", e);
		}


	}

	public void saveOfflineUserInfo(String username, String password) {
//		SharedPreferences loginPreferences = getActivity().getSharedPreferences("offline_reg", 0);
		SharedPreferences.Editor editor = pref.edit();
		editor.putString("user_name", username);
		editor.putString("password", password);
		editor.apply();
	}

	public String getOfflineUserName() {
		return pref.getString("user_name", "");
	}

	public String getOfflineUserPassword() {
		return pref.getString("password", "");
	}

	public String getHost() {
		return pref.getString("HOST", "");
	}

	public String getDeviceId() {
		return pref.getString("DEVICE_ID", "");
	}

	public String getZoneName() {
		return pref.getString("ZONE_NAME", "");
	}

	public String getOutletCode() {
		return pref.getString("OUTLET_CODE", "");
	}

	//	public boolean isOnlineMode() {
//		boolean isOnline = true;
//		String mode = pref.getString("pref_key_working_mode", "Online");
//
//		if (!mode.equalsIgnoreCase("Online")) {
//			isOnline = false;
//		}
//
//		return isOnline;
//	}

	public boolean isMultiScanQty() {
		return pref.getBoolean("pref_key_multi_scan_qty", true);
	}

	public boolean isStockVisible() {
		return pref.getBoolean("pref_key_stock_visibility", true);
	}

	public boolean isItemCodeVisible() {
		return pref.getBoolean("pref_key_item_cv", false);
	}

	public boolean isScanBySBarcode() {
		return pref.getBoolean("pref_key_scan_by_sBarcode", true);
	}

	public void setBarCode(String barCode) {
		SharedPreferences.Editor editor = pref.edit();
		editor.putString("BAR_CODE", barCode);
		editor.apply();
	}

	public String getBarCode() {
		return pref.getString("BAR_CODE", "");
	}

	public void setMacAddress(String macAddress) {
		SharedPreferences.Editor editor = pref.edit();
		editor.putString("MAC_ADDRESS", macAddress);
		editor.apply();
	}

	public String getBaseUrl() {
		String host = getHost().toLowerCase();

		if (!host.startsWith("http") && !host.startsWith("https")) {
			host = "http://" + host;
		}

		if (!host.endsWith("/")) {
			host = host + "/";
		}

		return host + "api/";
	}

}