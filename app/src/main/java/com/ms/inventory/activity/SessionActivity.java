package com.ms.inventory.activity;

import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.android.volley.DefaultRetryPolicy;
import com.android.volley.Request;
import com.android.volley.TimeoutError;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.ms.inventory.R;
import com.ms.inventory.model.InventoryData;
import com.ms.inventory.utils.AppController;
import com.ms.inventory.utils.DBHelper;
import com.ms.inventory.utils.PreferenceManager;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/**
 * @noinspection deprecation, CallToPrintStackTrace
 */
public class SessionActivity extends AppCompatActivity {

    private static final String TAG = "SessionActivity";

    DBHelper DB;
    private PreferenceManager pref;
    ProgressDialog progressDialog;
    private HandlerThread handlerThread;
    private Handler backgroundHandler;
    private Handler mainHandler;

    List<String> sessionIdList = new ArrayList<>();
    List<String> selectedSessionIds = new ArrayList<>();
    //    int totalDatabaseItem;
//    int count = 0;
    int currentPage = 1;
    int totalPage = 0;
    int currentSessionIndex = 0;

    // Get the current date
    Date currentTime = Calendar.getInstance().getTime();
    String currentDate = new SimpleDateFormat("yyyy-MM-dd", Locale.US).format(currentTime);
    private long pressedTime;

    Button saveButton;
    TextView quantityTextView;
    private LinearLayout buttonLayout;

    // StringBuilder to keep track of errors
    StringBuilder errorMessages = new StringBuilder();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_session);

        DB = DBHelper.getInstance(this);
        pref = new PreferenceManager(this);
        quantityTextView = findViewById(R.id.tv_qty);
        buttonLayout = findViewById(R.id.button_layout);
        saveButton = findViewById(R.id.save_button);

        handlerThread = new HandlerThread("BackgroundThread");
        handlerThread.start();
        backgroundHandler = new Handler(handlerThread.getLooper());
        mainHandler = new Handler(Looper.getMainLooper());

        progressDialog = new ProgressDialog(this);
        progressDialog.setMessage("Getting New Session...");
        progressDialog.setCancelable(false);
        progressDialog.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
        progressDialog.setMax(100);
        progressDialog.show();

        saveButton.setOnClickListener(v -> saveSelectedSessions());

        getSessionId();

//        try {
//            totalDatabaseItem = DB.countTableItem();
//        } catch (Exception e) {
//            Log.e("Abir001", "onCreate: ", e);
//        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        handlerThread.quit();
    }

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
        Intent intent = new Intent(SessionActivity.this, LoginActivity.class);
        startActivity(intent);
        finish();
    }

    private void getSessionId() {
        String url = pref.getBaseUrl() + "/ValuesApi/GetSession?FromDate=2024-01-01&ToDate=" + currentDate;
        StringRequest stringRequest = new StringRequest(Request.Method.GET, url,
                response -> {
                    try {
                        JSONArray jsonArray = new JSONArray(response);
                        for (int i = 0; i < jsonArray.length(); i++) {
                            JSONObject jsonObject = jsonArray.getJSONObject(i);
                            String sessionId = jsonObject.getString("SessionId");
                            boolean isSessionDiscarded = jsonObject.getBoolean("IsDiscard");
                            if (!isSessionDiscarded) {
                                sessionIdList.add(sessionId);
                            }
                        }

                        // Add checkboxes dynamically based on the Session quantity
                        for (String sessionId : sessionIdList) {
                            boolean isSessionUsed = DB.isSessionUsed(sessionId);
                            if (!isSessionUsed) {
                                addCheckBox(sessionId);
                            }
                        }

                        progressDialog.dismiss();
                        emptySession();
                    } catch (JSONException e) {
                        logout();
                        Log.e(TAG, "GetSessionId JSONException error:", e);
                    }
                },
                error -> {
                    progressDialog.dismiss();
                    String errorMessage = "";

                    if (error instanceof TimeoutError) {
                        errorMessage += "Connection Error: Request Timeout.";
                    } else if (error.networkResponse != null && error.networkResponse.statusCode == 404) {
                        errorMessage += "Connection Error: Resource not found";
                    } else {
                        errorMessage += "Connection Error: " + error.getMessage();
                    }
                    Toast.makeText(this, errorMessage, Toast.LENGTH_LONG).show();
                    emptySession();
                    Log.e(TAG, "GetSessionId Error occurred", error);
                }
        );

        stringRequest.setRetryPolicy(new DefaultRetryPolicy(
                1020000, // Timeout in 2 minutes
                DefaultRetryPolicy.DEFAULT_MAX_RETRIES,
                DefaultRetryPolicy.DEFAULT_BACKOFF_MULT
        ));
        AppController.getInstance().addToRequestQueue(stringRequest);
    }

    private void emptySession() {
        if (sessionIdList.isEmpty()) {
            quantityTextView.setText(R.string.no_session_found);
            saveButton.setVisibility(View.GONE);
        }
    }

    // Add checkbox dynamically
    private void addCheckBox(final String sessionId) {
        CheckBox checkBox = new CheckBox(this);
        checkBox.setText(String.format("%s - %s", getString(R.string.session), sessionId));
        checkBox.setLayoutParams(new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT));

        // Pre-select the checkbox if the sessionId is in the selectedSessionIds list
        if (pref.getSessionIds().contains(sessionId)) {
            checkBox.setChecked(true);
            selectedSessionIds.add(sessionId); // Add it to the list of selected session IDs
        }

        Log.d(TAG, "Selected Session IDs: " + selectedSessionIds);

        checkBox.setOnCheckedChangeListener((buttonView, isChecked) -> {
            if (isChecked) {
                selectedSessionIds.add(sessionId);
            } else {
                selectedSessionIds.remove(sessionId);
            }

            Log.d(TAG, "Selected Session IDs: " + selectedSessionIds);
        });
        buttonLayout.addView(checkBox);
    }

    // Save selected sessions and navigate to the next screen
    private void saveSelectedSessions() {
        if (selectedSessionIds.isEmpty()) {
            Toast.makeText(this, "Please select at least one session.", Toast.LENGTH_SHORT).show();
            return;
        }

        if (pref.isOnlineMode()) {
            pref.setSessionIds(selectedSessionIds);
            DB.deleteInventoryData();

            progressDialog.setMessage("Preparing Session Data...");
            progressDialog.show();

            // Start saving sessions from the first selected session ID
            loadInitialData(selectedSessionIds.get(currentSessionIndex));
        }
    }

    public void loadInitialData(String ssnId) {
        String baseUrl = pref.getBaseUrl();
        String url = baseUrl + "ValuesApi/GetSessionList?SessionId=" + ssnId + "&PageNo=1&DataRowSize=80000";

        StringRequest stringRequest = new StringRequest(Request.Method.GET, url,
                response -> {
                    try {
                        JSONArray responseArray = new JSONArray(response);
                        JSONObject responseObject = responseArray.getJSONObject(0);
                        totalPage = responseObject.getInt("TotalPage") + 1;

                        currentPage = 1; // Reset current page
                        Log.e(TAG, "SessionID: " + ssnId + ", TotalPage: " + totalPage);
                        Log.e(TAG, "Inventory CurrentPage: " + currentPage);

                        saveFullInventory(ssnId);

                    } catch (JSONException e) {
                        progressDialog.dismiss();
                        Log.e(TAG, "Error parsing JSON response: " + e.getMessage());
                        addErrorMessage(ssnId, e.getMessage(), currentPage);
                        proceedToNextSessionOrPage();
                    }
                }, error -> {
            progressDialog.dismiss();
            handleErrorResponse(ssnId, error, 1);
            proceedToNextSessionOrPage();
        });

        stringRequest.setRetryPolicy(new DefaultRetryPolicy(
                1020000, // Timeout in 2 minutes
                DefaultRetryPolicy.DEFAULT_MAX_RETRIES,
                DefaultRetryPolicy.DEFAULT_BACKOFF_MULT
        ));
        AppController.getInstance().addToRequestQueue(stringRequest);
    }

    public void saveFullInventory(String ssnId) {
        backgroundHandler.post(() -> {
            String baseUrl = pref.getBaseUrl();
            String url = baseUrl + "ValuesApi/GetSessionList?SessionId=" + ssnId + "&PageNo=" + currentPage + "&DataRowSize=80000";

            Log.e(TAG, "getFullInventory URL: " + url);

            StringRequest stringRequest = new StringRequest(Request.Method.GET, url,
                    response -> {
                        try {
                            JSONArray responseArray = new JSONArray(response);
                            JSONObject responseObject = responseArray.getJSONObject(0);
                            boolean status = responseObject.getBoolean("Status");

                            if (status) {
                                List<InventoryData.Data> inventoryList = new ArrayList<>();
                                JSONArray dataArray = responseObject.getJSONArray("Data");

                                for (int i = 0; i < dataArray.length(); i++) {
                                    JSONObject dataObject = dataArray.getJSONObject(i);

                                    InventoryData.Data data = new InventoryData.Data();
                                    data.setSessionId(dataObject.getString("SessionId"));
                                    data.setBarcode(dataObject.getString("Barcode"));
                                    data.setsBarcode(dataObject.getString("sBarcode"));
                                    data.setUserBarcode(dataObject.getString("USER_BARCODE").trim());
                                    data.setStartQty(dataObject.getDouble("StartQty"));
                                    data.setScanQty(dataObject.getDouble("ScanQty"));
                                    data.setScanStartDate(dataObject.getString("ScanStartDate"));
                                    data.setMrp(dataObject.getDouble("MRP"));
                                    data.setDescription(dataObject.getString("Description"));
                                    data.setCpu(dataObject.getDouble("CPU"));

                                    inventoryList.add(data);
                                }
                                // Save data to database
                                DB.addInventoryData(inventoryList);

                                mainHandler.post(() -> {
                                    // Update the progress dialog for the current page
                                    progressDialog.setMessage("Saving Offline Session Data " + (currentSessionIndex + 1) + " of " + selectedSessionIds.size() + "\n(Dataset " + (currentPage - 1) + " of " + (totalPage) + ")");
                                    progressDialog.setProgress((currentPage * 100) / totalPage);
                                });

                                if (currentPage <= totalPage) {
                                    Log.d(TAG, "Inventory CurrentPage: " + currentPage);
                                    currentPage++;
                                    saveFullInventory(ssnId);
                                } else {
                                    proceedToNextSessionOrPage();
                                }

                            } else {
                                addErrorMessage(ssnId, "Status false", currentPage);
                                proceedToNextSessionOrPage();
                            }

                        } catch (JSONException e) {
                            addErrorMessage(ssnId, e.getMessage(), currentPage);
                            proceedToNextSessionOrPage();
                        }
                    }, error -> {
                handleErrorResponse(ssnId, error, currentPage);
                proceedToNextSessionOrPage();
            });

            stringRequest.setRetryPolicy(new DefaultRetryPolicy(
                    1020000, // Timeout in 2 minutes
                    DefaultRetryPolicy.DEFAULT_MAX_RETRIES,
                    DefaultRetryPolicy.DEFAULT_BACKOFF_MULT
            ));
            AppController.getInstance().addToRequestQueue(stringRequest);
        });
    }

    private void addErrorMessage(String ssnId, String message, int page) {
        errorMessages.append("Error in session: ").append(ssnId).append(", page: ").append(page).append(" - ").append(message).append("\n");
        mainHandler.post(() -> progressDialog.setMessage("Errors found: " + errorMessages.toString()));
    }

    private void handleErrorResponse(String ssnId, VolleyError error, int page) {
        error.printStackTrace();
        String errorMessage;

        if (error instanceof TimeoutError) {
            errorMessage = "Connection Error: Request Timeout.";
        } else if (error.networkResponse != null) {
            int statusCode = error.networkResponse.statusCode;
            errorMessage = switch (statusCode) {
                case 400 -> "Connection Error: Bad Request";
                case 401 -> "Connection Error: Unauthorized";
                case 403 -> "Connection Error: Forbidden";
                case 404 -> "Connection Error: Resource not found";
                case 406 -> "Connection Error: Not Acceptable";
                case 500 -> "Connection Error: Internal Server Error";
                case 502 -> "Connection Error: Bad Gateway";
                case 503 -> "Connection Error: Service Unavailable";
                case 504 -> "Connection Error: Gateway Timeout";
                default -> "Connection Error: Status code " + statusCode;
            };
        } else {
            errorMessage = "Connection Error: " + error.getMessage();
        }
        Log.e(TAG, "Failed to fetch inventory data: " + errorMessage);
        addErrorMessage(ssnId, errorMessage, page);
    }

    private void proceedToNextSessionOrPage() {
        if (currentPage <= totalPage) {
            currentPage++;
            saveFullInventory(selectedSessionIds.get(currentSessionIndex));
        } else {
            currentSessionIndex++;
            if (currentSessionIndex < selectedSessionIds.size()) {
                loadInitialData(selectedSessionIds.get(currentSessionIndex));
            } else {
                mainHandler.post(() -> {
                    progressDialog.dismiss();
                    if (errorMessages.length() > 0) {
                        Toast.makeText(SessionActivity.this, "Completed with errors:\n" + errorMessages.toString(), Toast.LENGTH_LONG).show();
                    } else {
                        Toast.makeText(SessionActivity.this, "All Session Data Saved Successfully.", Toast.LENGTH_LONG).show();
                    }
                    Intent intent = new Intent(SessionActivity.this, MainActivity.class);
                    startActivity(intent);
                    finish();
                });
            }
        }
    }

    // Save selected sessions and navigate to the next screen
//    private void saveSelectedSessions() {
//        if (selectedSessionIds.isEmpty()) {
//            Toast.makeText(this, "Please select at least one session.", Toast.LENGTH_SHORT).show();
//            return;
//        }
//
//        if (pref.isOnlineMode()) {
//            pref.setSessionIds(selectedSessionIds);
//            DB.deleteInventoryData();
//
//            progressDialog.setMessage("Preparing Session Data...");
//            progressDialog.show();
//
//            // Start saving sessions from the first selected session ID
//            loadInitialData(selectedSessionIds.get(currentSessionIndex));
//        }
//    }
//
//    public void loadInitialData(String ssnId) {
//        String baseUrl = pref.getBaseUrl();
//        String url = baseUrl + "ValuesApi/GetSessionList?SessionId=" + ssnId + "&PageNo=1&DataRowSize=10000";
//
//        StringRequest stringRequest = new StringRequest(Request.Method.GET, url,
//                response -> {
//                    try {
//                        JSONArray responseArray = new JSONArray(response);
//                        JSONObject responseObject = responseArray.getJSONObject(0);
//                        totalPage = responseObject.getInt("TotalPage") + 2;
//
//                        Log.e(TAG, "TotalPage: " + totalPage);
//
//                        currentPage = 1; // Reset current page
//                        saveFullInventory(ssnId);
//
//                    } catch (JSONException e) {
//                        progressDialog.dismiss();
//                        Log.e(TAG, "Error parsing JSON response: " + e.getMessage());
//                    }
//                }, error -> {
//            progressDialog.dismiss();
//            error.printStackTrace();
//            String errorMessage = "";
//
//            if (error instanceof TimeoutError) {
//                errorMessage += "Connection Error: Request Timeout.";
//            } else if (error.networkResponse != null && error.networkResponse.statusCode == 404) {
//                errorMessage += "Connection Error: Resource not found";
//            } else if (error.networkResponse != null && error.networkResponse.statusCode == 500) {
//                errorMessage += "Connection Error: Database Response Error";
//            } else {
//                errorMessage += "Connection Error: " + error.getMessage();
//            }
//            Toast.makeText(this, errorMessage, Toast.LENGTH_LONG).show();
//            Log.e(TAG, "Failed to fetch Initial inventory data: " + error.getMessage());
//        });
//        AppController.getInstance().addToRequestQueue(stringRequest);
//    }
//
//    public void saveFullInventory(String ssnId) {
//        backgroundHandler.post(() -> {
//            String baseUrl = pref.getBaseUrl();
//            String url = baseUrl + "ValuesApi/GetSessionList?SessionId=" + ssnId + "&PageNo=" + currentPage + "&DataRowSize=10000";
//
//            Log.e(TAG, "getFullInventory URL: " + url);
//
//            StringRequest stringRequest = new StringRequest(Request.Method.GET, url,
//                    response -> {
//                        try {
//                            JSONArray responseArray = new JSONArray(response);
//                            JSONObject responseObject = responseArray.getJSONObject(0);
//                            boolean status = responseObject.getBoolean("Status");
//
//                            if (status) {
//                                List<InventoryData.Data> inventoryList = new ArrayList<>();
//                                JSONArray dataArray = responseObject.getJSONArray("Data");
//
//                                for (int i = 0; i < dataArray.length(); i++) {
//                                    JSONObject dataObject = dataArray.getJSONObject(i);
//
//                                    InventoryData.Data data = new InventoryData.Data();
//                                    data.setSessionId(dataObject.getString("SessionId"));
//                                    data.setBarcode(dataObject.getString("Barcode"));
//                                    data.setsBarcode(dataObject.getString("sBarcode"));
//                                    data.setUserBarcode(dataObject.getString("USER_BARCODE").trim());
//                                    data.setStartQty(dataObject.getDouble("StartQty"));
//                                    data.setScanQty(dataObject.getDouble("ScanQty"));
//                                    data.setScanStartDate(dataObject.getString("ScanStartDate"));
//                                    data.setMrp(dataObject.getDouble("MRP"));
//                                    data.setDescription(dataObject.getString("Description"));
//                                    data.setCpu(dataObject.getDouble("CPU"));
//
//                                    inventoryList.add(data);
//                                }
//                                // Save data to database
//                                DB.addInventoryData(inventoryList);
//
//                                mainHandler.post(() -> {
//                                    // Update the progress dialog for the current page
//                                    progressDialog.setMessage("Saving Offline Session Data " + (currentSessionIndex + 1) + " of " + selectedSessionIds.size() + "\n(Dataset " + (currentPage - 1) + " of " + (totalPage - 1) + ")");
//                                    progressDialog.setProgress((currentPage * 100) / totalPage);
//                                });
//
//                                if (currentPage < totalPage) {
//                                    currentPage++;
//                                    saveFullInventory(ssnId);
//                                } else {
//                                    // Move to the next session or finish if all sessions are processed
//                                    currentSessionIndex++;
//                                    if (currentSessionIndex < selectedSessionIds.size()) {
//                                        loadInitialData(selectedSessionIds.get(currentSessionIndex));
//                                    } else {
//                                        mainHandler.post(() -> {
//                                            progressDialog.dismiss();
//                                            Intent intent = new Intent(SessionActivity.this, MainActivity.class);
//                                            startActivity(intent);
//                                            finish();
//                                        });
//                                    }
//                                }
//
//                                Log.d(TAG, "Inventory CurrentPage: " + currentPage);
//                            } else {
//                                mainHandler.post(() -> progressDialog.dismiss());
//                                // Handle case where status is false
//                                String message = responseObject.getString("Message");
//                                Log.e(TAG, "Failed to fetch inventory data: " + message);
//                            }
//
//                        } catch (JSONException e) {
//                            mainHandler.post(() -> progressDialog.dismiss());
//                            Log.e(TAG, "Error parsing JSON response: " + e.getMessage());
//                        }
//                    }, error -> {
//                error.printStackTrace();
//                mainHandler.post(() -> progressDialog.dismiss());
//                String errorMessage = "";
//
//                if (error instanceof TimeoutError) {
//                    errorMessage += "Connection Error: Request Timeout.";
//                } else if (error.networkResponse != null && error.networkResponse.statusCode == 404) {
//                    errorMessage += "Connection Error: Resource not found";
//                } else if (error.networkResponse != null && error.networkResponse.statusCode == 500) {
//                    errorMessage += "Connection Error: Database Response Error";
//                } else {
//                    errorMessage += "Connection Error: " + error.getMessage();
//                }
//                Toast.makeText(this, errorMessage, Toast.LENGTH_LONG).show();
//                Log.e(TAG, "Failed to fetch inventory data: " + error.getMessage());
//            });
//
//            AppController.getInstance().addToRequestQueue(stringRequest);
//        });
//    }

//    private void saveSelectedSessions() {
//
//        if (selectedSessionIds.isEmpty()) {
//            Toast.makeText(this, "Please select at least one session.", Toast.LENGTH_SHORT).show();
//            return;
//        }
//
//        if (pref.isOnlineMode()) {
//            pref.setSessionIds(selectedSessionIds);
//
//            DB.deleteInventoryData();
//
//            progressDialog.setMessage("Saving Offline Inventory Data...");
//            progressDialog.setCancelable(false);
//
//            for (String ssnId : selectedSessionIds) {
//                loadInitialData(ssnId);
//            }
//
////            finish();
////            Intent intent = new Intent(SessionActivity.this, MainActivity.class);
////            startActivity(intent);
//        }
//    }
//
//    //    private void getSessionId() {
//////        String url = pref.getBaseUrl() + "/ValuesApi/GetSession?FromDate=2024-" + currentMonth + "-01&ToDate=" + currentDate;
////        String url = pref.getBaseUrl() + "/ValuesApi/GetSession?FromDate=2024-01-01&ToDate=" + currentDate;
////        StringRequest stringRequest = new StringRequest(Request.Method.GET, url,
////                response -> {
////                    try {
////                        JSONArray jsonArray = new JSONArray(response);
////                        for (int i = 0; i < jsonArray.length(); i++) {
////                            JSONObject jsonObject = jsonArray.getJSONObject(i);
////                            String sessionId = jsonObject.getString("SessionId");
////                            boolean isSessionDiscarded = jsonObject.getBoolean("IsDiscard");
////                            if (!isSessionDiscarded) {
////                                sessionIdList.add(sessionId);
////                            }
////                        }
////
////                        // Update TextView
////                        quantityTextView.setText(getString(R.string.select_a_session_id));
////
////                        // Add buttons dynamically based on the quantity
////                        for (String sessionId : sessionIdList) {
////                            boolean isSessionUsed = DB.isSessionUsed(sessionId);
////                            if (!isSessionUsed) {
////                                addButton(sessionId);
////                            }
////                        }
////
////                        progressDialog.dismiss();
////                    } catch (JSONException e) {
////                        logout();
////                        Log.e(TAG, "GetSessionId JSONException error:", e);
////                    }
////                },
////                error -> {
////                    progressDialog.dismiss();
////                    logout();
////                    Log.e(TAG, "GetSessionId Error occurred", error);
////                }
////
////        );
////        // Add the request to the RequestQueue.
////        AppController.getInstance().addToRequestQueue(stringRequest);
////    }
////
////    private void addButton(final String sessionId) {
////        Button button = new Button(this);
////        button.setText(String.format("%s - %s", getString(R.string.session), sessionId));
////        button.setLayoutParams(new LinearLayout.LayoutParams(
////                LinearLayout.LayoutParams.MATCH_PARENT,
////                LinearLayout.LayoutParams.WRAP_CONTENT));
////        button.setOnClickListener(v -> {
////            // Save the clicked session ID in PreferenceManager
////            pref.setSession(sessionId);
////
////            finish();
////            Intent intent = new Intent(SessionActivity.this, MainActivity.class);
////            startActivity(intent);
////        });
////        buttonLayout.addView(button);
////    }
//
//    public void loadInitialData(String ssnId) {
//        progressDialog.show();
//
//        String baseUrl = pref.getBaseUrl();
////        String url = baseUrl + "ValuesApi/GetSessionList?SessionId=" + ssnId + "&PageNo=1&DataRowSize=1";
//        String url = baseUrl + "ValuesApi/GetSessionList?SessionId=" + ssnId + "&PageNo=1&DataRowSize=1000";
//
//        StringRequest stringRequest = new StringRequest(Request.Method.GET, url,
//                response -> {
//                    try {
//                        JSONArray responseArray = new JSONArray(response);
//                        JSONObject responseObject = responseArray.getJSONObject(0);
//                        int totalPage = responseObject.getInt("TotalPage");
//
//                        saveFullInventory(totalPage, ssnId);
//
////                        // Checks if database has already same amount of data from online inventory
////                        if (totalPage != totalDatabaseItem) {
////                            saveFullInventory(totalPage, id);
////                        } else {
////                            progressDialog.dismiss();
////                        }
////								for (int i = 1; i <= totalPage+1; i++) {
////									saveFullInventory(i);
////								}
//
//                    } catch (JSONException e) {
//                        progressDialog.dismiss();
//                        Log.e("inventoryData", "Error parsing JSON response: " + e.getMessage());
//                    }
//                }, error -> {
//            progressDialog.dismiss();
//            Log.e(TAG, "Failed to fetch inventory data: " + error.getMessage());
//        });
//        AppController.getInstance().addToRequestQueue(stringRequest);
//    }
//
//    public void saveFullInventory(final int page, String ssnId) {
//
//        String baseUrl = pref.getBaseUrl();
//
//        String url = baseUrl + "ValuesApi/GetSessionList?SessionId=" + ssnId + "&PageNo=" + page + "&DataRowSize=1000";
////        String url = baseUrl + "ValuesApi/GetSessionList?SessionId=" + ssnId + "&PageNo=1&DataRowSize=" + page;
//
//        StringRequest stringRequest = new StringRequest(Request.Method.GET, url,
//                response -> {
//                    try {
//                        // Parse JSON response
//                        JSONArray responseArray = new JSONArray(response);
//                        JSONObject responseObject = responseArray.getJSONObject(0);
//                        boolean status = responseObject.getBoolean("Status");
//
//                        if (status) {
//                            List<InventoryData.Data> inventoryList = new ArrayList<>();
//                            JSONArray dataArray = responseObject.getJSONArray("Data");
//
//                            for (int i = 0; i < dataArray.length(); i++) {
//                                JSONObject dataObject = dataArray.getJSONObject(i);
//
//                                InventoryData.Data data = new InventoryData.Data();
//                                data.setSessionId(dataObject.getString("SessionId"));
//                                data.setBarcode(dataObject.getString("Barcode"));
//                                data.setsBarcode(dataObject.getString("sBarcode"));
//                                data.setUserBarcode(dataObject.getString("USER_BARCODE"));
//                                data.setStartQty(dataObject.getDouble("StartQty"));
//                                data.setScanQty(dataObject.getDouble("ScanQty"));
//                                data.setScanStartDate(dataObject.getString("ScanStartDate"));
//                                data.setMrp(dataObject.getDouble("MRP"));
//                                data.setDescription(dataObject.getString("Description"));
//                                data.setCpu(dataObject.getDouble("CPU"));
//
//                                inventoryList.add(data);
//                            }
//                            // Save data to database
//                            DB.addInventoryData(inventoryList, SessionActivity.this);
//
//                            Log.d("inventoryData", "Inventory data saved successfully.");
//                        } else {
//                            progressDialog.dismiss();
//                            // Handle case where status is false
//                            String message = responseObject.getString("Message");
//                            Log.e("inventoryData", "Failed to fetch inventory data: " + message);
//                        }
//
//                    } catch (JSONException e) {
//                        progressDialog.dismiss();
//                        Log.e("inventoryData", "Error parsing JSON response: " + e.getMessage());
//                    }
//                }, error -> {
//            progressDialog.dismiss();
//            Log.e("inventoryData", "Failed to fetch inventory data: " + error.getMessage());
//        });
//
//        AppController.getInstance().addToRequestQueue(stringRequest);
//    }
//
//    public void onDataInsertionCompleted() {
//        count++;
//        if (count == selectedSessionIds.size()) {
//            progressDialog.dismiss();
//            finish();
//            Intent intent = new Intent(SessionActivity.this, MainActivity.class);
//            startActivity(intent);
//        }
//    }


}

