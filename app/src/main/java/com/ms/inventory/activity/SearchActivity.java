package com.ms.inventory.activity;

import android.annotation.SuppressLint;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.android.volley.DefaultRetryPolicy;
import com.android.volley.Request;
import com.android.volley.toolbox.StringRequest;
import com.ms.inventory.R;
import com.ms.inventory.adapter.ItemSearchAdapter;
import com.ms.inventory.model.InventoryData;
import com.ms.inventory.model.ItemSearch;
import com.ms.inventory.utils.AppController;
import com.ms.inventory.utils.DBHelper;
import com.ms.inventory.utils.JsonValidator;
import com.ms.inventory.utils.PreferenceManager;
import com.ms.inventory.utils.Utils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/**
 * @noinspection deprecation
 */
public class SearchActivity extends AppCompatActivity {

	private static final String TAG = "SearchActivity";

	DBHelper DB;
	PreferenceManager pref;
	private ProgressDialog dialog;

	EditText edtSearch;
	ListView listView;

	List<InventoryData.Data> searchedList = new ArrayList<>();

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_search);
		Objects.requireNonNull(getSupportActionBar()).setTitle("Search Item");

		DB = DBHelper.getInstance(this);
		pref = new PreferenceManager(this);
		dialog = new ProgressDialog(this);

		edtSearch = findViewById(R.id.edt_search);
		listView = findViewById(R.id.listview);

		edtSearch.setOnEditorActionListener((v, actionId, event) -> {
			if (actionId == EditorInfo.IME_ACTION_SEARCH) {
				searchItem();
				return true;
			}
			return false;
		});

		listView.setOnItemClickListener((parent, view, position, id) -> {
			InventoryData.Data item = searchedList.get(position);

			Intent intent = getIntent();
			intent.putExtra("ITEM", item);
			setResult(RESULT_OK, intent);
			finish();
		});
	}

	public void onClick(View v) {
		searchItem();
	}

	private void searchItem() {
		if (pref.isOnlineMode()) {
			searchItemForOnline();
		} else {
			//searchItemForOffline();
			new searchItemAsyncTask().execute();
		}
	}

	private void searchItemForOnline() {
		dialog.setMessage("Please wait...");
		dialog.show();

		String query = edtSearch.getText().toString().trim().toLowerCase();
		String baseUrl = pref.getBaseUrl();
		String depoCode = pref.getOutletCode();
		String url;

		Log.e(TAG, "searchItemForOnline: " + query);

		url = baseUrl + "Data/GetByBarcode?barcode=&depoCode=" + depoCode + "&searchText=" + query;
		Log.e(TAG, "searchItemForOnline: " + url);
		searchResult(url);
	}

	private void searchResult(String url) {
		StringRequest strq = new StringRequest(Request.Method.GET, url, response -> {
			JsonValidator jv = new JsonValidator();
			searchedList = new ArrayList<>();

			try {
				JSONObject json = new JSONObject(response);
				Log.e("TAG", "on SearchResult Response: " + response);
				boolean status = jv.getBoolean(json, "Status");

				if (status) {
					JSONArray data = json.getJSONArray("ReturnData");

					if (data.length() > 0) {

						for (int i = 0; i < data.length(); i++) {
							JSONObject j = data.getJSONObject(i);

							String itemCode = jv.getString(j, "PRODUCTCODE");
							String name = jv.getString(j, "PRODUCTNAME");
							double currentStock = jv.getDouble(j, "CurrentStock");
							double sale = jv.getDouble(j, "SALES");
							double unitPrice = jv.getDouble(j, "UnitPrice");

							ItemSearch itemSearch = new ItemSearch(itemCode, itemCode, name, (int) currentStock, (int) sale, unitPrice);
							Log.e(TAG, "SearchResult: " + itemSearch.barcode+" "+itemSearch.name);

							searchedList = DB.getOfflineItemByBarcode(itemCode);
							if(searchedList.isEmpty()){
								Toast.makeText(this, "Product not exists in inventory", Toast.LENGTH_SHORT).show();
							}


						}
					} else {
						new searchItemAsyncTask().execute();
					}
				}

				dialog.dismiss();
				ItemSearchAdapter adapter = new ItemSearchAdapter(SearchActivity.this, searchedList);
				listView.setAdapter(adapter);

			} catch (JSONException e) {
				Log.e(TAG, "searchResult: ", e);
			}
		}, error -> {
			if (dialog != null) {
				dialog.dismiss();
			}
			Log.e("TAG", "Error ", error);
			Utils.errorDialog(SearchActivity.this, "Connection Error", error.getMessage());
		});

		strq.setRetryPolicy(new DefaultRetryPolicy(
				1020000, // Timeout in 2 minutes
				DefaultRetryPolicy.DEFAULT_MAX_RETRIES,
				DefaultRetryPolicy.DEFAULT_BACKOFF_MULT
		));
		AppController.getInstance().addToRequestQueue(strq);
	}

	/**
	 * @noinspection deprecation
	 */
	@SuppressLint("StaticFieldLeak")
	class searchItemAsyncTask extends AsyncTask<String, String, String> {
		ProgressDialog dialog = null;
		String query = edtSearch.getText().toString().trim();

		@Override
		protected void onPreExecute() {
			super.onPreExecute();
			dialog = ProgressDialog.show(SearchActivity.this, null, "Please wait...", false, false);
			query = edtSearch.getText().toString().trim();
			query = query.toLowerCase();
			searchedList.clear();
		}

		@Override
		protected String doInBackground(String... params) {

			searchedList = DB.searchItemsByBarcode(query);

//			if (!item.isEmpty()) {
//				for (InventoryData.Data i : item) {
//					ItemSearch itemSearch = new ItemSearch(
//							i.getBarcode(),
//							i.getBarcode(),
//							i.getDescription(),
//							i.getStartQty().intValue(),
//							i.getScanQty().intValue(),
//							i.getMrp()
//					);
//					searchedList.add(itemSearch);
//				}
//			}

			return null;
		}

		@Override
		protected void onPostExecute(String s) {
			super.onPostExecute(s);

			if (dialog != null) dialog.dismiss();

			ItemSearchAdapter adapter = new ItemSearchAdapter(SearchActivity.this, searchedList);
			listView.setAdapter(adapter);
		}
	}
}
