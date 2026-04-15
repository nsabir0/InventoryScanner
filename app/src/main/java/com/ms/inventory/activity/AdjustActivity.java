package com.ms.inventory.activity;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Vibrator;
import android.text.Editable;
import android.text.Html;
import android.text.TextWatcher;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.Toast;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import com.ms.inventory.R;
import com.ms.inventory.adapter.ItemSearchAdapter;
import com.ms.inventory.model.InventoryData;
import com.ms.inventory.model.ScanItems;
import com.ms.inventory.utils.DBHelper;
import com.ms.inventory.utils.PreferenceManager;
import com.ms.inventory.utils.Utils;

import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

/**
 * @noinspection deprecation
 */
public class AdjustActivity extends AppCompatActivity {

    private static final String TAG = "AdjustActivity";

    DBHelper DB;
    PreferenceManager pref;
    ProgressDialog progressDialog;
    public static final int REQUEST_CODE_ITEM_SEARCH = 101;

    EditText edtBarcode, edtItemCode, edtStockQty, edtScanQty, edtAdjustedQty, edtAdjustQty;
    private String userId;
    private String deviceId;
    private String zoneName;
    private String outletCode;
    private double scanQty;

    private InventoryData.Data item;

    String searchType = "";

    public static final String TYPE_SEARCH = "search";
    public static final String TYPE_SCAN = "barcode";

    Vibrator mVibrator;

    private boolean SAVE_WITH_ENTER_KEY = false;

    Timer barcodeFocusTimer;
    TimerTask barcodeFocusTimerTask;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_adjust);

        if (getSupportActionBar() != null) {
            getSupportActionBar().hide();
        }

        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN);

        DB = new DBHelper(this);
        pref = new PreferenceManager(this);
        progressDialog = new ProgressDialog(this);
        progressDialog.setMessage("Please wait...");
        progressDialog.setCancelable(false);
        mVibrator = (Vibrator) getSystemService(Context.VIBRATOR_SERVICE);


        edtBarcode = findViewById(R.id.edt_barcode);
        edtItemCode = findViewById(R.id.edt_item_code);
        edtStockQty = findViewById(R.id.edt_stock_qty);
        edtScanQty = findViewById(R.id.edt_scan_qty);
        edtAdjustedQty = findViewById(R.id.edt_adjusted_qty);
        edtAdjustQty = findViewById(R.id.edt_adjust_qty);

        clearLayout();

        this.userId = pref.getUser();
        this.deviceId = pref.getDeviceId();
        this.zoneName = pref.getZoneName();
        this.outletCode = pref.getOutletCode();

        edtBarcode.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (s.length() > 6) {
                    itemSearch();
                }
            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });

        edtAdjustQty.setOnKeyListener((v, keyCode, event) -> {
            if (keyCode == KeyEvent.KEYCODE_ENTER && event.getAction() == KeyEvent.ACTION_DOWN) {
                Log.e(TAG, "edtScanQty KEYCODE_ENTER");
                SAVE_WITH_ENTER_KEY = true;
                processForSaveItem();


                return true;

            }

            return false;
        });
    }

    private void clearLayout() {
        edtBarcode.setText("");
        edtItemCode.setText("");
        edtStockQty.setText("");
        edtScanQty.setText("");
        edtAdjustedQty.setText("");
        edtAdjustQty.setText("");

        edtBarcode.requestFocus();

        // request barcode edittext if using keyboard enter key
        if (SAVE_WITH_ENTER_KEY) {
            focusBarcodeEditText();
            SAVE_WITH_ENTER_KEY = false;
        }
    }

    private void focusBarcodeEditText() {

        // cancel timer if already created
        if (barcodeFocusTimerTask != null) {
            barcodeFocusTimerTask.cancel();
            barcodeFocusTimerTask = null;

            barcodeFocusTimer.cancel();
            barcodeFocusTimer.purge();
        }

        // create new timer
        barcodeFocusTimer = new Timer();
        barcodeFocusTimerTask = new TimerTask() {
            @Override
            public void run() {
                runOnUiThread(() -> edtBarcode.requestFocus());
            }
        };
        barcodeFocusTimer.schedule(barcodeFocusTimerTask, 1000);

    }

    public void onClick(View v) {
        int id = v.getId();

        if (id == R.id.btn_cancel) {
            finish();
        } else if (id == R.id.btn_save) {
            processForSaveItem();
        } else if (id == R.id.btn_clear) {
            clearLayout();
        } else if (id == R.id.btn_barcode_enter) {
            itemSearch();
        }
    }

    private void itemSearch() {
        String barcode = edtBarcode.getText().toString().trim();
        if (!barcode.isEmpty()) {
            barcodeProcessForOffline(barcode);
        }
    }

	/*private void barcodeProcess(String barcode) {
		//Log.e("TAG","Barcode: "+ barcode);

		barcodeProcessForOnline(barcode.trim());
	}

	private void barcodeProcessForOnline(final String barcode) {
		//barcode = "123";
		String baseUrl = pref.getBaseUrl();
		String depoCode = pref.getOutletCode();
		String url = baseUrl + "Data/GetByBarcode?barcode=" + barcode + "&depoCode=" + depoCode + "&searchText=";
		Log.e("TAG", "GetByBarcode URL: " + url);

		StringRequest strq = new StringRequest(Request.Method.GET, url, response -> {
			Log.e("TAG", response);
			JsonValidator jv = new JsonValidator();

			try {
				JSONObject json = new JSONObject(response);
				boolean status = jv.getBoolean(json, "Status");

				if (status) {
					JSONArray data = json.getJSONArray("ReturnData");

					for (int i = 0; i < data.length(); i++) {
						JSONObject j = data.getJSONObject(i);

						String itemCode = jv.getString(j, "PRODUCTCODE");
						String name = jv.getString(j, "PRODUCTNAME");
						double currentStock = jv.getDouble(j, "CurrentStock");
						double sale = jv.getDouble(j, "SALES");
						double unitPrice = jv.getDouble(j, "UnitPrice");

						ItemSearch itemSearch = new ItemSearch(itemCode, barcode, name, (int) currentStock, (int) sale, unitPrice);
						barcodeProcessForOffline(itemSearch.itemCode);
					}
				} else {
					Toast.makeText(AdjustActivity.this, "Not Found", Toast.LENGTH_SHORT).show();
				}

//				final List<InventoryData.Data> list = DB.getOfflineItemByBarcode(barcode);
//
//
//				if (list.size() > 1) {
//                    //select Item From List
//                    showBarcodeMultipleItemDialog(list);
//                    //searchType="barcode";
//                } else if (list.size() == 1) {
//                    item = list.get(0);
//                    searchType = TYPE_SCAN;
//                    edtBarcode.setText("");
//                    updateLayout(item);
//                } else {
//                    // search Item if barcode process failed
//                    barcodeProcessFailed();
//                }


			} catch (JSONException e) {
				barcodeProcessForOffline(barcode);
				Log.e(TAG, "JSONException Error: " + e);
			}

		}, error -> {
			Log.e(TAG, "Error ", error);
			errorVibration();
			Utils.errorDialog(AdjustActivity.this, "Connection Error", "Please Check Your Internet Connection.");
			edtBarcode.requestFocus();
		});

		AppController.getInstance().addToRequestQueue(strq);
	}*/

    private void barcodeProcessForOffline(final String barcode) {
        try {
            new Thread(() -> {
                final List<InventoryData.Data> list = DB.getScannedItemByBarcode(barcode);

                runOnUiThread(() -> {
                    if (list.size() > 1) {
                        //select Item From List
                        showBarcodeMultipleItemDialog(list);
                    } else if (list.size() == 1) {
                        item = list.get(0);
                        searchType = TYPE_SCAN;
                        updateLayout(item);
                    } else {
                        // search Item if barcode process failed
                        barcodeProcessFailed();
                    }
                });
            }).start();
        } catch (Exception e) {
            Log.e(TAG, "barcodeProcessForOffline error: " + e);
        }
    }

    private void showBarcodeMultipleItemDialog(final List<InventoryData.Data> list) {
        errorVibration();
        AlertDialog.Builder d = new AlertDialog.Builder(this);
        d.setTitle("Select a Product");

        LinearLayout layout = new LinearLayout(this);
        layout.setOrientation(LinearLayout.VERTICAL);
        layout.setPadding(20, 50, 20, 50);

        ListView listView = new ListView(this);
        layout.addView(listView);

        ItemSearchAdapter adapter = new ItemSearchAdapter(AdjustActivity.this, list);
        listView.setAdapter(adapter);

        d.setView(layout);

        final AlertDialog dialog = d.create();
        dialog.show();

        listView.setOnItemClickListener((parent, view, position, id) -> {
            item = list.get(position);
            searchType = TYPE_SCAN;
            updateLayout(item);
            dialog.dismiss();
        });

    }

    private void barcodeProcessFailed() {
        AlertDialog.Builder d = new AlertDialog.Builder(this);
        d.setTitle("Error!");
        d.setMessage("No Item Found. Would you like to search item?");

        d.setNegativeButton("NO", (dialog, which) -> {
            dialog.dismiss();
            clearLayout();
        });
        d.setPositiveButton("YES", (dialog, which) -> startActivityForResult(new Intent(AdjustActivity.this, SearchActivity.class), REQUEST_CODE_ITEM_SEARCH));

        d.create().show();
        errorVibration();
    }

    private void updateLayout(InventoryData.Data item) {
        if (item != null) {
            ScanItems sItem = DB.getSingleScanItem(item.getsBarcode(), String.valueOf(item.getMrp()));
            Log.e(TAG, "updateLayout: " + item.getBarcode());
            edtItemCode.setText(item.getBarcode());
//			edtBarcode.setText(item.barcode);
            edtStockQty.setText(String.valueOf(item.getStartQty()));
//			getScanItemInfo(item);
            scanQty = item.getScanQty();
            edtScanQty.setText(String.valueOf(item.getScanQty()));
            edtAdjustedQty.setText(String.valueOf(sItem.adjQty));
            edtAdjustQty.setText("");
            edtAdjustQty.requestFocus();
        }


//		edtScanQty.setText("");
        // set cursor at last position
        edtBarcode.setSelection(edtBarcode.getText().length());

    }

	/*private void totalScanQtyShow(InventoryData.Data item) {

		//String itemCode = edtItemCode.getText().toString().trim();

		if (!pref.isOnlineMode()) {
//			String count = DB.getItemScanQty(item);
			edtScanQty.setText(String.valueOf(item.getScanQty()));

		} else {
			String baseUrl = pref.getBaseUrl();

			String deviceId = this.deviceId;
			String userId = this.userId;
			String zoneName = this.zoneName;
			String depoCode = this.outletCode;
			//String url = "http://192.168.1.24/agora/api/Data/GetScanItemInfo?barcodeItemcode=333&deviceId=3&userId=3&zoneName=w&depoCode=3";
//			String url = baseUrl + "Data/GetItemScanQty?barcodeItemcode=" + item.itemCode + "&deviceId=" + deviceId + "&userId=" + userId +
//				  "&zoneName=" + zoneName + "&depoCode=" + depoCode;

			String url = baseUrl + "Data/GetItemScanQty";
			try {
//				url += "?barcodeItemcode=" + URLEncoder.encode(item.itemCode, getString(R.string.utf_8)) +
//				url += "?barcodeItemcode=" + URLEncoder.encode(pref.getBarCode(), getString(R.string.utf_8)) +
				url += "?barcodeItemcode=" + URLEncoder.encode(item.getBarcode(), getString(R.string.utf_8)) +
						"&deviceId=" + URLEncoder.encode(deviceId, getString(R.string.utf_8)) +
						"&userId=" + URLEncoder.encode(userId, getString(R.string.utf_8)) +
						"&zoneName=" + URLEncoder.encode(zoneName, getString(R.string.utf_8)) +
						"&depoCode=" + URLEncoder.encode(depoCode, getString(R.string.utf_8));

			} catch (UnsupportedEncodingException e) {
				//e.printStackTrace();
			}

			Log.e(TAG, "totalScanQtyShow: " + url);
			StringRequest strReq = new StringRequest(Request.Method.GET, url, response -> {
				Log.e(TAG, "onResponse: " + response);
				try {
					JsonValidator jv = new JsonValidator();
					JSONObject json = new JSONObject(response);
					boolean status = jv.getBoolean(json, "Status");

					if (status) {
						scanQty = jv.getDouble(json, "ReturnData");
						double totalQty = scanQty + adjQty;
						Log.e(TAG, "onResponse: totalQty: " + scanQty);

						if (scanQty != 0) {
							edtScanQty.setText(String.valueOf(totalQty));
						} else {
							edtScanQty.setText("0");
						}
					} else {
						edtScanQty.setText("0");
					}

				} catch (JSONException e) {
					//e.printStackTrace();
				}
			}, error -> {
				//Log.e("TAG", "Error", error);
				//Utils.errorDialog(ScanActivity.this, "Connection Error", error.getMessage());
			});

			AppController.getInstance().addToRequestQueue(strReq);

		}

	}

	private void getScanItemInfo(final InventoryData.Data item) {
		String baseUrl = pref.getBaseUrl();

		String deviceId = this.deviceId;
		String userId = this.userId;
		String zoneName = this.zoneName;
		String depoCode = this.outletCode;

		String url = baseUrl + "Data/GetScanItemInfo";
		try {
//			url += "?barcodeItemcode=" + URLEncoder.encode(item.itemCode, getString(R.string.utf_8)) +
//			url += "?barcodeItemcode=" + URLEncoder.encode(pref.getBarCode(), getString(R.string.utf_8)) +
			url += "?barcodeItemcode=" + URLEncoder.encode(item.getBarcode(), getString(R.string.utf_8)) +
					"&deviceId=" + URLEncoder.encode(deviceId, getString(R.string.utf_8)) +
					"&userId=" + URLEncoder.encode(userId, getString(R.string.utf_8)) +
					"&zoneName=" + URLEncoder.encode(zoneName, getString(R.string.utf_8)) +
					"&depoCode=" + URLEncoder.encode(depoCode, getString(R.string.utf_8));

		} catch (UnsupportedEncodingException e) {
			//e.printStackTrace();
		}

		Log.e("TAG", "GetItemScanQty url: " + url);

		StringRequest strReq = new StringRequest(Request.Method.GET, url, response -> {
			Log.e("TAG", "GetItemScanQty response: " + response);
			try {
				JsonValidator jv = new JsonValidator();
				JSONObject json = new JSONObject(response);
				boolean status = jv.getBoolean(json, "Status");

				if (status) {
					JSONObject returnObject = json.getJSONObject("ReturnData");

					adjQty = 0;
					Log.e(TAG, "onResponse: adjQty: " + returnObject.getDouble("AdjQty"));
					adjQty = returnObject.getDouble("AdjQty");
					edtAdjustedQty.setText(String.format("%s", adjQty));

					totalScanQtyShow(item);
				} else {
					edtScanQty.setText("0");
				}

			} catch (JSONException e) {
				//e.printStackTrace();
			}
		}, error -> {
			//Log.e("TAG", "Error", error);
			//Utils.errorDialog(ScanActivity.this, "Connection Error", error.getMessage());
		});

		AppController.getInstance().addToRequestQueue(strReq);
	}*/

    private void errorVibration() {
        //Vibrator mVibrator = (Vibrator) getSystemService(Context.VIBRATOR_SERVICE);
		/*if (mVibrator != null) {
			long pattern[] = {0, 300, 100, 600};
			mVibrator.vibrate(pattern, -1);
		}*/

        mVibrator.vibrate(600); // Vibrate for 400 milliseconds
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {

        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK && requestCode == REQUEST_CODE_ITEM_SEARCH) {
            item = (InventoryData.Data) data.getSerializableExtra("ITEM");
            searchType = TYPE_SEARCH;
            updateLayout(item);
        }
    }

    private void processForSaveItem() {

        final String adjQty = edtAdjustQty.getText().toString().trim();
        ScanItems sItem = DB.getSingleScanItem(this.item.getsBarcode(), String.valueOf(this.item.getMrp()));
        double newScanQty = Double.parseDouble(sItem.scanQty);
        double itemAdjQty = Double.parseDouble(sItem.adjQty);
        newScanQty = newScanQty + Double.parseDouble(adjQty);

        if (item == null) {
            Utils.errorDialog(this, "Error", "No Item is selected. Please select a Item first.");
            errorVibration();
            return;
        }

        if (adjQty.isEmpty()) {
            Utils.errorDialog(this, "Empty Quantity!", "Adjust Quantity is empty. Please enter quantity");
            errorVibration();
            return;
        }

        if (newScanQty < 0 || newScanQty == 0) {
            Utils.errorDialog(this, "Adjust Quantity!", "Adjust quantity is not valid.");
            errorVibration();
            return;
        }

        try {
            if (Integer.parseInt(adjQty) == 0) {
                Utils.errorDialog(this, "Invalid Quantity!", "Zero Quantity is not allowed. Please enter positive or negative quantity");
                errorVibration();
                return;
            }
        } catch (Exception ignored) {
            Utils.errorDialog(this, "Invalid Quantity!", "Zero Quantity is not allowed. Please enter positive or negative quantity");
            errorVibration();
        }



        itemAdjQty = itemAdjQty + Double.parseDouble(adjQty);


        ScanItems finalItem = new ScanItems(
                this.item.getBarcode(),
                this.item.getBarcode(),
                this.item.getUserBarcode().trim(),
                this.item.getsBarcode(),
                this.item.getDescription(),
                String.valueOf(newScanQty),
                String.valueOf(itemAdjQty),
                this.userId,
                this.deviceId,
                this.zoneName,
                String.valueOf(this.scanQty),
                String.valueOf(this.item.getStartQty()),
                "0",
                Utils.getTodayDate(),
                String.valueOf(item.getStartQty()),
                String.valueOf(item.getScanQty()),
                this.outletCode,
                String.valueOf(item.getMrp()),
                String.valueOf(item.getCpu()),
                this.item.getSessionId()
        );

		/*if (itemAdjQty == 0) {
			//msg = "Invalid totalQty. please correct it first";
			Utils.errorDialog(this, "", "Invalid totalQty. please correct it first");
		} else */
        if (itemAdjQty > -1000 && itemAdjQty <= 1000) {
            saveItem(finalItem);
        } else {
            AlertDialog.Builder d = new AlertDialog.Builder(this);
            d.setTitle("Confirmation");
            d.setMessage(Html.fromHtml("<b>" + adjQty + "</b> totalQty is confusing. are you sure to save?"));
            d.setNegativeButton("NO", (dialog, which) -> dialog.dismiss());
            d.setPositiveButton("YES", (dialog, which) -> saveItem(finalItem));
            d.create().show();
        }
    }

    private void saveItem(final ScanItems item) {

        progressDialog.show();


        boolean isSaved = DB.adjustScanItem(item);

        if (!isSaved) {
            //successVibration();
            Toast.makeText(AdjustActivity.this, "Data save Failed!", Toast.LENGTH_SHORT).show();
            clearLayout();
        } else {
            Toast.makeText(AdjustActivity.this, "Data saved!", Toast.LENGTH_SHORT).show();
            progressDialog.dismiss();

            /*if (!pref.isOnlineMode()) {
                progressDialog.dismiss();
            } else {
                String baseUrl = pref.getBaseUrl();

                String deviceId = this.deviceId;
                String userId = this.userId;
                String zoneName = this.zoneName;
                String depoCode = this.outletCode;

                String url = baseUrl + "Data/UpdateAdjustQty";

                try {
                    url += "?Barcode=" + URLEncoder.encode(item.barcode, getString(R.string.utf_8)) +
                            "&deviceId=" + URLEncoder.encode(deviceId, getString(R.string.utf_8)) +
                            "&zoneName=" + URLEncoder.encode(zoneName, getString(R.string.utf_8)) +
                            "&depoCode=" + URLEncoder.encode(depoCode, getString(R.string.utf_8)) +
                            "&adjustQty=" + URLEncoder.encode(String.valueOf(item.adjQty), getString(R.string.utf_8)) +
                            "&userId=" + URLEncoder.encode(userId, getString(R.string.utf_8));

                } catch (UnsupportedEncodingException e) {
                    Log.e("TAG", "SaveInventory url: " + e);
                }

                Log.e(TAG, "saveItem: adjQty: " + item.adjQty);
                Log.e("TAG", "SaveInventory url: " + url);

                StringRequest strReq = new StringRequest(Request.Method.GET, url, response -> {
                    progressDialog.dismiss();

                    Log.e("TAG", "response: " + response);
                    try {
                        JSONObject json = new JSONObject(response);
                        boolean status = json.getBoolean("Status");
                        if (status) {
                            //successVibration();
                            Toast.makeText(AdjustActivity.this, "Data save successfully!", Toast.LENGTH_SHORT).show();
                            clearLayout();
                        } else {
                            errorVibration();
                            Utils.errorDialog(AdjustActivity.this, "Error", "Error saving data");
                        }
                    } catch (JSONException e) {
                        Log.e("TAG", "Error", e);
                    }
                }, error -> {
                    progressDialog.dismiss();
                    errorVibration();
                    Utils.errorDialog(AdjustActivity.this, "Connection Error", error.getMessage());
                    Log.e("TAG", "Error", error);
                });

                AppController.getInstance().addToRequestQueue(strReq);
            }*/
        }
        final InventoryData.Data updatedItem = DB.getSingleInventoryItem(item.sBarcode, item.salePrice);
        if (updatedItem != null) {
            updateLayout(updatedItem);
        }

    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        //Log.e("TAG", "onKeyDown " + keyCode);

        if (keyCode == KeyEvent.KEYCODE_F4) {
            processForSaveItem(); // save item
            return true;
        }
        return super.onKeyDown(keyCode, event);
    }

    @Override
    public void onBackPressed() {

        if (edtBarcode.length() > 0) {
            clearLayout();
            return;
        }

        super.onBackPressed();
    }

}
