package com.ms.inventory.activity;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.Vibrator;
import android.text.Editable;
import android.text.Html;
import android.text.InputType;
import android.text.TextWatcher;
import android.util.Log;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.View;
import android.view.WindowManager;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TableRow;
import android.widget.TextView;
import android.widget.Toast;

import java.util.concurrent.CountDownLatch;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.android.volley.DefaultRetryPolicy;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.TimeoutError;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.StringRequest;
import com.google.zxing.integration.android.IntentIntegrator;
import com.google.zxing.integration.android.IntentResult;
import com.ms.inventory.R;
import com.ms.inventory.adapter.ItemSearchAdapter;
import com.ms.inventory.model.InventoryData;
import com.ms.inventory.model.ItemSearch;
import com.ms.inventory.model.SaveInventory;
import com.ms.inventory.model.ScanItems;
import com.ms.inventory.utils.AppController;
import com.ms.inventory.utils.DBHelper;
import com.ms.inventory.utils.JsonValidator;
import com.ms.inventory.utils.PreferenceManager;
import com.ms.inventory.utils.Utils;

import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.NotOLE2FileException;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.Timer;
import java.util.TimerTask;

/**
 * @noinspection deprecation, CallToPrintStackTrace
 */
public class ScanActivity extends AppCompatActivity {

    private static final String TAG = "ScanActivity";

    private List<SaveInventory> saveInventoryList;
    private List<ScanItems> scanItemsArrayList;

    TableRow layoutItemCode, layoutScanQty;
    TextView tvDescription, tvTempTotalScanQty, tvTotalScanQty, tvMrp;
    //	TextView tvItemTotalScanQty, tvLastScannedItem;
    EditText edtItemCode, edtBarcode, edtStockQty, edtScanQty, edtMultiQty;
    CheckBox chkScanMultiQty;
    Button btnBarcode, btnItemSearch;
    Button btnClose, btnEnter, btnSaveToLocal, btnClear, btnSaveToServer, btnViewTemp, btnViewAll, btnExport, btnImport, btnSaveTemp;

    DBHelper DB;
    PreferenceManager pref;
    private Uri uriFile;
    ProgressDialog progressDialog, pd;
    private Handler mainHandler;
    private HandlerThread handlerThread;

    public static final int REQUEST_CODE_ITEM_SEARCH = 100;
    private static final int STORAGE_PERMISSION_REQUEST_CODE = 100;
    private static final int READ_PERMISSION_REQUEST_CODE = 101;
    private static final int PICK_XLS_FILE_REQUEST_CODE = 102;

    InventoryData.Data item = null;
    private ItemSearch itemSearch;

    String scQty = "0", srQty = "0";
    String searchType = "";

    private int totalItems = 0;
    private int successfulItemsCount = 0;
    private int failedItemsCount = 0;


    public static final String TYPE_SEARCH = "search";
    public static final String TYPE_SCAN = "barcode";

    private boolean isCameraBarcode = false;
    private String userId, deviceId, zoneName, currentDate, outletCode;
    private double adjQty;

    Vibrator mVibrator;

    private TextWatcher mBarCodeTextWatcher;
    private TextWatcher mQuantityTextWatcher;

    private Timer timer = new Timer();
    private final long DELAY = 100; // in ms

    private boolean isReceiverRegistered = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_scan);
        if (getSupportActionBar() != null) {
            getSupportActionBar().hide();
        }

        saveInventoryList = new ArrayList<>();
        scanItemsArrayList = new ArrayList<>();

        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN);

        DB = DBHelper.getInstance(this);
        pref = new PreferenceManager(this);

        progressDialog = new ProgressDialog(this);
        progressDialog.setMessage("Please wait...");
        progressDialog.setCancelable(false);

        pd = new ProgressDialog(ScanActivity.this);
        pd.setTitle("Importing...");
        pd.setMessage("Preparing excel data...");
        pd.setCancelable(false);
        pd.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
        pd.setIndeterminate(true);

        edtItemCode = findViewById(R.id.edt_item_code);
        edtBarcode = findViewById(R.id.edt_barcode);
        layoutItemCode = findViewById(R.id.layout_item_code);
        layoutScanQty = findViewById(R.id.layout_scan_qty);
        edtStockQty = findViewById(R.id.edt_stock_qty);
        edtScanQty = this.findViewById(R.id.edt_scan_qty);
        edtMultiQty = findViewById(R.id.edt_scan_qty);
        chkScanMultiQty = findViewById(R.id.chk_multiple_qty);
        tvDescription = findViewById(R.id.tv_description);
        tvTempTotalScanQty = findViewById(R.id.tv_temp_total_scan_qty);
        tvTotalScanQty = findViewById(R.id.tv_total_scan_qty);
        tvMrp = findViewById(R.id.tv_mrp);
//		tvItemTotalScanQty = findViewById(R.id.tv_item_total_scan_qty);
//		tvLastScannedItem = findViewById(R.id.tv_lastScannedItem);

        // Buttons Declaration
        btnEnter = findViewById(R.id.btn_barcode_enter);
        btnBarcode = findViewById(R.id.btn_barcode);
        btnItemSearch = findViewById(R.id.btn_item_search);
        btnClose = findViewById(R.id.btn_cancel);
        btnSaveToLocal = findViewById(R.id.btn_save);
        btnClear = findViewById(R.id.btn_clear);
        btnViewTemp = findViewById(R.id.btn_view_temp);
        btnViewAll = findViewById(R.id.btn_view_all);
        btnSaveToServer = findViewById(R.id.btn_save_to_server);
        btnExport = findViewById(R.id.btn_export);
        btnImport = findViewById(R.id.btn_import);
        btnSaveTemp = findViewById(R.id.btn_temp_save);

        mBarCodeTextWatcher = new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

                //				if (s.length() > 5) {
//					itemSearch();
//					edtBarcode.removeTextChangedListener(mBarCodeTextWatcher);
//				}
                if (timer != null) {
                    timer.cancel();
                }
            }

            @Override
            public void afterTextChanged(Editable s) {
                //avoid triggering event when text is too short
                if (s.length() >= 6) {

                    timer = new Timer();
                    timer.schedule(new TimerTask() {
                        @Override
                        public void run() {
                            // TODO: do what you need here (refresh list)
                            // you will probably need to use
                            // runOnUiThread(Runnable action) for some specific
                            // actions
                            itemSearch();
                            edtBarcode.removeTextChangedListener(mBarCodeTextWatcher);
                        }

                    }, DELAY);
                }
            }
        };
        edtBarcode.addTextChangedListener(mBarCodeTextWatcher);

        mQuantityTextWatcher = new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (s.length() > 4 && !edtScanQty.isActivated()) {
                    errorVibration();
                    AlertDialog.Builder builder = new AlertDialog.Builder(ScanActivity.this);
                    builder.setTitle("Quantity!")
                            .setMessage("Quantity is too long. Do you want proceed anyway?")
                            .setPositiveButton("Yes", (dialog, which) -> {
                                dialog.dismiss();
                                edtScanQty.setActivated(true);
                                edtScanQty.removeTextChangedListener(mQuantityTextWatcher);
                            })
                            .setNegativeButton("No", (dialog, which) -> {
                                dialog.dismiss();
                                edtScanQty.setText(null);
//									edtScanQty.setActivated(true);
//									edtScanQty.removeTextChangedListener(mQuantityTextWatcher);
                            })
                            .create().show();
                }
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        };
        edtScanQty.addTextChangedListener(mQuantityTextWatcher);

        if (pref.isItemCodeVisible()) {
            layoutItemCode.setVisibility(View.VISIBLE);
        } else {
            layoutItemCode.setVisibility(View.GONE);
        }

        if (pref.isStockVisible()) {
            layoutScanQty.setVisibility(View.VISIBLE);
        } else {
            layoutScanQty.setVisibility(View.GONE);
        }

        chkScanMultiQty.setChecked(pref.isMultiScanQty());

        clearLayout();

        this.userId = pref.getUser();
        this.deviceId = pref.getDeviceId();
        this.zoneName = pref.getZoneName();
        this.currentDate = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss", Locale.US).format(new Date());
        this.outletCode = pref.getOutletCode();

        mVibrator = (Vibrator) getSystemService(Context.VIBRATOR_SERVICE);

        chkScanMultiQty.setOnCheckedChangeListener((buttonView, isChecked) -> {
            if (isChecked) {
                edtMultiQty.setEnabled(true);
                edtMultiQty.setText("");
            } else {
                edtMultiQty.setEnabled(false);
                edtMultiQty.setText("1");
                edtScanQty.setSelection(edtScanQty.getText().length());
            }
        });

        edtItemCode.setOnEditorActionListener((v, actionId, event) -> {
            if (actionId == EditorInfo.IME_ACTION_SEARCH) {
                isCameraBarcode = false;
                itemSearch();
                return true;
            } else if (event != null && event.getKeyCode() == KeyEvent.KEYCODE_ENTER && event.getAction() == KeyEvent.ACTION_DOWN) {
                isCameraBarcode = true;
                itemSearch();
                return true;
            }
            return false;
        });

        edtScanQty.setOnEditorActionListener((v, actionId, event) -> {
            if (actionId == EditorInfo.IME_ACTION_DONE) {
//					processForSaveItem();
                InputMethodManager imm = (InputMethodManager) v.getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
                if (imm != null) {
                    imm.hideSoftInputFromWindow(v.getWindowToken(), 0);  // hide the soft keyboard
                }
                return true;
            }

            return false;
        });

        IntentFilter scanDataFilter = new IntentFilter();
        scanDataFilter.addAction("com.jb.action.GET_SCANDATA");
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                registerReceiver(scanDataReceiver, scanDataFilter, Context.RECEIVER_EXPORTED);
                isReceiverRegistered = true;

            }
        }


        // Buttons Listener
        btnEnter.setOnClickListener(v -> barcodeProcess(edtBarcode.getText().toString().trim()));
        btnBarcode.setOnClickListener(v -> startBarcodeScanner());
        btnItemSearch.setOnClickListener(v -> startActivityForResult(new Intent(this, SearchActivity.class), REQUEST_CODE_ITEM_SEARCH));
        btnClose.setOnClickListener(v -> finish());
        btnSaveToLocal.setOnClickListener(v -> processForSaveItemToLocal());
        btnClear.setOnClickListener(v -> clearLayoutAll());
        btnSaveTemp.setOnClickListener(v -> saveToLocalConfirmationDialog());
        btnViewTemp.setOnClickListener(v -> startActivity(new Intent(ScanActivity.this, ViewTempScanItems.class)));
        btnViewAll.setOnClickListener(v -> startActivity(new Intent(ScanActivity.this, ViewScanItems.class)));
        btnSaveToServer.setOnClickListener(v -> {
            if (!pref.isOnlineMode()) {
                Utils.errorDialog(this, "Offline Mode", "Please enable online mode first.");
                errorVibration();
            } else if (scanItemsArrayList != null && !scanItemsArrayList.isEmpty() && !pref.getSessionIds().isEmpty()) {
                finalSaveConfirmation();
            } else if (scanItemsArrayList != null && !scanItemsArrayList.isEmpty() && pref.getSessionIds().isEmpty()) {
                Utils.errorDialog(this, "Empty Session", "Please Login to online mode first to get new session.");
                errorVibration();
            } else {
                Utils.errorDialog(this, "Empty Item", "Scan item is empty. Please scan an item first.");
                errorVibration();
            }
        });
        btnExport.setOnClickListener(v -> {
            if (checkStoragePermission()) {
                backupExcel();
            } else {
                requestStoragePermission();
            }

        });
        btnImport.setOnClickListener(v -> openBrowserForExcel());
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        Log.e(TAG, "onActivityResult: ");
        IntentResult result = IntentIntegrator.parseActivityResult(requestCode, resultCode, data);
        if (result != null) {
            Log.e("scan", "scan complete");
            if (result.getContents() != null) {
                barcodeProcess(result.getContents());
            }
        } else {
            super.onActivityResult(requestCode, resultCode, data);
        }

        if (resultCode == RESULT_OK && requestCode == REQUEST_CODE_ITEM_SEARCH) {
            Log.e(TAG, "onActivityResult: called");
            clearLayoutAll();
            item = (InventoryData.Data) data.getSerializableExtra("ITEM");
            searchType = TYPE_SEARCH;
            updateLayout(item);
        }
        if (resultCode == RESULT_OK && requestCode == PICK_XLS_FILE_REQUEST_CODE) {
            if (data != null) {
                Uri uri = data.getData();
                readExcelFile(Objects.requireNonNull(uri));
            }
        }
    }

    private boolean checkReadPermission() {
        return ContextCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED;
    }

    private void requestReadPermission() {
        ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.READ_EXTERNAL_STORAGE}, READ_PERMISSION_REQUEST_CODE);
    }

    private boolean checkStoragePermission() {
        return ContextCompat.checkSelfPermission(this,
                Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED;
    }

    private void requestStoragePermission() {
        ActivityCompat.requestPermissions(this,
                new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE},
                STORAGE_PERMISSION_REQUEST_CODE);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == STORAGE_PERMISSION_REQUEST_CODE) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                backupExcel();
            } else {
                Toast.makeText(this, "Storage permission is required to export data", Toast.LENGTH_SHORT).show();
            }
        } else if (requestCode == READ_PERMISSION_REQUEST_CODE) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                openBrowserForExcel();
            } else {
                Toast.makeText(this, "Read permission is required to import data", Toast.LENGTH_SHORT).show();
            }
        }
    }

    private void openBrowserForExcel() {
        androidx.appcompat.app.AlertDialog.Builder d = new androidx.appcompat.app.AlertDialog.Builder(this);
        d.setTitle("Import from Excel");
        d.setMessage("Please Pick a Excel (.xls) file.");

        LinearLayout layout = new LinearLayout(this);
        layout.setOrientation(LinearLayout.VERTICAL);
        layout.setPadding(50, 20, 20, 20);

        d.setView(layout);

        d.setNegativeButton("Cancel", (dialog, which) -> dialog.dismiss());
        d.setPositiveButton("OK", (dialog, which) -> openFilePicker());

        d.create().show();
    }

    public void openFilePicker() {
        if (!checkReadPermission()) {
            requestReadPermission();
            return;
        }

        String[] mimeTypes = {
                "text/plain",
                "application/vnd.ms-excel",
                "application/excel",
                "application/x-excel",
                "application/x-msexcel",
                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"};

        Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
        intent.addCategory(Intent.CATEGORY_OPENABLE);
        intent.setType("*/*");
        intent.putExtra(Intent.EXTRA_MIME_TYPES, mimeTypes);
        startActivityForResult(Intent.createChooser(intent, "Select XLS File"), PICK_XLS_FILE_REQUEST_CODE);
    }

    private void readExcelFile(Uri uri) {
        String path = uri.toString();
        String type = path.substring(path.lastIndexOf(".") + 1);

        if (type.equalsIgnoreCase("xls")) {

            uriFile = uri;
            importExcel();
//            new ImportExcel().execute();

        } else {

            final String msg = "The file you have selected which is not supported. Please select <b>Excel 97-2003 (.xls)</b> file.";

            runOnUiThread(() -> Utils.errorDialog(ScanActivity.this, "File Not Supported!", msg, true));

        }
    }

    private void importExcel() {
        pd.setProgress(0);
        pd.show();

        mainHandler = new Handler(getMainLooper());
        handlerThread = new HandlerThread("ExcelImportThread");
        handlerThread.start();
        Handler backgroundHandler = new Handler(handlerThread.getLooper());

        backgroundHandler.post(() -> {
            DB.deleteTempScannedData();

            InputStream inputStream;
            try {
                inputStream = getContentResolver().openInputStream(uriFile);
                assert inputStream != null;
                HSSFWorkbook workbook = new HSSFWorkbook(inputStream); // Get the workbook instance for XLS file
                HSSFSheet sheet = workbook.getSheetAt(0); // Get first sheet from the workbook
                Iterator<Row> rows = sheet.iterator(); // Get iterator to all the rows in current sheet

                final int rowCount = sheet.getLastRowNum();

                mainHandler.post(() -> {
                    pd.setMax(rowCount);
                    pd.setIndeterminate(false);
                    pd.setMessage("Excel data is importing. Please wait...");
                });

                int count = 0;
                boolean isFirstRow = true; // Flag to skip the first row

                while (rows.hasNext()) {
                    Row row = rows.next();

                    if (isFirstRow) {
                        isFirstRow = false;
                        continue; // Skip the header row
                    }

                    String itemCode = getValueFromCell(row.getCell(0));
                    String barcode = getValueFromCell(row.getCell(1));
                    String userBarcode = getValueFromCell(row.getCell(2));
                    String sBarcode = getValueFromCell(row.getCell(3));
                    String itemDescription = getValueFromCell(row.getCell(4));
                    String scanQty = getValueFromCell(row.getCell(5));
                    String adjQty = getValueFromCell(row.getCell(6));
                    String userId = getValueFromCell(row.getCell(7));
                    String deviceId = getValueFromCell(row.getCell(8));
                    String zoneName = getValueFromCell(row.getCell(9));
                    String scQty = getValueFromCell(row.getCell(10));
                    String srQty = getValueFromCell(row.getCell(11));
                    String enQty = getValueFromCell(row.getCell(12));
                    String createDate = getValueFromCell(row.getCell(13));
                    String systemQty = getValueFromCell(row.getCell(14));
                    String sQty = getValueFromCell(row.getCell(15));
                    String outletCode = getValueFromCell(row.getCell(16));
                    String salePrice = getValueFromCell(row.getCell(17));
                    String cpu = getValueFromCell(row.getCell(18));
                    String sessionId = getValueFromCell(row.getCell(19));

                    ScanItems item = new ScanItems(itemCode, barcode, userBarcode, sBarcode, itemDescription, scanQty, adjQty, userId, deviceId, zoneName, scQty, srQty, enQty, createDate, systemQty, sQty, outletCode, salePrice, cpu, sessionId);

                    long i = DB.addScanItemsFromExcel(item);

                    if (i > 0) {
                        count++;
                        int finalCount = count;
                        mainHandler.post(() -> pd.setProgress(finalCount));
                    }
                }

                mainHandler.post(() -> {
                    pd.dismiss();
                    checkTotalScanQty();
                    loadLocalSaveItems();
                    Toast.makeText(ScanActivity.this, "Data importing completed", Toast.LENGTH_SHORT).show();
                    getWindow().clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
                });

            } catch (NotOLE2FileException e) {
                mainHandler.post(() -> {
                    pd.dismiss();
                    Toast.makeText(ScanActivity.this, "Corrupted XLS Document file", Toast.LENGTH_LONG).show();
                });
            } catch (IOException e) {
                mainHandler.post(() -> {
                    pd.dismiss();
                    Utils.errorDialog(ScanActivity.this, "Import Error", "Error found while data has been importing", true);
                });
            } finally {
                handlerThread.quit();
            }
        });
    }

    private String getValueFromCell(Cell cell) {
        if (cell == null) {
            return "";
        }
        return switch (cell.getCellType()) {
            case Cell.CELL_TYPE_NUMERIC -> String.valueOf((long) cell.getNumericCellValue());
            case Cell.CELL_TYPE_STRING -> cell.getStringCellValue();
            default -> "";
        };
    }

    private void backupExcel() {
        Toast toast;

        List<ScanItems> scanItemsList = DB.readScanItems();
        if (scanItemsList.isEmpty()) {
            toast = Toast.makeText(ScanActivity.this, "No Scanned Item Found to Export", Toast.LENGTH_SHORT);
        } else {
            String filePath = ExportExcel.exportToExcel(scanItemsList);
            if (filePath != null) {
                toast = Toast.makeText(ScanActivity.this, "Data Backup Successful!\n Saved at: " + filePath, Toast.LENGTH_LONG);
            } else {
                toast = Toast.makeText(ScanActivity.this, "Data Backup Failed!", Toast.LENGTH_SHORT);
            }
        }

        toast.setGravity(Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 200);
        toast.show();
    }

    public static class ExportExcel {

        private static final String TAG = "ExcelExporter";
        private static final String DIRECTORY_NAME = "InventoryExports";

        public static String exportToExcel(List<ScanItems> scanItemsList) {
            File directory = new File(Environment.getExternalStoragePublicDirectory(
                    Environment.DIRECTORY_DOCUMENTS), DIRECTORY_NAME);
            if (!directory.exists()) {
                if (!directory.mkdirs()) {
                    Log.e(TAG, "Failed to create directory");
                    return null;
                }
            }
            String timeStamp = new SimpleDateFormat("yyyyMMdd_hhmmss", Locale.getDefault()).format(new Date());
            String backupDBName = "backup_scanitems" + timeStamp + ".xls";

            String filePath = directory.getPath() + File.separator + backupDBName;

            try (Workbook workbook = new HSSFWorkbook()) {
                Sheet sheet = workbook.createSheet("Scan Items");

                // Create header row
                Row headerRow = sheet.createRow(0);
                String[] headers = {
                        "ItemCode",
                        "Barcode",
                        "UserBarcode",
                        "SBarcode",
                        "ItemDescription",
                        "ScanQty",
                        "AdjQty",
                        "UserID",
                        "DeviceID",
                        "ZoneName",
                        "SCQty",
                        "SRQty",
                        "ENQty",
                        "CreateDate",
                        "SystemQty",
                        "SQty",
                        "OutletCode",
                        "SalePrice",
                        "CPU",
                        "SessionID"
                };
                for (int i = 0; i < headers.length; i++) {
                    Cell cell = headerRow.createCell(i);
                    cell.setCellValue(headers[i]);
                }

                // Fill data rows
                int rowNum = 1;
                for (ScanItems scanItem : scanItemsList) {
                    Row row = sheet.createRow(rowNum++);
                    row.createCell(0).setCellValue(scanItem.getItemCode());
                    row.createCell(1).setCellValue(scanItem.getBarcode());
                    row.createCell(2).setCellValue(scanItem.getUserBarcode().trim());
                    row.createCell(3).setCellValue(scanItem.getSBarcode());
                    row.createCell(4).setCellValue(scanItem.getItemDescription());
                    row.createCell(5).setCellValue(scanItem.getScanQty());
                    row.createCell(6).setCellValue(scanItem.getAdjQty());
                    row.createCell(7).setCellValue(scanItem.getUserId());
                    row.createCell(8).setCellValue(scanItem.getDeviceId());
                    row.createCell(9).setCellValue(scanItem.getZoneName());
                    row.createCell(10).setCellValue(scanItem.getScQty());
                    row.createCell(11).setCellValue(scanItem.getSrQty());
                    row.createCell(12).setCellValue(scanItem.getEnQty());
                    row.createCell(13).setCellValue(scanItem.getCreateDate());
                    row.createCell(14).setCellValue(scanItem.getSystemQty());
                    row.createCell(15).setCellValue(scanItem.getSQty());
                    row.createCell(16).setCellValue(scanItem.getOutletCode());
                    row.createCell(17).setCellValue(scanItem.getSalePrice());
                    row.createCell(18).setCellValue(scanItem.getCpu());
                    row.createCell(19).setCellValue(scanItem.getSessionId());
                }

                // Write to file
                try (FileOutputStream fileOut = new FileOutputStream(filePath)) {
                    workbook.write(fileOut);
                }

                Log.i(TAG, "Export successful");
                return filePath;
            } catch (IOException e) {
                Log.e(TAG, "Error exporting to Excel: " + e.getMessage());
                return null;
            }
        }
    }

    @Override
    protected void onStart() {
        super.onStart();
        checkTotalScanQty();
        loadLocalSaveItems();
    }

    @Override
    public void onDestroy() {
        if (isReceiverRegistered) {
            unregisterReceiver(scanDataReceiver);
        }
        if (progressDialog != null && progressDialog.isShowing()) {
            progressDialog.dismiss();
        }
        super.onDestroy();
    }

    //	public void onTopButtonClick(View v) {
//		if (v.getId() == R.id.btn_barcode) {
//			startBarcodeScanner();
//		} else if (v.getId() == R.id.btn_item_search) {
//			startActivityForResult(new Intent(this, SearchActivity.class), REQUEST_CODE_ITEM_SEARCH);
//		}
//	}
    //	public void onClick(View v) {
//		int id = v.getId();
//
//		if (id == R.id.btn_cancel) {
//			finish();
//		} else if (id == R.id.btn_save) {
//			processForSaveItemToLocal();
//			//processForSaveItem();
//		} else if (id == R.id.btn_clear) {
//			clearLayout();
//		} else if (id == R.id.btn_save_to_server) {
//			if (scanItemsArrayList != null && !scanItemsArrayList.isEmpty() && !pref.getSession().isEmpty()) {
//				finalSaveConfirmation();
//			} else if (scanItemsArrayList != null && !scanItemsArrayList.isEmpty() && pref.getSession().isEmpty()) {
//				Utils.errorDialog(this, "Empty Session", "Please Login to online mode first to get new session.");
//				errorVibration();
//			} else {
//				Utils.errorDialog(this, "Empty Item", "Scan item is empty. Please scan an item first.");
//				errorVibration();
//			}
//		}
//	}

    public void loadLocalSaveItems() {
        scanItemsArrayList = new ArrayList<>();
        DB = new DBHelper(ScanActivity.this);

        scanItemsArrayList = DB.readScanItems();

        Log.e(TAG, String.valueOf(scanItemsArrayList.size()));
    }

    private void finalSaveConfirmation() {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle("Confirm Save");
        builder.setMessage("Are you sure you want to save items to the server?");

        // Add the buttons
        builder.setPositiveButton("Yes", (dialog, id) -> showPasswordDialog());
        builder.setNegativeButton("No", (dialog, id) -> dialog.dismiss());

        AlertDialog dialog = builder.create();
        dialog.show();

    }

    private void showPasswordDialog() {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle("Enter Password");

        // Set up the input
        final EditText input = new EditText(this);
        input.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);
        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.MATCH_PARENT
        );
        input.setLayoutParams(params);
        builder.setView(input);

        // Add the buttons
        builder.setPositiveButton("Proceed", (dialog, id) -> {
            String enteredPassword = input.getText().toString();
            String savedPassword = pref.getOfflineUserPassword();

            if (enteredPassword.equals(savedPassword)) {
                dialog.cancel();
                getItemListForServer();
            } else {
                Toast.makeText(getApplicationContext(), "Incorrect Password", Toast.LENGTH_SHORT).show();
            }
        });
        builder.setNegativeButton("Cancel", (dialog, id) -> dialog.cancel());

        // Create the AlertDialog
        AlertDialog dialog = builder.create();
        dialog.show();
    }

    private void clearLayout() {
        isCameraBarcode = false;
        item = null;

        //        edtItemCode.setText("");
//        tvDescription.setText("");
//		tvItemTotalScanQty.setText("");
        edtBarcode.setText("");
        edtStockQty.setText("");
        edtScanQty.setText("");

        edtBarcode.requestFocus();

        if (chkScanMultiQty.isChecked()) {
            edtScanQty.setText("");
            edtScanQty.setEnabled(true);

        } else {
            edtMultiQty.setText("1");
            edtScanQty.setEnabled(false);
        }

    }

    private void clearLayoutAll() {
        isCameraBarcode = false;
        item = null;

        edtItemCode.setText("");
        tvDescription.setText("");
        tvMrp.setText("");
//		tvItemTotalScanQty.setText("");
        edtBarcode.setText("");
        edtStockQty.setText("");
        edtScanQty.setText("");

        edtBarcode.requestFocus();

        if (chkScanMultiQty.isChecked()) {
            edtScanQty.setText("");
            edtScanQty.setEnabled(true);

        } else {
            edtMultiQty.setText("1");
            edtScanQty.setEnabled(false);
        }

    }

    private void updateLayout(final InventoryData.Data item) {

        runOnUiThread(new Runnable() {
            @SuppressLint("SetTextI18n")
            @Override
            public void run() {
                try {
                    if (item != null) {
                        Log.e(TAG, "updateLayout: " + item.getBarcode());
                        edtItemCode.setText(item.getBarcode());
                        edtBarcode.setText(item.getBarcode());
                        tvDescription.setText(item.getDescription());
                        edtStockQty.setText(item.getStartQty() + "");
//						tvMrp.setText(String.format(String.valueOf(item.unitPrice)));
                        tvMrp.setText(String.format(Locale.US, "%.6f", item.getMrp()));
//            			itemTotalScanQtyShow(item); //show total scan
                        getScanItemInfo(item);

                        if (!isCameraBarcode) {
                            edtScanQty.requestFocus();
//                		edtBarcode.addTextChangedListener(mBarCodeTextWatcher);
                        }

                        if (searchType.equalsIgnoreCase(TYPE_SCAN)) {
                            edtBarcode.addTextChangedListener(mBarCodeTextWatcher);
                        }
                    }


                    if (chkScanMultiQty.isChecked()) {
                        edtMultiQty.setText("");
                        edtMultiQty.setEnabled(true);
                    } else {
                        edtMultiQty.setText("1");
                        edtMultiQty.setEnabled(false);
                    }

                    // set cursor at last position
                    edtBarcode.setSelection(edtBarcode.getText().length());
                    edtScanQty.setSelection(edtScanQty.getText().length());
                } catch (Exception e) {
                    Log.e(TAG, "updateLayout error: " + e);
                }
            }
        });
    }

    private void itemSearch() {
        String barcode = edtBarcode.getText().toString().trim();
        Log.e(TAG, "itemSearch: " + barcode);
        if (!barcode.isEmpty()) {
            if (edtScanQty.isActivated()) {
                edtScanQty.setActivated(false);
                edtScanQty.addTextChangedListener(mQuantityTextWatcher);
            }

            pref.setBarCode(barcode);
            barcodeProcess(barcode);
        }
    }

    private void startBarcodeScanner() {
        IntentIntegrator integrator = new IntentIntegrator(this);
        integrator.setDesiredBarcodeFormats(IntentIntegrator.ONE_D_CODE_TYPES);
        integrator.setPrompt("Scan a barcode");
        integrator.setCameraId(0);  // Use a specific camera of the device
        integrator.setBeepEnabled(false);
        integrator.setBarcodeImageEnabled(true);
        integrator.setOrientationLocked(true);
        integrator.initiateScan();
    }

    private void barcodeProcess(String barcode) {
        Log.e("TAG", "Barcode: " + barcode);

        edtBarcode.removeTextChangedListener(mBarCodeTextWatcher);

        if (pref.isOnlineMode()) {
            barcodeProcessForOnline(barcode.trim().toUpperCase());
        } else {
            barcodeProcessForOffline(barcode.trim().toUpperCase());
        }
    }

    private void barcodeProcessForOnline(final String barcode) {
        Log.e("online", "barcodeProcessForOnline: ");

        //barcode = "123";
        String baseUrl = pref.getBaseUrl();
        String depoCode = pref.getOutletCode();
        String url = baseUrl + "Data/GetByBarcode?barcode=" + barcode + "&depoCode=" + depoCode + "&searchText=";
        Log.e("TAG", "GetByBarcode URL: " + url);

        StringRequest strq = new StringRequest(Request.Method.GET, url, response -> {
            Log.e(TAG, response);
            JsonValidator jv = new JsonValidator();

            try {
                JSONObject json = new JSONObject(response);
                boolean status = jv.getBoolean(json, "Status");
                JSONArray data = json.getJSONArray("ReturnData");

                if (status && data.length() > 0) {

//                    for (int i = 0; i < data.length(); i++) {
                    JSONObject j = data.getJSONObject(0);

                    Log.e(TAG, "onResponse: " + jv.getString(j, "xtype"));
                    if (jv.getString(j, "xtype").equalsIgnoreCase("0")) {
                        edtScanQty.setInputType(InputType.TYPE_CLASS_NUMBER);
                    } else {
                        edtScanQty.setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);
                    }

                    String itemCode = jv.getString(j, "PRODUCTCODE");
                    String name = jv.getString(j, "PRODUCTNAME");
                    double currentStock = jv.getDouble(j, "CurrentStock");
                    double sale = jv.getDouble(j, "SALES");
                    double unitPrice = jv.getDouble(j, "UnitPrice");

                    itemSearch = new ItemSearch(itemCode, barcode, name, (int) currentStock, (int) sale, unitPrice);
                    Log.e(TAG, "SearchResult: " + itemSearch.barcode + " " + itemSearch.name);

//                    }
                    barcodeProcessForOffline(itemCode);
                } else {
                    barcodeProcessFailed();
                }
            } catch (JSONException e) {
                Log.d(TAG, "barcodeProcessForOnline Jason error :" + e);
                barcodeProcessFailed();
            }
        }, error -> {
            //Log.e("TAG", error.getMessage().toString());
            errorVibration();
            Utils.errorDialog(ScanActivity.this, "Connection Error", error.getMessage());
            edtBarcode.requestFocus();
        });
        AppController.getInstance().addToRequestQueue(strq);
    }

    private void barcodeProcessForOffline(final String barcode) {
        try {
            new Thread(() -> {
                final List<InventoryData.Data> list = DB.getOfflineItemByBarcode(barcode);

                runOnUiThread(() -> {
                    if (list.size() > 1) {
                        //select Item From List
                        showBarcodeMultipleItemDialog(list);
                        //searchType="barcode";
                    } else if (list.size() == 1) {
                        item = list.get(0);
                        searchType = TYPE_SCAN;
                        updateLayout(item);

                        // save for single qty
                        if (!chkScanMultiQty.isChecked()) {
                            //processForSaveItem();
                            processForSaveItemToLocal();
                        }

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
        // Create a custom dialog
        Dialog dialog = new Dialog(this);
        dialog.setCancelable(false); // Prevents dismissal on back press
        dialog.setCanceledOnTouchOutside(false); // Prevents dismissal on outside touch

        // Create the root layout (LinearLayout vertical)
        LinearLayout rootLayout = new LinearLayout(this);
        rootLayout.setOrientation(LinearLayout.VERTICAL);
        rootLayout.setPadding(20, 20, 20, 20);

        // Create a horizontal layout for the title and close button
        LinearLayout titleLayout = new LinearLayout(this);
        titleLayout.setOrientation(LinearLayout.HORIZONTAL);
        titleLayout.setGravity(Gravity.CENTER_VERTICAL);
        titleLayout.setPadding(0, 0, 0, 10); // Add some bottom padding for spacing

        // Create the title TextView
        TextView titleView = new TextView(this);
        titleView.setText(R.string.select_a_product);
        titleView.setTextSize(20); // Match typical dialog title size
        titleView.setTextColor(getResources().getColor(android.R.color.black));
        LinearLayout.LayoutParams titleParams = new LinearLayout.LayoutParams(
                0,
                LinearLayout.LayoutParams.WRAP_CONTENT,
                1.0f // Weight to take remaining space
        );
        titleView.setLayoutParams(titleParams);

        // Create the close button
        Button closeButton = new Button(this);
        closeButton.setText("X");
        closeButton.setBackgroundResource(android.R.drawable.btn_default); // Optional: Use default button style
        closeButton.setTextColor(getResources().getColor(android.R.color.holo_red_dark));
        closeButton.setPadding(40, 0, 40, 0); // Reduce internal padding (left, top, right, bottom)
        LinearLayout.LayoutParams buttonParams = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
        );
        buttonParams.setMargins(8, 0, 0, 0); // Margin to separate from title
        closeButton.setLayoutParams(buttonParams);
        closeButton.setMinWidth(0); // Prevent button from being too wide
        closeButton.setMinimumWidth(0); // Ensure minimal width
        closeButton.setMinHeight(0); // Prevent button from being too tall
        closeButton.setMinimumHeight(0); // Ensure minimal height

        // Add title and close button to the title layout
        titleLayout.addView(titleView);
        titleLayout.addView(closeButton);

        // Create ListView
        ListView listView = new ListView(this);
        ItemSearchAdapter adapter = new ItemSearchAdapter(ScanActivity.this, list);
        listView.setAdapter(adapter);

        // Add title layout and ListView to root layout
        rootLayout.addView(titleLayout);
        rootLayout.addView(listView);

        // Set the custom view to the dialog
        dialog.setContentView(rootLayout);
        dialog.show();

        // Close button click listener to restart the activity
        closeButton.setOnClickListener(v -> {
            dialog.dismiss(); // Dismiss the dialog
            finish(); // Finish the current activity
            startActivity(getIntent()); // Restart the activity
        });

        // ListView item click listener
        listView.setOnItemClickListener((parent, view, position, id) -> {
            item = list.get(position);
            searchType = TYPE_SCAN;
            updateLayout(item);

            Log.e(TAG, "Selected ITEMs SALE BARCODE: " + item.getsBarcode());

            // Save for single qty
            if (!chkScanMultiQty.isChecked()) {
                processForSaveItemToLocal();
            }

            dialog.dismiss();
        });
    }

    /*private void showBarcodeMultipleItemDialog(final List<InventoryData.Data> list) {
        AlertDialog.Builder d = new AlertDialog.Builder(this);
        d.setTitle("Select a Product");

        LinearLayout layout = new LinearLayout(this);
        layout.setOrientation(LinearLayout.VERTICAL);
        layout.setPadding(20, 50, 20, 50);

        ListView listView = new ListView(this);
        layout.addView(listView);

        ItemSearchAdapter adapter = new ItemSearchAdapter(ScanActivity.this, list);
        listView.setAdapter(adapter);

        d.setView(layout);

        final AlertDialog dialog = d.create();
        dialog.setCancelable(false); // Prevents dismissal on back press
        dialog.setCanceledOnTouchOutside(false); // Prevents dismissal on outside touch
        dialog.show();

        listView.setOnItemClickListener((parent, view, position, id) -> {
            item = list.get(position);
            searchType = TYPE_SCAN;
            updateLayout(item);

            Log.e(TAG, "Selected ITEMs SALE BARCODE: " + item.getsBarcode());

            // save for single qty
            if (!chkScanMultiQty.isChecked()) {
                //processForSaveItem();
                processForSaveItemToLocal();
            }

            dialog.dismiss();
        });

    }*/

    private void barcodeProcessFailed() {
        edtBarcode.addTextChangedListener(mBarCodeTextWatcher);
        AlertDialog.Builder d = new AlertDialog.Builder(this);
        d.setTitle("Error!");
        d.setMessage("No Item Found. Would you like to search item?");

        d.setNegativeButton("NO", (dialog, which) -> {
            dialog.dismiss();
            clearLayout();
        });
        d.setPositiveButton("YES", (dialog, which) -> startActivityForResult(new Intent(ScanActivity.this, SearchActivity.class), REQUEST_CODE_ITEM_SEARCH));

        d.create().show();
        errorVibration();
    }

    private void getItemListForServer() {

        saveInventoryList.clear();

        SaveInventory saveInventory;

        for (int i = 0; i < scanItemsArrayList.size(); i++) {

            saveInventory = new SaveInventory();

            saveInventory.itemCode = scanItemsArrayList.get(i).getItemCode();
            saveInventory.barcode = scanItemsArrayList.get(i).getBarcode();
            saveInventory.userBarcode = scanItemsArrayList.get(i).getUserBarcode();
            saveInventory.sBarcode = scanItemsArrayList.get(i).getSBarcode();
            saveInventory.itemDescription = scanItemsArrayList.get(i).getItemDescription();
            saveInventory.scanQty = scanItemsArrayList.get(i).getScanQty();
            saveInventory.adjQty = scanItemsArrayList.get(i).getAdjQty();
            saveInventory.userId = scanItemsArrayList.get(i).getUserId();
            saveInventory.deviceId = scanItemsArrayList.get(i).getDeviceId();
            saveInventory.zoneName = scanItemsArrayList.get(i).getZoneName();
            saveInventory.scQty = scanItemsArrayList.get(i).getScQty();
            saveInventory.srQty = scanItemsArrayList.get(i).getSrQty();
            saveInventory.enQty = scanItemsArrayList.get(i).getEnQty();
            saveInventory.createDate = scanItemsArrayList.get(i).getCreateDate();
            saveInventory.systemQty = scanItemsArrayList.get(i).getSystemQty();
            saveInventory.sQty = scanItemsArrayList.get(i).getSQty();
            saveInventory.outletCode = scanItemsArrayList.get(i).getOutletCode();
            saveInventory.salePrice = scanItemsArrayList.get(i).getSalePrice();
            saveInventory.cpu = scanItemsArrayList.get(i).getCpu();
            saveInventory.sessionId = scanItemsArrayList.get(i).getSessionId();

            saveInventoryList.add(saveInventory);
        }

        if (saveInventoryList.isEmpty()) {
            //Toast.makeText(this, "No Item here", Toast.LENGTH_SHORT).show();
            Utils.errorDialog(this, "Empty Item", "Scan item is empty. Please scan a item first.");
            errorVibration();
        } else {
            Log.d("ServerListSize", String.valueOf(saveInventoryList.size()));
            checkSessionValidity();
//            sendItemToServer();
            //saveInventoryList.clear();
        }
    }

    private void checkSessionValidity() {
        progressDialog.setMessage("Checking Session Validity");
        progressDialog.show();

        String url = pref.getBaseUrl() + "/ValuesApi/GetSession?FromDate=2024-01-01&ToDate=" + currentDate;
        StringRequest stringRequest = new StringRequest(Request.Method.GET, url,
                response -> {
                    Log.e(TAG, "checkSessionValidity Url: " + url);
                    Log.e(TAG, "checkSessionValidity response: " + response);
                    try {
                        boolean isValid = true;
                        String invalidSessionId = "";
                        JSONArray jsonArray = new JSONArray(response);
                        List<String> savedSessionIds = pref.getSessionIds();
                        List<String> newSessionList = new ArrayList<>();

                        for (int i = 0; i < jsonArray.length(); i++) {
                            JSONObject jsonObject = jsonArray.getJSONObject(i);
                            String sessionId = jsonObject.getString("SessionId");
                            newSessionList.add(sessionId);
                        }

                        for (String savedSessionId : savedSessionIds) {
                            if (!newSessionList.contains(savedSessionId)) {
                                isValid = false;
                                invalidSessionId = savedSessionId;
                                break;
                            }
                        }

                        if (progressDialog.isShowing()) {
                            progressDialog.dismiss();
                        }
                        if (isValid) {
                            sendItemToServer();
                        } else {
                            Utils.errorDialog(ScanActivity.this, "Session Validity Failed", "Session " + invalidSessionId + " is Not Valid");
                        }

                    } catch (JSONException e) {
                        if (progressDialog.isShowing()) {
                            progressDialog.dismiss();
                        }
                        Log.e(TAG, "GetSessionId JSONException error:", e);
                    }
                },
                error -> {
                    if (progressDialog.isShowing()) {
                        progressDialog.dismiss();
                    }
                    String errorMessage = "";

                    if (error instanceof TimeoutError) {
                        errorMessage += "Connection Error: Request Timeout When Getting Session ID.";
                    } else if (error.networkResponse != null && error.networkResponse.statusCode == 404) {
                        errorMessage += "Connection Error: Resource not found When Getting Session ID.";
                    } else {
                        errorMessage += "Connection Error: " + error.getMessage();
                    }
                    Toast.makeText(this, errorMessage, Toast.LENGTH_LONG).show();
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

    //	private void sendItemToServer() {
//		String url = pref.getBaseUrl() + "Data/SaveInventory";
////		String sessionId = pref.getSession();
//		progressDialog.show();
//
//		JSONArray jsonArray = new JSONArray();
//		for (SaveInventory item : saveInventoryList) {
//			JSONObject jsonObject = new JSONObject();
//			try {
//				jsonObject.put("UserID", item.userId);
//				jsonObject.put("DeviceID", item.deviceId);
//				jsonObject.put("SessionId", item.sessionId);
//				jsonObject.put("OutletCode", item.outletCode);
//				jsonObject.put("ZoneName", item.zoneName);
//				jsonObject.put("ItemCode", item.itemCode);
//				jsonObject.put("Barcode", item.barcode);
//				jsonObject.put("User_Barcode", item.userBarcode);
//				jsonObject.put("sBarcode", item.sBarcode);
//				jsonObject.put("ItemDescription", item.itemDescription);
////				jsonObject.put("SalePrice", String.format(Locale.US, "%.6f", Double.parseDouble(item.salePrice)));
//				try {
//					jsonObject.put("SalePrice", String.format(Locale.US, "%.6f", Double.parseDouble(item.salePrice)));
//				} catch (NumberFormatException e) {
//					Log.d(TAG, "Invalid salePrice: " + item.salePrice);
//					jsonObject.put("SalePrice", 0.0);
//				}
//				jsonObject.put("SystemQty", item.systemQty);
//				jsonObject.put("ScanQty", item.scanQty);
//				jsonObject.put("ScQty", item.scQty);
//				jsonObject.put("AdjQty", item.adjQty);
//				jsonObject.put("SrQty", item.srQty);
//				jsonObject.put("EnQty", item.enQty);
//				jsonObject.put("Sqty", item.sQty);
//				jsonObject.put("ScanDate", item.createDate);
//				jsonObject.put("CPU", item.cpu);
//
//				jsonArray.put(jsonObject);
//			} catch (JSONException e) {
//				Log.d(TAG, "jsonArray error: " + e);
//			}
//		}
//
//		Log.e(TAG, "URL: " + url);
//		Log.e(TAG, "JSON Array: " + jsonArray);
//
//		JsonObjectRequest jsonObjectRequest = getRequest(url, jsonArray);
//
//		AppController.getInstance().addToRequestQueue(jsonObjectRequest);
//
//		checkTotalScanQty();
//		loadLocalSaveItems();
//		Log.d("saveInventoryList", String.valueOf(scanItemsArrayList.size()));
//	}
//
//	private @NonNull JsonObjectRequest getRequest(String url, JSONArray jsonArray) {
//		JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(Request.Method.POST, url, null,
//				response -> {
//					progressDialog.dismiss();
//					try {
//						Log.e(TAG, "onResponse: " + response);
//						boolean status = response.getBoolean("Status");
//						if (status) {
//							clearLayout();
//							Toast.makeText(ScanActivity.this, "All data saved successfully!", Toast.LENGTH_SHORT).show();
//
//							DB.deleteScannedData();
//							DB.deleteInventoryData();
//
////							DB.addUsedSession(pref.getSession());
////							pref.setSession("");
//							DB.addUsedSessions(pref.getSessionIds());
//							pref.setSessionIds(null);
//
//							Intent intent = new Intent(ScanActivity.this, LoginActivity.class);
//							intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
//							startActivity(intent);
//							finish();
//						} else {
//							errorVibration();
//							Utils.errorDialog(ScanActivity.this, "Error", "Error saving data");
//						}
//					} catch (JSONException e) {
//						Log.d(TAG, "sendItemToServer error: " + e);
//					}
//				}, error -> {
//			progressDialog.dismiss();
//			errorVibration();
////			error.printStackTrace();
//			Log.d(TAG, "sendItemToServer error: " + error.getMessage());
//			Utils.errorDialog(ScanActivity.this, "Connection Error", error.getMessage());
//		}) {
//			@Override
//			public byte[] getBody() {
//				return jsonArray.toString().getBytes();
//			}
//
//			@Override
//			public String getBodyContentType() {
//				return "application/json; charset=utf-8";
//			}
//
//			@Override
//			public Map<String, String> getHeaders() {
//				Map<String, String> headers = new HashMap<>();
//				headers.put("Content-Type", "application/json");
//				return headers;
//			}
//		};
//
//		jsonObjectRequest.setRetryPolicy(new DefaultRetryPolicy(
//				3060000, // Timeout in 2 minutes
//				DefaultRetryPolicy.DEFAULT_MAX_RETRIES,
//				DefaultRetryPolicy.DEFAULT_BACKOFF_MULT
//		));
//		return jsonObjectRequest;
//	}

    /// New Comment
//    private void sendItemToServer() {
//        totalItems = saveInventoryList.size();
//        successfulItemsCount = 0;
//        failedItemsCount = 0;
//        String url = pref.getBaseUrl() + "Data/SaveInventory";
//        progressDialog.show();
//
//        sendDataInChunks(url);
//    }
//
//    private void sendDataInChunks(String url) {
//        int batchSize = 500;
//
//        final List<SaveInventory> itemsToSend = new ArrayList<>(saveInventoryList);
//
//        new Thread(() -> {
//            while (!itemsToSend.isEmpty()) {
//                int endIndex = Math.min(batchSize, itemsToSend.size());
//                List<SaveInventory> currentBatch = new ArrayList<>(itemsToSend.subList(0, endIndex));
//                JSONArray jsonArray = createJsonArray(currentBatch);
//
//                boolean status = sendBatchToServer(url, jsonArray);
//                if (status) {
//                    successfulItemsCount += currentBatch.size();
//                    runOnUiThread(() -> DB.deleteScanItems(currentBatch));
//                    // Remove processed items from the list
//                    synchronized (itemsToSend) {
//                        itemsToSend.subList(0, endIndex).clear();
//                    }
//                } else {
//                    failedItemsCount += currentBatch.size();
//                    return;
//                }
//            }
//
//            runOnUiThread(() -> {
//                saveInventoryList.clear();
//                progressDialog.dismiss();
//                clearLayout();
//                Toast.makeText(ScanActivity.this, "Data saved successfully.", Toast.LENGTH_LONG).show();
//                // Toast.makeText(ScanActivity.this, "Data saved successfully.\n Total: " + totalItems + "\n Successful: " + successfulItemsCount + ".", Toast.LENGTH_LONG).show();
//                DB.deleteInventoryData();
//                DB.addUsedSessions(pref.getSessionIds());
//                pref.setSessionIds(null);
//
//                Intent intent = new Intent(ScanActivity.this, LoginActivity.class);
//                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
//                startActivity(intent);
//                finish();
//            });
//        }).start();
//    }

    private void sendItemToServer() {
        totalItems = saveInventoryList.size();
        successfulItemsCount = 0;
        failedItemsCount = 0;
        String url = pref.getBaseUrl() + "Data/SaveInventory";

        HandlerThread handlerThread = new HandlerThread("SendDataThread");
        handlerThread.start();
        Handler handler = new Handler(handlerThread.getLooper());

        runOnUiThread(() -> {
            progressDialog = new ProgressDialog(ScanActivity.this);
            progressDialog.setMessage("Sending Scanned Data to Server...");
            progressDialog.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
            progressDialog.setMax(totalItems);
            progressDialog.setProgress(0);
            progressDialog.setCancelable(false);
            progressDialog.show();
        });

        handler.post(() -> sendDataInChunks(url));
    }

    private void sendDataInChunks(String url) {
        int batchSize = 6;
        int startIndex = 0;

        while (startIndex < saveInventoryList.size()) {
            int endIndex = Math.min(startIndex + batchSize, saveInventoryList.size());
            List<SaveInventory> currentBatch = saveInventoryList.subList(startIndex, endIndex);
            JSONArray jsonArray = createJsonArray(currentBatch);

            boolean status = sendBatchToServer(url, jsonArray);
            if (status) {
                successfulItemsCount += currentBatch.size();
                runOnUiThread(() -> progressDialog.setProgress(successfulItemsCount));

                // Delete from DB for successful batch
                DB.deleteScanItems(new ArrayList<>(currentBatch));
                startIndex = endIndex; // Move to next batch
            } else {
                // Calculate failed items (remaining items in the list)
                int remainingItems = saveInventoryList.size() - startIndex;
                failedItemsCount += remainingItems;

                runOnUiThread(() -> {
                    // Dismiss progress dialog
                    if (progressDialog.isShowing()) {
                        progressDialog.dismiss();
                    }

                    // Show summary dialog
                    showDataSendingSummaryDialog();
                });
                return;
            }
        }

        runOnUiThread(() -> {
            // Remove successfully sent items from memory list
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                saveInventoryList.removeIf(item ->
                        !saveInventoryList.subList(0, successfulItemsCount).contains(item));
            }
            checkTotalScanQty();
            loadLocalSaveItems();

            if (progressDialog.isShowing()) {
                progressDialog.dismiss();
            }

            Toast.makeText(ScanActivity.this, "All Scanned Data Sent Successfully.", Toast.LENGTH_LONG).show();
            clearLayout();

            if (saveInventoryList.isEmpty()) {
                finish();
            }
        });
    }

    private void showDataSendingSummaryDialog() {
        AlertDialog.Builder builder = new AlertDialog.Builder(ScanActivity.this);
        builder.setTitle("Data Sending Summary");

        String message = String.format(
                Locale.ENGLISH,
//                "Data sending completed with following results:\n\n" +
                        """
                        ✅ Total Item Row: %d\s
                        
                        ✅ Successfully Sent: %d items
                        ❌ Failed to Send: %d items
                        """
//                      + "Successfully sent data has been removed from local storage."
                ,
                totalItems,
                successfulItemsCount,
                failedItemsCount
        );

        builder.setMessage(message);
        builder.setCancelable(false);

        builder.setPositiveButton("Close", (dialog, which) -> {
            dialog.dismiss();

            // Update UI after dialog dismissal
            checkTotalScanQty();
            loadLocalSaveItems();
            clearLayout();

            // If no items left, finish activity
            if (saveInventoryList.isEmpty()) {
                finish();
            }
        });

        AlertDialog dialog = builder.create();
        dialog.show();
    }

    /*    private void sendDataInChunks(String url) {
        int batchSize = 200;

        final List<SaveInventory> itemsToSend = new ArrayList<>(saveInventoryList);

        while (!itemsToSend.isEmpty()) {
            int endIndex = Math.min(batchSize, itemsToSend.size());
            List<SaveInventory> currentBatch = new ArrayList<>(itemsToSend.subList(0, endIndex));
            JSONArray jsonArray = createJsonArray(currentBatch);

            boolean status = sendBatchToServer(url, jsonArray);
            if (status) {
                successfulItemsCount += currentBatch.size();
                runOnUiThread(() -> progressDialog.setProgress(successfulItemsCount));

                itemsToSend.subList(0, endIndex).clear();
                // Remove Sent items from Previous Record
                DB.deleteScanItems(currentBatch);
                saveInventoryList.removeAll(currentBatch);
            } else {
                failedItemsCount += currentBatch.size();
                runOnUiThread(() -> {
                    if (progressDialog.isShowing()) {
                        progressDialog.dismiss();
                    }
                });
                return;
            }
        }

        runOnUiThread(() -> {
            checkTotalScanQty();
            loadLocalSaveItems();
            if (progressDialog.isShowing()) {
                progressDialog.dismiss();
            }
            Toast.makeText(ScanActivity.this, "All Scanned Data Sent Successfully.", Toast.LENGTH_LONG).show();
            clearLayout();
            if (saveInventoryList.isEmpty()) {
                finish();
            }
        });
    }*/

    //    private void deleteRunningSessionsConfirmation() {
//        List<String> sessionIds = pref.getSessionIds();
//        if (sessionIds.isEmpty()) {
//            Toast.makeText(this, "No Sessions Found", Toast.LENGTH_SHORT).show();
//            return;
//        }
//        AlertDialog.Builder d = new AlertDialog.Builder(this);
//        d.setTitle("Confirmation");
//        d.setMessage("Do you want to Delete All the running sessions?");
//        d.setNegativeButton("No", (dialog, which) -> dialog.dismiss());
//
//        d.setPositiveButton("Yes", (dialog, which) -> {
//            Toast.makeText(ScanActivity.this, "Session Deleted successfully.", Toast.LENGTH_LONG).show();
//            DB.deleteInventoryData();
//            DB.addUsedSessions(pref.getSessionIds());
//            pref.setSessionIds(null);
//
//            Intent intent = new Intent(ScanActivity.this, LoginActivity.class);
//            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
//            dialog.dismiss();
//            finish();
//            startActivity(intent);
//        });
//        d.create().show();
//    }

    private JSONArray createJsonArray(List<SaveInventory> items) {
        JSONArray jsonArray = new JSONArray();
        for (SaveInventory item : items) {
            JSONObject jsonObject = new JSONObject();
            try {
                jsonObject.put("UserID", item.userId);
                jsonObject.put("DeviceID", item.deviceId);
                jsonObject.put("SessionId", item.sessionId);
                jsonObject.put("OutletCode", item.outletCode);
                jsonObject.put("ZoneName", item.zoneName);
                jsonObject.put("ItemCode", item.itemCode);
                jsonObject.put("Barcode", item.barcode);
                jsonObject.put("User_Barcode", item.userBarcode);
                jsonObject.put("sBarcode", item.sBarcode);
                jsonObject.put("ItemDescription", item.itemDescription);
                try {
                    jsonObject.put("SalePrice", String.format(Locale.US, "%.6f", Double.parseDouble(item.salePrice)));
                } catch (NumberFormatException e) {
                    Log.d(TAG, "Invalid salePrice: " + item.salePrice);
                    jsonObject.put("SalePrice", 0.0);
                }
                jsonObject.put("SystemQty", item.systemQty);
                jsonObject.put("ScanQty", item.scanQty);
                jsonObject.put("ScQty", item.scQty);
                jsonObject.put("AdjQty", item.adjQty);
                jsonObject.put("SrQty", item.srQty);
                jsonObject.put("EnQty", item.enQty);
                jsonObject.put("Sqty", item.sQty);
                jsonObject.put("ScanDate", item.createDate);
                jsonObject.put("CPU", item.cpu);
                jsonArray.put(jsonObject);
            } catch (JSONException e) {
                Log.d(TAG, "jsonArray error: " + e);
            }
        }
        return jsonArray;
    }

    private boolean sendBatchToServer(String url, JSONArray jsonArray) {
        final boolean[] status = {false};
        final CountDownLatch latch = new CountDownLatch(1);

        Log.e(TAG, "sendBatchToServer URL: " + url);
        Log.e(TAG, "Sent JsonArray: " + jsonArray);
        JsonObjectRequest jsonObjectRequest = getRequest(url, jsonArray, response -> {
            try {
                status[0] = response.getBoolean("Status");
                Log.e(TAG, "Received JsonArray: " + response);

            } catch (JSONException e) {
                Log.d(TAG, "sendBatchToServer error: " + e);
            }
            latch.countDown();
        }, error -> {
            error.printStackTrace();
            if (progressDialog.isShowing()) {
                progressDialog.dismiss();
            }

            String finalErrorMessage = getFinalErrorMessage(error);

            runOnUiThread(() -> {
                checkTotalScanQty();
                loadLocalSaveItems();
                Utils.errorDialog(ScanActivity.this, "Error Sending Data!", finalErrorMessage);
            });
            latch.countDown();
        });


        // Set no retry policy - disable all retries
        jsonObjectRequest.setRetryPolicy(new DefaultRetryPolicy(
                120000,
                0,      // No retries (maxNumRetries = 0)
                DefaultRetryPolicy.DEFAULT_BACKOFF_MULT
        ));
        AppController.getInstance().addToRequestQueue(jsonObjectRequest);

        try {
            latch.await();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        return status[0];
    }

    private @NonNull String getFinalErrorMessage(VolleyError error) {
        String errorMessage = "";

        if (error instanceof TimeoutError) {
            errorMessage += "Connection Error: Request Timeout.\n";
        } else {
            errorMessage += "Connection Error: " + error.getMessage() + "\n";
        }

        return errorMessage + "\n" +
                "Total: " + totalItems + "\n" +
                "Successful: " + successfulItemsCount + "\n" +
                "Failed: " + failedItemsCount + "\n";
    }

    private @NonNull JsonObjectRequest getRequest(String url, JSONArray jsonArray,
                                                  Response.Listener<JSONObject> responseListener,
                                                  Response.ErrorListener errorListener) {

        JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(Request.Method.POST, url, null,
                responseListener, errorListener) {
            @Override
            public byte[] getBody() {
                return jsonArray.toString().getBytes();
            }

            @Override
            public String getBodyContentType() {
                return "application/json; charset=utf-8";
            }

            @Override
            public Map<String, String> getHeaders() {
                Map<String, String> headers = new HashMap<>();
                headers.put("Content-Type", "application/json");
                return headers;
            }
        };


        jsonObjectRequest.setRetryPolicy(new DefaultRetryPolicy(
                1020000, // Timeout in 2 minutes
                DefaultRetryPolicy.DEFAULT_MAX_RETRIES,
                DefaultRetryPolicy.DEFAULT_BACKOFF_MULT
        ));
        return jsonObjectRequest;
    }


    private void processForSaveItemToLocal() {

        if (searchType.equalsIgnoreCase(TYPE_SEARCH)) {
            this.scQty = "0";
            this.srQty = edtScanQty.getText().toString().trim();
        } else if (searchType.equalsIgnoreCase(TYPE_SCAN)) {
            this.scQty = edtScanQty.getText().toString().trim();
            this.srQty = "0";
        }

        final String scanQty = edtScanQty.getText().toString().trim();


        if (item == null) {
            Utils.errorDialog(this, "Error", "No Item is selected. Please select a Item first.");
            errorVibration();
            return;
        }

        if (scanQty.isEmpty()) {
            Utils.errorDialog(this, "Empty Quantity!", "Scan Quantity is empty. Please enter quantity");
            errorVibration();
            return;
        }

        try {
            if (Integer.parseInt(scanQty) <= 0) {
                Utils.errorDialog(this, "Zero Quantity!", "Zero Quantity is not allowed. Please enter positive quantity");
                errorVibration();
                return;
            }
        } catch (Exception ignored) {
        }

        this.item.setScanQty(Double.parseDouble(scanQty));

        if (scanQty.length() <= 4) {
            saveItemToLocal(item);
        } else {
            AlertDialog.Builder d = new AlertDialog.Builder(this);
            d.setTitle("Confirmation");
            d.setMessage(Html.fromHtml("<b>" + scanQty + "</b> qty is confusing. are you sure to save?"));
            d.setNegativeButton("NO", (dialog, which) -> dialog.dismiss());
            d.setPositiveButton("YES", (dialog, which) -> saveItemToLocal(item));
            d.create().show();
        }

//		tvLastScannedItem.setText(String.format("%s, MRP: %s", item.itemDescription, item.salePrice));

    }

    private void saveItemToLocal(final InventoryData.Data item) {
        progressDialog.show();


        ScanItems finalItem = new ScanItems(
                item.getBarcode(),
                item.getBarcode(),
                item.getUserBarcode().trim(),
                item.getsBarcode(),
                item.getDescription(),
                String.valueOf(item.getScanQty()),
                "0",
                this.userId,
                this.deviceId,
                this.zoneName,
                String.valueOf(item.getScanQty()),
                String.valueOf(item.getStartQty()),
                "0",
                this.currentDate,
                String.valueOf(item.getStartQty()),
                String.valueOf(item.getScanQty()),
                this.outletCode,
                String.valueOf(item.getMrp()),
                String.valueOf(item.getCpu()),
                item.getSessionId()
        );

        boolean checkInsertData = DB.addNewItem(finalItem);

        //        final List<InventoryData.Data> itemDataList = DB.getOfflineItemByBarcode(item.barcode);
//
//        if (itemDataList != null && !itemDataList.isEmpty()) {
//            List<ScanItems> scanItemsList = new ArrayList<>();
//
//            for (InventoryData.Data itemData : itemDataList) {
//                ScanItems scanItem = new ScanItems(
//                        itemCode,
//                        barcode,
//                        itemData.getUserBarcode().trim(),
//                        itemData.getsBarcode(),
//                        itemDescription,
//                        scanQty,
//                        adjQty,
//                        userId,
//                        deviceId,
//                        zoneName,
//                        scQty,
//                        srQty,
//                        enQty,
//                        createDate,
//                        systemQty,
//                        sQty,
//                        outletCode,
//                        salePrice,
//                        String.valueOf(itemData.getCpu()),
//                        itemData.getSessionId()
//                );
//                scanItemsList.add(scanItem);
//            }
//
//            checkInsertData = DB.addNewSearchItems(scanItemsList);
//        }

//        itemTotalScanQtyShow();
        checkTotalScanQty();
        loadLocalSaveItems();
        clearLayout();
        progressDialog.dismiss();
        Toast toast;
        if (checkInsertData) {
            toast = Toast.makeText(ScanActivity.this, "Data save successfully!", Toast.LENGTH_SHORT);
        } else {
            toast = Toast.makeText(ScanActivity.this, "Data save failed!", Toast.LENGTH_SHORT);
        }
        toast.setGravity(Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 250);
        toast.show();

    }

    private void checkTotalScanQty() {
        String showTotalScanQty = DB.getTotalScanQty();
        String showTempTotalScanQty = DB.getTempTotalScanQty();
        if (showTotalScanQty == null) {
            tvTotalScanQty.setText(R.string._00);
        } else {
            tvTotalScanQty.setText(showTotalScanQty);
        }

        if (showTempTotalScanQty == null) {
            tvTempTotalScanQty.setText(R.string._00);
        } else {
            tvTempTotalScanQty.setText(showTempTotalScanQty);
        }

        Log.e(TAG, "onResponse: Total Scan Quantity: " + showTotalScanQty);
    }

/*    private void itemTotalScanQtyShow() {

        String barcode = edtItemCode.getText().toString().trim();
        String showItemTotalScanQty = DB.getItemTotalScanQty(barcode);

		if (showItemTotalScanQty == null) {
			tvItemTotalScanQty.setText(R.string._00);
		} else {
			tvItemTotalScanQty.setText(showItemTotalScanQty);
		}

        Log.e(TAG, "onResponse: Item Total Scan Quantity: " + showItemTotalScanQty);

    }*/

    private void getScanItemInfo(final InventoryData.Data item) {
        Log.e(TAG, "ItemSearch item: " + item.toString());

        String baseUrl = pref.getBaseUrl();

        String deviceId = this.deviceId;
        String userId = this.userId;
        String zoneName = this.zoneName;
        String depoCode = this.outletCode;

        String url = baseUrl + "Data/GetScanItemInfo";
        try {
            url += "?barcodeItemcode=" + URLEncoder.encode(pref.getBarCode(), getString(R.string.utf_8)) +
                    "&deviceId=" + URLEncoder.encode(deviceId, getString(R.string.utf_8)) +
                    "&userId=" + URLEncoder.encode(userId, getString(R.string.utf_8)) +
                    "&zoneName=" + URLEncoder.encode(zoneName, getString(R.string.utf_8)) +
                    "&depoCode=" + URLEncoder.encode(depoCode, getString(R.string.utf_8));
        } catch (Exception e) {
            Log.e(TAG, "URL Error: " + e);
        }

        Log.e(TAG, "GetItemScanQty url: " + url);

        StringRequest strReq = new StringRequest(Request.Method.GET, url, response -> {
            Log.e("TAG", "GetItemScanQty response: " + response);
            try {
                JSONObject json = new JSONObject(response);
                boolean status = new JsonValidator().getBoolean(json, "Status");

                if (status) {
                    if (!json.isNull("ReturnData")) {
                        JSONObject returnObject = json.getJSONObject("ReturnData");

                        adjQty = 0;
                        adjQty = returnObject.getDouble("AdjQty");
                        Log.e(TAG, "onResponse: adjQty: " + adjQty);

//                        itemTotalScanQtyShow();
                    } else {
                        Log.e(TAG, "ReturnData is null");
                        edtScanQty.setText(edtScanQty.isActivated() ? "0" : "");
                    }
                } else {
                    edtScanQty.setText(edtScanQty.isActivated() ? "0" : "");
                }
            } catch (JSONException e) {
//                itemTotalScanQtyShow();
                Log.e(TAG, "onResponse: " + e);
            }
        }, Throwable::printStackTrace);

        AppController.getInstance().addToRequestQueue(strReq);
    }

    private void saveToLocalConfirmationDialog() {
        String tempScanItemQty = DB.getTempTotalScanQty();
        if (tempScanItemQty == null || tempScanItemQty.isEmpty() || tempScanItemQty.equals("0")) {
            Toast.makeText(this, "No Temporary Item Found", Toast.LENGTH_SHORT).show();
            return;
        }
        AlertDialog.Builder d = new AlertDialog.Builder(this);
        d.setTitle("Confirmation");
        d.setMessage("Do you want to Save All Scanned Items to Local?");
        d.setNegativeButton("No", (dialog, which) -> dialog.dismiss());

        d.setPositiveButton("Yes", (dialog, which) -> {
            DB.saveTempScanItemsToLocal();
            loadLocalSaveItems();
            checkTotalScanQty();
            dialog.dismiss();
        });
        d.create().show();
    }

    private void errorVibration() {

        mVibrator.vibrate(600); // Vibrate for 400 milliseconds

    }

    private final BroadcastReceiver scanDataReceiver = new BroadcastReceiver() {

        @Override
        public void onReceive(Context context, Intent intent) {
            Log.e("TAG", "onReceive: ");
            // Bundle bundle = intent.getExtras();
            String codeString = null;
            String codeId;
            if (intent.hasExtra("data")) {
                codeString = intent.getStringExtra("data");
                Log.e("TAG", "barcode: " + codeString);
            }
            if (intent.hasExtra("codetype")) {
                codeId = intent.getStringExtra("codetype");
                Log.e("TAG", "codeType: " + codeId);

            }

            if (codeString != null) {
                Log.e("bar", "processing barcode....");
                barcodeProcess(codeString);
            }

        }
    };

    @Override
    public boolean onKeyUp(int keyCode, KeyEvent event) {
        //return super.onKeyUp(keyCode, event);
        return switch (keyCode) {
            case KeyEvent.KEYCODE_F1 -> {
                clearLayout();
                yield true;
            }
            case KeyEvent.KEYCODE_F2 -> {
                processForSaveItemToLocal();
                yield true;
                //processForSaveItem(); // save item
            }
            default -> super.onKeyUp(keyCode, event);
        };

    }

}

