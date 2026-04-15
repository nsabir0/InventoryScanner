package com.ms.inventory.utils;

import android.annotation.SuppressLint;
import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

import androidx.annotation.NonNull;

import com.ms.inventory.model.InventoryData;
import com.ms.inventory.model.SaveInventory;
import com.ms.inventory.model.ScanItems;

import java.util.ArrayList;
import java.util.List;

public class DBHelper extends SQLiteOpenHelper {

    private static final String TAG = "DBHelper";
    private static final String DB_NAME = "inventorydb";

    //    private SQLiteDatabase database;
    private static SQLiteOpenHelper dbHelper;

    PreferenceManager pref;

    private static final int DB_VERSION = 3;

    private static final String TABLE_SCANITEMS = "scanitems";
    private static final String TABLE_TEMP_SCANITEMS = "tempscanitems";
    private static final String TABLE_INVENTORY = "inventorydata";
    private static final String TABLE_USED_SESSION_DATA = "usedsessiondata";

    private static final String ID_COL = "id";
    private static final String ITEM_CODE_COL = "itemCode";
    private static final String BARCODE_COL = "barcode";
    private static final String USER_BARCODE_COL = "userBarcode";
    private static final String S_BARCODE_COL = "sBarcode";
    private static final String ITEM_DESCRIPTION_COL = "itemDescription";
    private static final String SCAN_QTY_COL = "scanQty";
    private static final String ADJ_QTY_COL = "adjQty";
    private static final String USER_ID_COL = "userId";
    private static final String DEVICE_ID_COL = "deviceId";
    private static final String ZONE_NAME_COL = "zoneName";
    private static final String SC_QTY_COL = "scQty";
    private static final String SR_QTY_COL = "srQty";
    private static final String EN_QTY_COL = "enQty";
    private static final String CREATE_DATE_COL = "createDate";
    private static final String SYSTEM_QTY_COL = "systemQty";
    private static final String S_QTY_COL = "sQty";
    private static final String OUTLET_CODE_COL = "outletCode";
    private static final String SALE_PRICE_COL = "salePrice";
    private static final String CPU_COL = "cpu";
    private static final String SESSION_ID_COL = "sessionId";

    private static final String START_QTY_COL = "startQty";
    private static final String SCAN_START_DATE_COL = "scanStartDate";
    private static final String MRP_COL = "mrp";
    private static final String DESCRIPTION_COL = "description";


    public DBHelper(Context context) {
        super(context, DB_NAME, null, DB_VERSION);
        this.pref = new PreferenceManager(context);
    }

    public static synchronized DBHelper getInstance(Context context) {
        if (dbHelper == null) {
            dbHelper = new DBHelper(context.getApplicationContext());
        }
        return (DBHelper) dbHelper;
    }

    @Override
    public void onCreate(SQLiteDatabase db) {

        createTable(db, TABLE_SCANITEMS);
        createTable(db, TABLE_TEMP_SCANITEMS);
        createTable(db, TABLE_INVENTORY);
        createTable(db, TABLE_USED_SESSION_DATA);

    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        // this method is called to check if the table exists already.
//        db.execSQL("DROP TABLE IF EXISTS " + TABLE_SCANITEMS);
//        onCreate(db);
        if (oldVersion < 2) {
            db.execSQL("ALTER TABLE " + TABLE_SCANITEMS + " ADD COLUMN " + SESSION_ID_COL + " TEXT");
        }
        if (oldVersion < 3) {
            db.execSQL("ALTER TABLE sessiondata RENAME TO " + TABLE_USED_SESSION_DATA);
            createTable(db, TABLE_TEMP_SCANITEMS);
        }
    }

    private void createTable(SQLiteDatabase db, String tableName) {
        String createTableQuery = switch (tableName) {
            case TABLE_SCANITEMS -> "CREATE TABLE " + TABLE_SCANITEMS + " ("
                    + ID_COL + " INTEGER PRIMARY KEY AUTOINCREMENT, "
                    + ITEM_CODE_COL + " TEXT,"
                    + BARCODE_COL + " TEXT,"
                    + USER_BARCODE_COL + " TEXT,"
                    + S_BARCODE_COL + " TEXT,"
                    + ITEM_DESCRIPTION_COL + " TEXT,"
                    + SCAN_QTY_COL + " TEXT,"
                    + ADJ_QTY_COL + " TEXT,"
                    + USER_ID_COL + " TEXT,"
                    + DEVICE_ID_COL + " TEXT,"
                    + ZONE_NAME_COL + " TEXT,"
                    + SC_QTY_COL + " TEXT,"
                    + SR_QTY_COL + " TEXT,"
                    + EN_QTY_COL + " TEXT,"
                    + CREATE_DATE_COL + " TEXT,"
                    + SYSTEM_QTY_COL + " TEXT,"
                    + S_QTY_COL + " TEXT,"
                    + OUTLET_CODE_COL + " TEXT,"
                    + SALE_PRICE_COL + " TEXT,"
                    + CPU_COL + " TEXT,"
                    + SESSION_ID_COL + " TEXT)";
            case TABLE_TEMP_SCANITEMS -> "CREATE TABLE " + TABLE_TEMP_SCANITEMS + " ("
                    + ID_COL + " INTEGER PRIMARY KEY AUTOINCREMENT, "
                    + ITEM_CODE_COL + " TEXT,"
                    + BARCODE_COL + " TEXT,"
                    + USER_BARCODE_COL + " TEXT,"
                    + S_BARCODE_COL + " TEXT,"
                    + ITEM_DESCRIPTION_COL + " TEXT,"
                    + SCAN_QTY_COL + " TEXT,"
                    + ADJ_QTY_COL + " TEXT,"
                    + USER_ID_COL + " TEXT,"
                    + DEVICE_ID_COL + " TEXT,"
                    + ZONE_NAME_COL + " TEXT,"
                    + SC_QTY_COL + " TEXT,"
                    + SR_QTY_COL + " TEXT,"
                    + EN_QTY_COL + " TEXT,"
                    + CREATE_DATE_COL + " TEXT,"
                    + SYSTEM_QTY_COL + " TEXT,"
                    + S_QTY_COL + " TEXT,"
                    + OUTLET_CODE_COL + " TEXT,"
                    + SALE_PRICE_COL + " TEXT,"
                    + CPU_COL + " TEXT,"
                    + SESSION_ID_COL + " TEXT)";
            case TABLE_INVENTORY -> "CREATE TABLE " + TABLE_INVENTORY + " ("
                    + ID_COL + " INTEGER PRIMARY KEY AUTOINCREMENT, "
                    + SESSION_ID_COL + " TEXT,"
                    + BARCODE_COL + " TEXT,"
                    + S_BARCODE_COL + " TEXT,"
                    + USER_BARCODE_COL + " TEXT,"
                    + START_QTY_COL + " REAL,"
                    + SCAN_QTY_COL + " REAL,"
                    + SCAN_START_DATE_COL + " TEXT,"
                    + MRP_COL + " REAL,"
                    + DESCRIPTION_COL + " TEXT,"
                    + CPU_COL + " REAL)";
            case TABLE_USED_SESSION_DATA -> "CREATE TABLE " + TABLE_USED_SESSION_DATA + " ("
                    + ID_COL + " INTEGER PRIMARY KEY AUTOINCREMENT, "
                    + SESSION_ID_COL + " TEXT)";
            default -> "";
        };

        try {
            db.execSQL(createTableQuery);
        } catch (Exception e) {
            Log.e(TAG, "Failed to create '" + tableName + "' database: " + e);
        }
    }

    public int countTableItem() {
        SQLiteDatabase db = this.getWritableDatabase();
        db.beginTransaction();

        Cursor cursor = db.rawQuery("SELECT COUNT(*) FROM " + TABLE_INVENTORY, null);
        cursor.moveToFirst();
        int tableItemCount = cursor.getInt(0);
        cursor.close();
        db.endTransaction();

        return tableItemCount;
    }

    public void addUsedSessions(List<String> sessionIds) {
        SQLiteDatabase db = this.getWritableDatabase();
        db.beginTransaction();

        try {
            for (String sessionId : sessionIds) {
                ContentValues values = new ContentValues();
                values.put(SESSION_ID_COL, sessionId);
                db.insert(TABLE_USED_SESSION_DATA, null, values);
            }
            db.setTransactionSuccessful();
        } catch (Exception e) {
            Log.d(TAG, "Error saving saved sessions: " + e);
        } finally {
            db.endTransaction();
        }
    }

    public List<String> getUsedSessionIds() {
        List<String> sessionIds = new ArrayList<>();
        SQLiteDatabase db = this.getReadableDatabase();

        try (Cursor cursor = db.rawQuery("SELECT " + SESSION_ID_COL + " FROM " + TABLE_USED_SESSION_DATA, null)) {
            if (cursor != null && cursor.moveToFirst()) {
                int sessionIdIndex = cursor.getColumnIndex(SESSION_ID_COL);
                if (sessionIdIndex != -1) {
                    do {
                        String sessionId = cursor.getString(sessionIdIndex);
                        sessionIds.add(sessionId);
                    } while (cursor.moveToNext());
                } else {
                    Log.e(TAG, "Column 'sessionId' not found in the result set.");
                }
            }
        } catch (Exception e) {
            Log.e(TAG, "Error fetching session IDs: " + e);
        }
        return sessionIds;
    }

    public boolean isSessionUsed(String sessionId) {
        boolean isSessionUsed = false;
        SQLiteDatabase db = this.getReadableDatabase();

        String[] projection = {SESSION_ID_COL};

        String selection = SESSION_ID_COL + " = ?";
        String[] selectionArgs = {sessionId};

        Cursor cursor = db.query(
                TABLE_USED_SESSION_DATA,  // The table to query
                projection,            // The array of columns to return (null to return all)
                selection,             // The columns for the WHERE clause
                selectionArgs,         // The values for the WHERE clause
                null,                  // Don't group the rows
                null,                  // Don't filter by row groups
                null                   // The sort order
        );


        if (cursor != null && cursor.moveToFirst()) {
            isSessionUsed = cursor.getCount() > 0;
            cursor.close();
        }

        return isSessionUsed;
    }


    public void addInventoryData(List<InventoryData.Data> dataList) {
        SQLiteDatabase database = getReadableDatabase();
        database.beginTransaction();

        try {

            ContentValues values = new ContentValues();
            for (InventoryData.Data data : dataList) {
                values.put(SESSION_ID_COL, data.getSessionId());
                values.put(BARCODE_COL, data.getBarcode());
                values.put(S_BARCODE_COL, data.getsBarcode());
                values.put(USER_BARCODE_COL, data.getUserBarcode().trim());
                values.put(START_QTY_COL, data.getStartQty());
                values.put(SCAN_QTY_COL, data.getScanQty());
                values.put(SCAN_START_DATE_COL, data.getScanStartDate());
                values.put(MRP_COL, data.getMrp());
                values.put(DESCRIPTION_COL, data.getDescription());
                values.put(CPU_COL, data.getCpu());

                database.insert(TABLE_INVENTORY, null, values);
            }
            /*for (InventoryData.Data data : dataList) {
                ContentValues values = new ContentValues();
                values.put(SESSION_ID_COL, data.getSessionId());
                values.put(BARCODE_COL, data.getBarcode());
                values.put(S_BARCODE_COL, data.getsBarcode());
                values.put(USER_BARCODE_COL, data.getUserBarcode().trim());
                values.put(START_QTY_COL, data.getStartQty());
                values.put(SCAN_QTY_COL, data.getScanQty());
                values.put(SCAN_START_DATE_COL, data.getScanStartDate());
                values.put(MRP_COL, data.getMrp());
                values.put(DESCRIPTION_COL, data.getDescription());
                values.put(CPU_COL, data.getCpu());

                // Check if record exists by sBarcode and mrp
                String selection = S_BARCODE_COL + " = ? AND " + MRP_COL + " = ?";
                String[] selectionArgs = {data.getsBarcode(), String.valueOf(data.getMrp())};

                Cursor cursor = database.query(TABLE_INVENTORY,
                        new String[]{SESSION_ID_COL}, // Minimal column to check existence
                        selection,
                        selectionArgs,
                        null, null, null);

                if (cursor.getCount() == 0) {
                    // No record exists, proceed with insert
                    database.insert(TABLE_INVENTORY, null, values);
                }

                cursor.close();
            }*/

            database.setTransactionSuccessful();
            Log.d(TAG, "Inventory data inserted successfully.");

        } finally {
            database.endTransaction();
        }
    }

    /*    @SuppressLint("Range")
    public InventoryData.Data getOfflineItemByBarcode(String key) {
         SQLiteDatabase database = getReadableDatabase();
        String searchKey = key.trim();

        String selection = BARCODE_COL + " = ? OR " + USER_BARCODE_COL + " = ? OR " + S_BARCODE_COL + " = ?";
        String[] selectionArgs = {searchKey, searchKey, searchKey};
        String[] projection = {
                SESSION_ID_COL,
                BARCODE_COL,
                S_BARCODE_COL,
                USER_BARCODE_COL,
                START_QTY_COL,
                SCAN_QTY_COL,
                SCAN_START_DATE_COL,
                MRP_COL,
                DESCRIPTION_COL,
                CPU_COL
        };

        Cursor cursor = database.query(
                TABLE_INVENTORY,        // The table to query
                projection,            // The array of columns to return (null to return all)
                selection,             // The columns for the WHERE clause
                selectionArgs,         // The values for the WHERE clause
                null,                  // Don't group the rows
                null,                  // Don't filter by row groups
                null                   // The sort order
        );

        InventoryData.Data inventoryData = null;
        if (cursor != null && cursor.moveToFirst()) {
            inventoryData = new InventoryData.Data();
            inventoryData.setSessionId(cursor.getString(cursor.getColumnIndex(SESSION_ID_COL)));
            inventoryData.setBarcode(cursor.getString(cursor.getColumnIndex(BARCODE_COL)));
            inventoryData.setsBarcode(cursor.getString(cursor.getColumnIndex(S_BARCODE_COL)));
            inventoryData.setUserBarcode(cursor.getString(cursor.getColumnIndex(USER_BARCODE_COL)).trim());
            inventoryData.setStartQty(cursor.getDouble(cursor.getColumnIndex(START_QTY_COL)));
            inventoryData.setScanQty(cursor.getDouble(cursor.getColumnIndex(SCAN_QTY_COL)));
            inventoryData.setScanStartDate(cursor.getString(cursor.getColumnIndex(SCAN_START_DATE_COL)));
            inventoryData.setMrp(cursor.getDouble(cursor.getColumnIndex(MRP_COL)));
            inventoryData.setDescription(cursor.getString(cursor.getColumnIndex(DESCRIPTION_COL)));
            inventoryData.setCpu(cursor.getDouble(cursor.getColumnIndex(CPU_COL)));
            cursor.close();
        }

        return inventoryData;
    }*/

    public List<InventoryData.Data> getOfflineItemByBarcode(String key) {
        SQLiteDatabase database = getReadableDatabase();
        String searchKey = key.trim();

        String selection = BARCODE_COL + " = ? OR " + USER_BARCODE_COL + " = ? OR " + S_BARCODE_COL + " = ?";
        String[] selectionArgs = {searchKey, searchKey, searchKey};
        String[] projection = {
                SESSION_ID_COL,
                BARCODE_COL,
                S_BARCODE_COL,
                USER_BARCODE_COL,
                START_QTY_COL,
                SCAN_QTY_COL,
                SCAN_START_DATE_COL,
                MRP_COL,
                DESCRIPTION_COL,
                CPU_COL
        };

        List<InventoryData.Data> inventoryDataList = new ArrayList<>();

        Cursor cursor = database.query(
                TABLE_INVENTORY,        // The table to query
                projection,            // The array of columns to return
                selection,             // The columns for the WHERE clause
                selectionArgs,         // The values for the WHERE clause
                null,                  // Don't group the rows
                null,                  // Don't filter by row groups
                null                   // The sort order
        );
        if (cursor != null) {
            while (cursor.moveToNext()) {
                InventoryData.Data inventoryData = new InventoryData.Data();
                inventoryData.setSessionId(cursor.getString(cursor.getColumnIndexOrThrow(SESSION_ID_COL)));
                inventoryData.setBarcode(cursor.getString(cursor.getColumnIndexOrThrow(BARCODE_COL)));
                inventoryData.setsBarcode(cursor.getString(cursor.getColumnIndexOrThrow(S_BARCODE_COL)));
                inventoryData.setUserBarcode(cursor.getString(cursor.getColumnIndexOrThrow(USER_BARCODE_COL)).trim());
                inventoryData.setStartQty(cursor.getDouble(cursor.getColumnIndexOrThrow(START_QTY_COL)));
                inventoryData.setScanQty(cursor.getDouble(cursor.getColumnIndexOrThrow(SCAN_QTY_COL)));
                inventoryData.setScanStartDate(cursor.getString(cursor.getColumnIndexOrThrow(SCAN_START_DATE_COL)));
                inventoryData.setMrp(cursor.getDouble(cursor.getColumnIndexOrThrow(MRP_COL)));
                inventoryData.setDescription(cursor.getString(cursor.getColumnIndexOrThrow(DESCRIPTION_COL)));
                inventoryData.setCpu(cursor.getDouble(cursor.getColumnIndexOrThrow(CPU_COL)));
                inventoryDataList.add(inventoryData);
            }
            cursor.close();
        }

        return inventoryDataList;
    }

    public List<InventoryData.Data> getScannedItemByBarcode(String key) {
        SQLiteDatabase database = getReadableDatabase();
        String searchKey = key.trim();

        String selection = BARCODE_COL + " = ? OR " + USER_BARCODE_COL + " = ? OR " + S_BARCODE_COL + " = ?";
        String[] selectionArgs = {searchKey, searchKey, searchKey};
        String[] projection = {
                SESSION_ID_COL,
                BARCODE_COL,
                S_BARCODE_COL,
                USER_BARCODE_COL,
                SR_QTY_COL,
                SCAN_QTY_COL,
                CREATE_DATE_COL,
                SALE_PRICE_COL,
                ITEM_DESCRIPTION_COL,
                CPU_COL
        };

        List<InventoryData.Data> inventoryDataList = new ArrayList<>();

        Cursor cursor = database.query(
                TABLE_SCANITEMS,        // The table to query
                projection,            // The array of columns to return
                selection,             // The columns for the WHERE clause
                selectionArgs,         // The values for the WHERE clause
                null,                  // Don't group the rows
                null,                  // Don't filter by row groups
                null                   // The sort order
        );
        if (cursor != null) {
            while (cursor.moveToNext()) {
                InventoryData.Data inventoryData = new InventoryData.Data();
                inventoryData.setSessionId(cursor.getString(cursor.getColumnIndexOrThrow(SESSION_ID_COL)));
                inventoryData.setBarcode(cursor.getString(cursor.getColumnIndexOrThrow(BARCODE_COL)));
                inventoryData.setsBarcode(cursor.getString(cursor.getColumnIndexOrThrow(S_BARCODE_COL)));
                inventoryData.setUserBarcode(cursor.getString(cursor.getColumnIndexOrThrow(USER_BARCODE_COL)).trim());
                inventoryData.setStartQty(cursor.getDouble(cursor.getColumnIndexOrThrow(SR_QTY_COL)));
                inventoryData.setScanQty(cursor.getDouble(cursor.getColumnIndexOrThrow(SCAN_QTY_COL)));
                inventoryData.setScanStartDate(cursor.getString(cursor.getColumnIndexOrThrow(CREATE_DATE_COL)));
                inventoryData.setMrp(cursor.getDouble(cursor.getColumnIndexOrThrow(SALE_PRICE_COL)));
                inventoryData.setDescription(cursor.getString(cursor.getColumnIndexOrThrow(ITEM_DESCRIPTION_COL)));
                inventoryData.setCpu(cursor.getDouble(cursor.getColumnIndexOrThrow(CPU_COL)));
                inventoryDataList.add(inventoryData);
            }
            cursor.close();
        }

        return inventoryDataList;
    }

    public InventoryData.Data getSingleInventoryItem(String sBarcode, String salePrice) {
        SQLiteDatabase database = getReadableDatabase();
        String searchKey = sBarcode.trim();

        String selection = S_BARCODE_COL + " = ? AND " + SALE_PRICE_COL + " = ?";
        String[] selectionArgs = {searchKey, salePrice};
        String[] projection = {
                SESSION_ID_COL,
                BARCODE_COL,
                S_BARCODE_COL,
                USER_BARCODE_COL,
                SR_QTY_COL,
                SCAN_QTY_COL,
                CREATE_DATE_COL,
                SALE_PRICE_COL,
                ITEM_DESCRIPTION_COL,
                CPU_COL
        };

        InventoryData.Data inventoryData = null;

        Cursor cursor = database.query(
                TABLE_SCANITEMS,        // The table to query
                projection,            // The array of columns to return
                selection,             // The columns for the WHERE clause
                selectionArgs,         // The values for the WHERE clause
                null,                  // Don't group the rows
                null,                  // Don't filter by row groups
                null                   // The sort order
        );

        if (cursor != null && cursor.moveToFirst()) {
            inventoryData = new InventoryData.Data();
            inventoryData.setSessionId(cursor.getString(cursor.getColumnIndexOrThrow(SESSION_ID_COL)));
            inventoryData.setBarcode(cursor.getString(cursor.getColumnIndexOrThrow(BARCODE_COL)));
            inventoryData.setsBarcode(cursor.getString(cursor.getColumnIndexOrThrow(S_BARCODE_COL)));
            inventoryData.setUserBarcode(cursor.getString(cursor.getColumnIndexOrThrow(USER_BARCODE_COL)).trim());
            inventoryData.setStartQty(cursor.getDouble(cursor.getColumnIndexOrThrow(SR_QTY_COL)));
            inventoryData.setScanQty(cursor.getDouble(cursor.getColumnIndexOrThrow(SCAN_QTY_COL)));
            inventoryData.setScanStartDate(cursor.getString(cursor.getColumnIndexOrThrow(CREATE_DATE_COL)));
            inventoryData.setMrp(cursor.getDouble(cursor.getColumnIndexOrThrow(SALE_PRICE_COL)));
            inventoryData.setDescription(cursor.getString(cursor.getColumnIndexOrThrow(ITEM_DESCRIPTION_COL)));
            inventoryData.setCpu(cursor.getDouble(cursor.getColumnIndexOrThrow(CPU_COL)));
        }

        if (cursor != null) {
            cursor.close();
        }
        database.close();

        return inventoryData;
    }

    /*public String getUserBarcodeFromInventory(String key) {
         SQLiteDatabase database = getReadableDatabase();
        String searchKey = key.trim();

        String selection = BARCODE_COL + " = ? OR " + S_BARCODE_COL + " = ?";
        String[] selectionArgs = {searchKey, searchKey};
        String[] projection = {USER_BARCODE_COL};

        Cursor cursor = database.query(
                TABLE_INVENTORY,  // The table to query
                projection,       // The array of columns to return (null to return all)
                selection,        // The columns for the WHERE clause
                selectionArgs,    // The values for the WHERE clause
                null,             // Don't group the rows
                null,             // Don't filter by row groups
                null              // The sort order
        );

        String userBarcode = null;
        if (cursor != null) {
            if (cursor.moveToFirst()) {
                // Logging cursor column names
                String[] columnNames = cursor.getColumnNames();
                for (String columnName : columnNames) {
                    Log.d("CursorColumn", "Column name: " + columnName);
                }

                int userBarcodeIndex = cursor.getColumnIndex(USER_BARCODE_COL);
                if (userBarcodeIndex != -1) {
                    userBarcode = cursor.getString(userBarcodeIndex).trim();
                } else {
                    Log.e(TAG, "Column index not found for USER_BARCODE_COL");
                }
            } else {
                Log.e(TAG, "Cursor is empty");
            }
            cursor.close();
        } else {
            Log.e(TAG, "Cursor is null");
        }



        return userBarcode;
    }*/

    @SuppressLint("Range")
    public List<InventoryData.Data> searchItemsByBarcode(String key) {
        List<InventoryData.Data> itemList = new ArrayList<>();
        SQLiteDatabase database = getReadableDatabase();
        String searchKey = key.trim();


        String selection = "LOWER(" + BARCODE_COL + ") LIKE ? OR LOWER(" + USER_BARCODE_COL + ") LIKE ? OR LOWER(" + S_BARCODE_COL + ") LIKE ? OR LOWER(" + DESCRIPTION_COL + ") LIKE ?";
        String[] selectionArgs = {"%" + searchKey.toLowerCase() + "%", "%" + searchKey.toLowerCase() + "%", "%" + searchKey.toLowerCase() + "%", "%" + searchKey.toLowerCase() + "%"};
        String[] projection = {
                SESSION_ID_COL,
                BARCODE_COL,
                S_BARCODE_COL,
                USER_BARCODE_COL,
                START_QTY_COL,
                SCAN_QTY_COL,
                SCAN_START_DATE_COL,
                MRP_COL,
                DESCRIPTION_COL,
                CPU_COL
        };

        Cursor cursor = database.query(
                TABLE_INVENTORY,  // The table to query
                projection,            // The array of columns to return (null to return all)
                selection,             // The columns for the WHERE clause
                selectionArgs,         // The values for the WHERE clause
                null,                  // Don't group the rows
                null,                  // Don't filter by row groups
                null,                  // Don't order the rows
                "20"                   // Limit the number of results returned to 50
        );

        if (cursor != null) {
            while (cursor.moveToNext()) {
                InventoryData.Data inventoryData = new InventoryData.Data();
                inventoryData.setSessionId(cursor.getString(cursor.getColumnIndex(SESSION_ID_COL)));
                inventoryData.setBarcode(cursor.getString(cursor.getColumnIndex(BARCODE_COL)));
                inventoryData.setsBarcode(cursor.getString(cursor.getColumnIndex(S_BARCODE_COL)));
                inventoryData.setUserBarcode(cursor.getString(cursor.getColumnIndex(USER_BARCODE_COL)).trim());
                inventoryData.setStartQty(cursor.getDouble(cursor.getColumnIndex(START_QTY_COL)));
                inventoryData.setScanQty(cursor.getDouble(cursor.getColumnIndex(SCAN_QTY_COL)));
                inventoryData.setScanStartDate(cursor.getString(cursor.getColumnIndex(SCAN_START_DATE_COL)));
                inventoryData.setMrp(cursor.getDouble(cursor.getColumnIndex(MRP_COL)));
                inventoryData.setDescription(cursor.getString(cursor.getColumnIndex(DESCRIPTION_COL)));
                inventoryData.setCpu(cursor.getDouble(cursor.getColumnIndex(CPU_COL)));
                itemList.add(inventoryData);
            }
            cursor.close();
        }


        return itemList;
    }

    public String getTotalScanQty() {
        String totalScan = "";
        SQLiteDatabase readDB = this.getReadableDatabase();
        Cursor cursorTotalScan = readDB.rawQuery("SELECT SUM(" + DBHelper.SCAN_QTY_COL + ") as " + SCAN_QTY_COL + " FROM " + DBHelper.TABLE_SCANITEMS, null);
        if (cursorTotalScan.moveToFirst()) {
            int scanQtyColumnIndex = cursorTotalScan.getColumnIndex(SCAN_QTY_COL);
            if (scanQtyColumnIndex != -1) {
                totalScan = cursorTotalScan.getString(scanQtyColumnIndex);
                Log.e(TAG, "onResponse: Total Scan Qty: " + totalScan);
            } else {
                Log.e(TAG, "Column 'scanQty' not found in the result set.");
            }
        }
        cursorTotalScan.close();
        return totalScan;
    }

    /*public String getItemScanQty(InventoryData.Data i) {
        String totalScan = "";
        SQLiteDatabase readDB = this.getReadableDatabase();

        Cursor cursorTotalScan = readDB.rawQuery(
                "SELECT SUM(" + DBHelper.SCAN_QTY_COL + ") as " + SCAN_QTY_COL + " FROM " + DBHelper.TABLE_INVENTORY +
                        " WHERE " + S_BARCODE_COL + " = ? AND " + SALE_PRICE_COL + " = ?",
                new String[]{i.getsBarcode(), String.valueOf(i.getMrp())}
        );

        if (cursorTotalScan.moveToFirst()) {
            try {
                totalScan = cursorTotalScan.getString(cursorTotalScan.getColumnIndexOrThrow(SCAN_QTY_COL));
                Log.e(TAG, "onResponse: Total Scan Qty for sBarcode: " + i.getsBarcode() + " and salePrice: " + i.getMrp() + ": " + totalScan);
            } catch (IllegalArgumentException e) {
                Log.e(TAG, "Column '" + SCAN_QTY_COL + "' not found in the result set.");
            }
        }

        cursorTotalScan.close();
        readDB.close();
        return totalScan;
    }*/

    public String getTempTotalScanQty() {
        String totalScan = "";
        SQLiteDatabase readDB = this.getReadableDatabase();
        Cursor cursorTotalScan = readDB.rawQuery("SELECT SUM(" + DBHelper.SCAN_QTY_COL + ") as " + SCAN_QTY_COL + " FROM " + DBHelper.TABLE_TEMP_SCANITEMS, null);
        if (cursorTotalScan.moveToFirst()) {
            int scanQtyColumnIndex = cursorTotalScan.getColumnIndex(SCAN_QTY_COL);
            if (scanQtyColumnIndex != -1) {
                totalScan = cursorTotalScan.getString(scanQtyColumnIndex);
                Log.e(TAG, "onResponse: Total Scan Qty: " + totalScan);
            } else {
                Log.e(TAG, "Column 'scanQty' not found in the result set.");
            }
        }
        cursorTotalScan.close();
        return totalScan;
    }

    public String getItemTotalScanQty(String key) {
        String barcode = key.trim();

        String defaultSelectionQry = BARCODE_COL;
        if (pref.isScanBySBarcode()) {
            defaultSelectionQry = S_BARCODE_COL;
        }

        String oldScanQty = "";

        SQLiteDatabase readDB = this.getReadableDatabase();
        String[] columns = {defaultSelectionQry, SCAN_QTY_COL};
        String selection = defaultSelectionQry + " = ?";
        String[] selectionArgs = new String[1];
        selectionArgs[0] = barcode;
        Cursor cursor = readDB.query(TABLE_SCANITEMS, columns, selection, selectionArgs, null, null, null);
        int count = cursor.getCount();

        if (count > 0) {
            if (cursor.moveToFirst()) {
                do {
                    oldScanQty = cursor.getString(1);
                } while (cursor.moveToNext());
            }

            Log.e(TAG, "onResponse: Count Row: " + count);
            Log.e(TAG, "onResponse: Old Scan Quantity: " + oldScanQty);

        } else {
            Log.e(TAG, "onResponse: Count Row: " + count);
            oldScanQty = "00";

        }
        cursor.close();
        readDB.close();
        return oldScanQty;
    }

    //    public boolean addNewItem(ScanItems i) {
//
//        String defaultSelectionQry = BARCODE_COL;
//        if (pref.isScanBySBarcode()) {
//            defaultSelectionQry = S_BARCODE_COL;
//        }
//
//        ContentValues values = getContentValues(i.scanQty, i);
//
//        SQLiteDatabase writeDB = this.getWritableDatabase();
//
//        Cursor cursor = writeDB.rawQuery("SELECT * FROM " + TABLE_TEMP_SCANITEMS + " WHERE " + defaultSelectionQry + " = ?", new String[]{pref.isScanBySBarcode() ? i.sBarcode : i.barcode});
//
//        if (cursor.getCount() > 0) {
//            cursor.moveToFirst();
//            int scanQtyColumnIndex = cursor.getColumnIndex(SCAN_QTY_COL);
//            if (scanQtyColumnIndex != -1) {
//                String oldScanQty = cursor.getString(scanQtyColumnIndex);
//                double newScanQty = Double.parseDouble(oldScanQty) + Double.parseDouble(i.scanQty);
//                String newScanQtyStr = String.valueOf(newScanQty);
//                values.put(SCAN_QTY_COL, newScanQtyStr);
//
//                int rowsDeleted = writeDB.delete(TABLE_TEMP_SCANITEMS, defaultSelectionQry + " = ?", new String[]{pref.isScanBySBarcode() ? i.sBarcode : i.barcode});
//                cursor.close();
//
//                if (rowsDeleted > 0) {
//                    long result = writeDB.insert(TABLE_TEMP_SCANITEMS, null, values);
//                    writeDB.close();
//
//                    if (result != -1) {
//                        Log.e(TAG, "Item exists already, So updated Quantity successfully!");
//                        return true;
//                    } else {
//                        Log.e(TAG, "Item Quantity didn't updated!");
//                        return false;
//                    }
//                } else {
//                    Log.e(TAG, "Failed to delete existing item!");
//                    return false;
//                }
//            } else {
//                Log.e(TAG, "Column '" + SCAN_QTY_COL + "' not found in the result set.");
//                return false; // or handle the error appropriately
//            }
//        } else {
//            long result = writeDB.insert(TABLE_TEMP_SCANITEMS, null, values);
//            writeDB.close();
//
//            if (result != -1) {
//                Log.e(TAG, "New Data inserted successfully!");
//                return true;
//            } else {
//                Log.e(TAG, "Failed to insert new data!");
//                return false;
//            }
//        }
//    }

    public boolean addNewItem(ScanItems i) {
        SQLiteDatabase writeDB = this.getWritableDatabase();
        ContentValues values = getContentValues(i.scanQty, i);

        Cursor cursor = writeDB.rawQuery(
                "SELECT * FROM " + TABLE_TEMP_SCANITEMS + " WHERE " + S_BARCODE_COL + " = ? AND " + SALE_PRICE_COL + " = ?",
                new String[]{i.sBarcode, i.salePrice}
        );

        if (cursor.getCount() > 0) {
            cursor.moveToFirst();
            try {
                String oldScanQty = cursor.getString(cursor.getColumnIndexOrThrow(SCAN_QTY_COL));
                double newScanQty = Double.parseDouble(oldScanQty) + Double.parseDouble(i.scanQty);
                String newScanQtyStr = String.valueOf(newScanQty);
                values.put(SCAN_QTY_COL, newScanQtyStr);

                int rowsDeleted = writeDB.delete(
                        TABLE_TEMP_SCANITEMS,
                        S_BARCODE_COL + " = ? AND " + SALE_PRICE_COL + " = ?",
                        new String[]{i.sBarcode, i.salePrice}
                );
                cursor.close();

                if (rowsDeleted > 0) {
                    long result = writeDB.insert(TABLE_TEMP_SCANITEMS, null, values);
                    writeDB.close();

                    if (result != -1) {
                        Log.e(TAG, "Item exists already, So updated Quantity successfully for sBarcode: " + i.sBarcode + " and salePrice: " + i.salePrice);
                        return true;
                    } else {
                        Log.e(TAG, "Item Quantity didn't updated for sBarcode: " + i.sBarcode + " and salePrice: " + i.salePrice);
                        return false;
                    }
                } else {
                    Log.e(TAG, "Failed to delete existing item for sBarcode: " + i.sBarcode + " and salePrice: " + i.salePrice);
                    cursor.close();
                    writeDB.close();
                    return false;
                }
            } catch (IllegalArgumentException e) {
                Log.e(TAG, "Column '" + SCAN_QTY_COL + "' not found in the result set.");
                cursor.close();
                writeDB.close();
                return false;
            }
        } else {
            cursor.close();
            long result = writeDB.insert(TABLE_TEMP_SCANITEMS, null, values);
            writeDB.close();

            if (result != -1) {
                Log.e(TAG, "New Data inserted successfully for sBarcode: " + i.sBarcode + " and salePrice: " + i.salePrice);
                return true;
            } else {
                Log.e(TAG, "Failed to insert new data for sBarcode: " + i.sBarcode + " and salePrice: " + i.salePrice);
                return false;
            }
        }
    }

    public long addScanItemsFromExcel(ScanItems i) {

        ContentValues values = new ContentValues();

        values.put(ITEM_CODE_COL, i.itemCode);
        values.put(BARCODE_COL, i.barcode);
        values.put(USER_BARCODE_COL, i.userBarcode.trim());
        values.put(S_BARCODE_COL, i.sBarcode);
        values.put(ITEM_DESCRIPTION_COL, i.itemDescription);
        values.put(SCAN_QTY_COL, i.scanQty);
        values.put(ADJ_QTY_COL, i.adjQty);
        values.put(USER_ID_COL, i.userId);
        values.put(DEVICE_ID_COL, i.deviceId);
        values.put(ZONE_NAME_COL, i.zoneName);
        values.put(SC_QTY_COL, i.scQty);
        values.put(SR_QTY_COL, i.srQty);
        values.put(EN_QTY_COL, i.enQty);
        values.put(CREATE_DATE_COL, i.createDate);
        values.put(SYSTEM_QTY_COL, i.systemQty);
        values.put(S_QTY_COL, i.sQty);
        values.put(OUTLET_CODE_COL, i.outletCode);
        values.put(SALE_PRICE_COL, i.salePrice);
        values.put(CPU_COL, i.cpu);
        values.put(SESSION_ID_COL, i.sessionId);

        SQLiteDatabase database = getReadableDatabase();

        long result = database.insert(TABLE_TEMP_SCANITEMS, null, values);


        if (result != -1) {
            Log.e(TAG, "Data saved successfully!");
        } else {
            Log.e(TAG, "Failed to save data!");
        }
        return result;

    }

    public ScanItems searchScanItems(String key) {
        SQLiteDatabase db = this.getReadableDatabase();
        String searchKey = key.trim();

        String selection = BARCODE_COL + " = ? OR " + USER_BARCODE_COL + " = ? OR " + S_BARCODE_COL + " = ?";
        String[] selectionArgs = {searchKey, searchKey, searchKey};

        String[] projection = {
                ITEM_CODE_COL,
                BARCODE_COL,
                USER_BARCODE_COL,
                S_BARCODE_COL,
                ITEM_DESCRIPTION_COL,
                SCAN_QTY_COL,
                ADJ_QTY_COL,
                USER_ID_COL,
                DEVICE_ID_COL,
                ZONE_NAME_COL,
                SC_QTY_COL,
                SR_QTY_COL,
                EN_QTY_COL,
                CREATE_DATE_COL,
                SYSTEM_QTY_COL,
                S_QTY_COL,
                OUTLET_CODE_COL,
                SALE_PRICE_COL,
                CPU_COL,
                SESSION_ID_COL
        };

        Cursor cursor = db.query(
                TABLE_SCANITEMS,            // The table to query
                projection,            // The array of columns to return (null to return all)
                selection,             // The columns for the WHERE clause
                selectionArgs,         // The values for the WHERE clause
                null,                  // Don't group the rows
                null,                  // Don't filter by row groups
                null                   // The sort order
        );

        ScanItems searchItems = null;

        if (cursor != null && cursor.moveToFirst()) {
            searchItems = new ScanItems(
                    cursor.getString(0),
                    cursor.getString(1),
                    cursor.getString(2),
                    cursor.getString(3),
                    cursor.getString(4),
                    cursor.getString(5),
                    cursor.getString(6),
                    cursor.getString(7),
                    cursor.getString(8),
                    cursor.getString(9),
                    cursor.getString(10),
                    cursor.getString(11),
                    cursor.getString(12),
                    cursor.getString(13),
                    cursor.getString(14),
                    cursor.getString(15),
                    cursor.getString(16),
                    cursor.getString(17),
                    cursor.getString(18),
                    cursor.getString(19)
            );
            cursor.close();
        }

        return searchItems;
    }

    public ScanItems getSingleScanItem(String sBarcode, String salePrice) {
        SQLiteDatabase db = this.getReadableDatabase();

        String selection = S_BARCODE_COL + " = ? AND " + SALE_PRICE_COL + " = ?";
        String[] selectionArgs = {sBarcode.trim(), salePrice};

        String[] projection = {
                ITEM_CODE_COL,
                BARCODE_COL,
                USER_BARCODE_COL,
                S_BARCODE_COL,
                ITEM_DESCRIPTION_COL,
                SCAN_QTY_COL,
                ADJ_QTY_COL,
                USER_ID_COL,
                DEVICE_ID_COL,
                ZONE_NAME_COL,
                SC_QTY_COL,
                SR_QTY_COL,
                EN_QTY_COL,
                CREATE_DATE_COL,
                SYSTEM_QTY_COL,
                S_QTY_COL,
                OUTLET_CODE_COL,
                SALE_PRICE_COL,
                CPU_COL,
                SESSION_ID_COL
        };

        ScanItems searchItems = null;

        Cursor cursor = db.query(
                TABLE_SCANITEMS,            // The table to query
                projection,            // The array of columns to return
                selection,             // The columns for the WHERE clause
                selectionArgs,         // The values for the WHERE clause
                null,                  // Don't group the rows
                null,                  // Don't filter by row groups
                null                   // The sort order
        );

        if (cursor != null && cursor.moveToFirst()) {
            searchItems = new ScanItems(
                    cursor.getString(cursor.getColumnIndexOrThrow(ITEM_CODE_COL)),
                    cursor.getString(cursor.getColumnIndexOrThrow(BARCODE_COL)),
                    cursor.getString(cursor.getColumnIndexOrThrow(USER_BARCODE_COL)),
                    cursor.getString(cursor.getColumnIndexOrThrow(S_BARCODE_COL)),
                    cursor.getString(cursor.getColumnIndexOrThrow(ITEM_DESCRIPTION_COL)),
                    cursor.getString(cursor.getColumnIndexOrThrow(SCAN_QTY_COL)),
                    cursor.getString(cursor.getColumnIndexOrThrow(ADJ_QTY_COL)),
                    cursor.getString(cursor.getColumnIndexOrThrow(USER_ID_COL)),
                    cursor.getString(cursor.getColumnIndexOrThrow(DEVICE_ID_COL)),
                    cursor.getString(cursor.getColumnIndexOrThrow(ZONE_NAME_COL)),
                    cursor.getString(cursor.getColumnIndexOrThrow(SC_QTY_COL)),
                    cursor.getString(cursor.getColumnIndexOrThrow(SR_QTY_COL)),
                    cursor.getString(cursor.getColumnIndexOrThrow(EN_QTY_COL)),
                    cursor.getString(cursor.getColumnIndexOrThrow(CREATE_DATE_COL)),
                    cursor.getString(cursor.getColumnIndexOrThrow(SYSTEM_QTY_COL)),
                    cursor.getString(cursor.getColumnIndexOrThrow(S_QTY_COL)),
                    cursor.getString(cursor.getColumnIndexOrThrow(OUTLET_CODE_COL)),
                    cursor.getString(cursor.getColumnIndexOrThrow(SALE_PRICE_COL)),
                    cursor.getString(cursor.getColumnIndexOrThrow(CPU_COL)),
                    cursor.getString(cursor.getColumnIndexOrThrow(SESSION_ID_COL))
            );
        }

        if (cursor != null) {
            cursor.close();
        }
        db.close();

        return searchItems;
    }

    /*public ScanItems searchTempScanItems(String key) {
        String searchKey = key.trim();

        String defaultSelectionQry = BARCODE_COL;
        if (pref.isScanBySBarcode()) {
            defaultSelectionQry = S_BARCODE_COL;
        }

        SQLiteDatabase db = this.getReadableDatabase();

        String[] projection = {
                ITEM_CODE_COL,
                BARCODE_COL,
                USER_BARCODE_COL,
                S_BARCODE_COL,
                ITEM_DESCRIPTION_COL,
                SCAN_QTY_COL,
                ADJ_QTY_COL,
                USER_ID_COL,
                DEVICE_ID_COL,
                ZONE_NAME_COL,
                SC_QTY_COL,
                SR_QTY_COL,
                EN_QTY_COL,
                CREATE_DATE_COL,
                SYSTEM_QTY_COL,
                S_QTY_COL,
                OUTLET_CODE_COL,
                SALE_PRICE_COL,
                CPU_COL,
                SESSION_ID_COL
        };

        String selection = defaultSelectionQry + " = ?";
        String[] selectionArgs = {searchKey};

        Cursor cursor = db.query(
                TABLE_TEMP_SCANITEMS,            // The table to query
                projection,            // The array of columns to return (null to return all)
                selection,             // The columns for the WHERE clause
                selectionArgs,         // The values for the WHERE clause
                null,                  // Don't group the rows
                null,                  // Don't filter by row groups
                null                   // The sort order
        );

        ScanItems searchItems = null;

        if (cursor != null && cursor.moveToFirst()) {
            searchItems = new ScanItems(
                    cursor.getString(0),
                    cursor.getString(1),
                    cursor.getString(2),
                    cursor.getString(3),
                    cursor.getString(4),
                    cursor.getString(5),
                    cursor.getString(6),
                    cursor.getString(7),
                    cursor.getString(8),
                    cursor.getString(9),
                    cursor.getString(10),
                    cursor.getString(11),
                    cursor.getString(12),
                    cursor.getString(13),
                    cursor.getString(14),
                    cursor.getString(15),
                    cursor.getString(16),
                    cursor.getString(17),
                    cursor.getString(18),
                    cursor.getString(19)
            );
            cursor.close();
        }

        return searchItems;
    }*/

    public ScanItems searchTempScanItems(String key) {
        String searchKey = key.trim();
        SQLiteDatabase db = this.getReadableDatabase();

        String[] projection = {
                ITEM_CODE_COL,
                BARCODE_COL,
                USER_BARCODE_COL,
                S_BARCODE_COL,
                ITEM_DESCRIPTION_COL,
                SCAN_QTY_COL,
                ADJ_QTY_COL,
                USER_ID_COL,
                DEVICE_ID_COL,
                ZONE_NAME_COL,
                SC_QTY_COL,
                SR_QTY_COL,
                EN_QTY_COL,
                CREATE_DATE_COL,
                SYSTEM_QTY_COL,
                S_QTY_COL,
                OUTLET_CODE_COL,
                SALE_PRICE_COL,
                CPU_COL,
                SESSION_ID_COL
        };

        String selection = BARCODE_COL + " = ? OR " +
                S_BARCODE_COL + " = ? OR " +
                USER_BARCODE_COL + " = ? OR " +
                ITEM_DESCRIPTION_COL + " = ?";
        String[] selectionArgs = {searchKey, searchKey, searchKey, searchKey};

        Cursor cursor = db.query(
                TABLE_TEMP_SCANITEMS,  // The table to query
                projection,           // The array of columns to return
                selection,            // The columns for the WHERE clause
                selectionArgs,        // The values for the WHERE clause
                null,                 // Don't group the rows
                null,                 // Don't filter by row groups
                null                  // The sort order
        );

        ScanItems searchItems = null;

        if (cursor != null && cursor.moveToFirst()) {
            searchItems = new ScanItems(
                    cursor.getString(0),
                    cursor.getString(1),
                    cursor.getString(2),
                    cursor.getString(3),
                    cursor.getString(4),
                    cursor.getString(5),
                    cursor.getString(6),
                    cursor.getString(7),
                    cursor.getString(8),
                    cursor.getString(9),
                    cursor.getString(10),
                    cursor.getString(11),
                    cursor.getString(12),
                    cursor.getString(13),
                    cursor.getString(14),
                    cursor.getString(15),
                    cursor.getString(16),
                    cursor.getString(17),
                    cursor.getString(18),
                    cursor.getString(19)
            );
            cursor.close();
        }

        return searchItems;
    }

    public ArrayList<ScanItems> readScanItems() {

        SQLiteDatabase db = this.getReadableDatabase();

        Cursor cursorScanItem = db.rawQuery("SELECT * FROM " + TABLE_SCANITEMS + " ORDER BY ROWID DESC", null);

        ArrayList<ScanItems> scanItemsArrayList = new ArrayList<>();

        if (cursorScanItem.moveToFirst()) {
            do {
                scanItemsArrayList.add(new ScanItems(
                        cursorScanItem.getString(1),
                        cursorScanItem.getString(2),
                        cursorScanItem.getString(3),
                        cursorScanItem.getString(4),
                        cursorScanItem.getString(5),
                        cursorScanItem.getString(6),
                        cursorScanItem.getString(7),
                        cursorScanItem.getString(8),
                        cursorScanItem.getString(9),
                        cursorScanItem.getString(10),
                        cursorScanItem.getString(11),
                        cursorScanItem.getString(12),
                        cursorScanItem.getString(13),
                        cursorScanItem.getString(14),
                        cursorScanItem.getString(15),
                        cursorScanItem.getString(16),
                        cursorScanItem.getString(17),
                        cursorScanItem.getString(18),
                        cursorScanItem.getString(19),
                        cursorScanItem.getString(20)
                ));
            } while (cursorScanItem.moveToNext());
        }
        Log.e(TAG, String.valueOf(scanItemsArrayList.size()));
        cursorScanItem.close();
        return scanItemsArrayList;
    }

    public ArrayList<ScanItems> readTempScanItems() {

        SQLiteDatabase db = this.getReadableDatabase();

        Cursor cursorScanItem = db.rawQuery("SELECT * FROM " + TABLE_TEMP_SCANITEMS + " ORDER BY ROWID DESC", null);

        ArrayList<ScanItems> scanItemsArrayList = new ArrayList<>();

        if (cursorScanItem.moveToFirst()) {
            do {
                scanItemsArrayList.add(new ScanItems(
                        cursorScanItem.getString(1),
                        cursorScanItem.getString(2),
                        cursorScanItem.getString(3),
                        cursorScanItem.getString(4),
                        cursorScanItem.getString(5),
                        cursorScanItem.getString(6),
                        cursorScanItem.getString(7),
                        cursorScanItem.getString(8),
                        cursorScanItem.getString(9),
                        cursorScanItem.getString(10),
                        cursorScanItem.getString(11),
                        cursorScanItem.getString(12),
                        cursorScanItem.getString(13),
                        cursorScanItem.getString(14),
                        cursorScanItem.getString(15),
                        cursorScanItem.getString(16),
                        cursorScanItem.getString(17),
                        cursorScanItem.getString(18),
                        cursorScanItem.getString(19),
                        cursorScanItem.getString(20)
                ));
            } while (cursorScanItem.moveToNext());
        }
        Log.e(TAG, String.valueOf(scanItemsArrayList.size()));
        cursorScanItem.close();
        return scanItemsArrayList;
    }

    /*public void updateScanItem(String key, String scanQty) {
        String searchKey = key.trim();

        String defaultSelectionQry = BARCODE_COL;
        if (pref.isScanBySBarcode()) {
            defaultSelectionQry = S_BARCODE_COL;
        }

        SQLiteDatabase db = this.getWritableDatabase();
        ScanItems scanItems = searchScanItems(searchKey);

        ContentValues values = getContentValues(scanQty, scanItems);

        // Deleting item with old scan qty
        int rowsDeleted = db.delete(TABLE_SCANITEMS, defaultSelectionQry + " = ?", new String[]{searchKey});

        // Adding item with the new qty
        if (rowsDeleted > 0) {
            long result = db.insert(TABLE_SCANITEMS, null, values);

            if (result != -1) {
                Log.e(TAG, "Item Quantity updated successfully!!");
            } else {
                Log.e(TAG, "Item Quantity didn't updated !");
            }
        } else {
            Log.e(TAG, "Failed to Found item to update!");
        }
        db.close();
    }*/

    public boolean adjustScanItem(ScanItems item) {
        SQLiteDatabase db = this.getWritableDatabase();

        // Search for existing item by sBarcode and mrp
        Cursor cursor = db.rawQuery(
                "SELECT * FROM " + TABLE_SCANITEMS + " WHERE " + S_BARCODE_COL + " = ? AND " + SALE_PRICE_COL + " = ?",
                new String[]{item.sBarcode, item.salePrice}
        );

        if (cursor.moveToFirst()) {
            try {
                ContentValues values = new ContentValues();
                values.put(SCAN_QTY_COL, item.scanQty);
                values.put(ADJ_QTY_COL, item.adjQty);

                // Update the record
                int rowsUpdated = db.update(
                        TABLE_SCANITEMS,
                        values,
                        S_BARCODE_COL + " = ? AND " + SALE_PRICE_COL + " = ?",
                        new String[]{item.sBarcode, item.salePrice}
                );

                cursor.close();
                db.close();

                if (rowsUpdated > 0) {
                    Log.e(TAG, "Scan item adjusted successfully for sBarcode: " + item.sBarcode + " and mrp: " + item.salePrice);
                    return true;
                } else {
                    Log.e(TAG, "Failed to update scan item for sBarcode: " + item.sBarcode + " and mrp: " + item.salePrice);
                    return false;
                }
            } catch (IllegalArgumentException e) {
                Log.e(TAG, "Column '" + SCAN_QTY_COL + "' or '" + ADJ_QTY_COL + "' not found in the result set.");
                cursor.close();
                db.close();
                return false;
            }
        } else {
            Log.e(TAG, "No item found to adjust for sBarcode: " + item.sBarcode + " and mrp: " + item.salePrice);
            cursor.close();
            db.close();
            return false;
        }
    }

    public void updateScanItem(ScanItems scanItems, String scanQty) {
        SQLiteDatabase db = this.getWritableDatabase();

        ContentValues values = getContentValues(scanQty, scanItems);

        String sBarcode = scanItems.sBarcode;
        String mrp = scanItems.salePrice;

        // Deleting item with old scan qty
        int rowsDeleted = db.delete(
                TABLE_SCANITEMS,
                S_BARCODE_COL + " = ? AND " + SALE_PRICE_COL + " = ?",
                new String[]{sBarcode, mrp}
        );

        // Adding item with the new qty
        if (rowsDeleted > 0) {
            long result = db.insert(TABLE_SCANITEMS, null, values);

            if (result != -1) {
                Log.e(TAG, "Item Quantity updated successfully for sBarcode: " + sBarcode + " and mrp: " + mrp);
            } else {
                Log.e(TAG, "Item Quantity didn't updated for sBarcode: " + sBarcode + " and mrp: " + mrp);
            }
        } else {
            Log.e(TAG, "Failed to find item to update for sBarcode: " + sBarcode + " and mrp: " + mrp);
        }
        db.close();
    }

    public void updateTempScanItem(ScanItems scanItems, String scanQty) {
        SQLiteDatabase db = this.getWritableDatabase();

        ContentValues values = getContentValues(scanQty, scanItems);

        String sBarcode = scanItems.sBarcode;
        String mrp = scanItems.salePrice;

        // Deleting item with old scan qty
        int rowsDeleted = db.delete(
                TABLE_TEMP_SCANITEMS,
                S_BARCODE_COL + " = ? AND " + SALE_PRICE_COL + " = ?",
                new String[]{sBarcode, mrp}
        );

        // Adding item with the new qty
        if (rowsDeleted > 0) {
            long result = db.insert(TABLE_TEMP_SCANITEMS, null, values);

            if (result != -1) {
                Log.e(TAG, "Temp Item Quantity updated for sBarcode: " + sBarcode + " and mrp: " + mrp);
            } else {
                Log.e(TAG, "Temp Item Quantity didn't updated for sBarcode: " + sBarcode + " and mrp: " + mrp);
            }
        } else {
            Log.e(TAG, "Failed to find Temp item to update for sBarcode: " + sBarcode + " and mrp: " + mrp);
        }
        db.close();
    }

    private static @NonNull ContentValues getContentValues(String scanQty, ScanItems scanItems) {
        ContentValues values = new ContentValues();
        values.put(ITEM_CODE_COL, scanItems.itemCode);
        values.put(BARCODE_COL, scanItems.barcode);
        values.put(USER_BARCODE_COL, scanItems.userBarcode.trim());
        values.put(S_BARCODE_COL, scanItems.sBarcode);
        values.put(ITEM_DESCRIPTION_COL, scanItems.itemDescription);
        values.put(SCAN_QTY_COL, scanQty); // Updating new qty
        values.put(ADJ_QTY_COL, scanItems.adjQty);
        values.put(USER_ID_COL, scanItems.userId);
        values.put(DEVICE_ID_COL, scanItems.deviceId);
        values.put(ZONE_NAME_COL, scanItems.zoneName);
        values.put(SC_QTY_COL, scanItems.scQty);
        values.put(SR_QTY_COL, scanItems.srQty);
        values.put(EN_QTY_COL, scanItems.enQty);
        values.put(CREATE_DATE_COL, scanItems.createDate);
        values.put(SYSTEM_QTY_COL, scanItems.systemQty);
        values.put(S_QTY_COL, scanItems.sQty);
        values.put(OUTLET_CODE_COL, scanItems.outletCode);
        values.put(SALE_PRICE_COL, scanItems.salePrice);
        values.put(CPU_COL, scanItems.cpu);
        values.put(SESSION_ID_COL, scanItems.sessionId);
        return values;
    }

    public void saveTempScanItemsToLocal() {
        SQLiteDatabase database = getWritableDatabase();
        String selectQuery = "SELECT * FROM " + TABLE_TEMP_SCANITEMS;
        Cursor cursor = database.rawQuery(selectQuery, null);

        if (cursor.moveToFirst()) {
            do {
                String sBarcode = cursor.getString(cursor.getColumnIndexOrThrow(S_BARCODE_COL));
                String salePrice = cursor.getString(cursor.getColumnIndexOrThrow(SALE_PRICE_COL));
                double scanQty = cursor.getDouble(cursor.getColumnIndexOrThrow(SCAN_QTY_COL));
                ContentValues values = new ContentValues();

                // Check if the sBarcode and salePrice exist in TABLE_SCANITEMS
                String checkQuery = "SELECT * FROM " + TABLE_SCANITEMS + " WHERE " + S_BARCODE_COL + " = ? AND " + SALE_PRICE_COL + " = ?";
                Cursor checkCursor = database.rawQuery(checkQuery, new String[]{sBarcode, salePrice});

                if (checkCursor.moveToFirst()) {
                    // Item exists, update the scanQty
                    double currentScanQty = checkCursor.getDouble(checkCursor.getColumnIndexOrThrow(SCAN_QTY_COL));
                    double newScanQty = currentScanQty + scanQty;
                    values.put(SCAN_QTY_COL, newScanQty);

                    database.update(
                            TABLE_SCANITEMS,
                            values,
                            S_BARCODE_COL + " = ? AND " + SALE_PRICE_COL + " = ?",
                            new String[]{sBarcode, salePrice}
                    );
                } else {
                    // Item does not exist, insert a new row
                    values.put(ITEM_CODE_COL, cursor.getString(cursor.getColumnIndexOrThrow(ITEM_CODE_COL)));
                    values.put(BARCODE_COL, cursor.getString(cursor.getColumnIndexOrThrow(BARCODE_COL)));
                    values.put(USER_BARCODE_COL, cursor.getString(cursor.getColumnIndexOrThrow(USER_BARCODE_COL)));
                    values.put(S_BARCODE_COL, sBarcode);
                    values.put(ITEM_DESCRIPTION_COL, cursor.getString(cursor.getColumnIndexOrThrow(ITEM_DESCRIPTION_COL)));
                    values.put(SCAN_QTY_COL, scanQty);
                    values.put(ADJ_QTY_COL, cursor.getString(cursor.getColumnIndexOrThrow(ADJ_QTY_COL)));
                    values.put(USER_ID_COL, cursor.getString(cursor.getColumnIndexOrThrow(USER_ID_COL)));
                    values.put(DEVICE_ID_COL, cursor.getString(cursor.getColumnIndexOrThrow(DEVICE_ID_COL)));
                    values.put(ZONE_NAME_COL, cursor.getString(cursor.getColumnIndexOrThrow(ZONE_NAME_COL)));
                    values.put(SC_QTY_COL, cursor.getString(cursor.getColumnIndexOrThrow(SC_QTY_COL)));
                    values.put(SR_QTY_COL, cursor.getString(cursor.getColumnIndexOrThrow(SR_QTY_COL)));
                    values.put(EN_QTY_COL, cursor.getString(cursor.getColumnIndexOrThrow(EN_QTY_COL)));
                    values.put(CREATE_DATE_COL, cursor.getString(cursor.getColumnIndexOrThrow(CREATE_DATE_COL)));
                    values.put(SYSTEM_QTY_COL, cursor.getString(cursor.getColumnIndexOrThrow(SYSTEM_QTY_COL)));
                    values.put(S_QTY_COL, cursor.getString(cursor.getColumnIndexOrThrow(S_QTY_COL)));
                    values.put(OUTLET_CODE_COL, cursor.getString(cursor.getColumnIndexOrThrow(OUTLET_CODE_COL)));
                    values.put(SALE_PRICE_COL, salePrice);
                    values.put(CPU_COL, cursor.getString(cursor.getColumnIndexOrThrow(CPU_COL)));
                    values.put(SESSION_ID_COL, cursor.getString(cursor.getColumnIndexOrThrow(SESSION_ID_COL)));

                    database.insert(TABLE_SCANITEMS, null, values);
                }

                checkCursor.close();
            } while (cursor.moveToNext());
        }

        cursor.close();

        // Delete all data from TABLE_TEMP_SCANITEMS after saving to TABLE_SCANITEMS
        database.execSQL("DELETE FROM " + TABLE_TEMP_SCANITEMS);
        database.close();
    }

    //    public void saveTempScanItemsToLocal() {
//         SQLiteDatabase database = getReadableDatabase();
//        String selectQuery = "SELECT * FROM " + TABLE_TEMP_SCANITEMS;
//        Cursor cursor = database.rawQuery(selectQuery, null);
//
//        if (cursor.moveToFirst()) {
//            do {
//                String barcode = cursor.getString(cursor.getColumnIndexOrThrow(BARCODE_COL));
//                double scanQty = cursor.getDouble(cursor.getColumnIndexOrThrow(SCAN_QTY_COL));
//                ContentValues values = new ContentValues();
//
//                // Check if the barcode exists in TABLE_SCANITEMS
//                String checkQuery = "SELECT * FROM " + TABLE_SCANITEMS + " WHERE " + BARCODE_COL + " = ?";
//                Cursor checkCursor = database.rawQuery(checkQuery, new String[]{barcode});
//
//                if (checkCursor.moveToFirst()) {
//                    // Barcode exists, update the scanQty
//                    double currentScanQty = checkCursor.getDouble(checkCursor.getColumnIndexOrThrow(SCAN_QTY_COL));
//                    double newScanQty = currentScanQty + scanQty;
//                    values.put(SCAN_QTY_COL, newScanQty);
//
//                    database.update(TABLE_SCANITEMS, values, BARCODE_COL + " = ?", new String[]{barcode});
//                } else {
//                    // Barcode does not exist, insert a new row
//                    values.put(ITEM_CODE_COL, cursor.getString(cursor.getColumnIndexOrThrow(ITEM_CODE_COL)));
//                    values.put(BARCODE_COL, barcode);
//                    values.put(USER_BARCODE_COL, cursor.getString(cursor.getColumnIndexOrThrow(USER_BARCODE_COL)));
//                    values.put(S_BARCODE_COL, cursor.getString(cursor.getColumnIndexOrThrow(S_BARCODE_COL)));
//                    values.put(ITEM_DESCRIPTION_COL, cursor.getString(cursor.getColumnIndexOrThrow(ITEM_DESCRIPTION_COL)));
//                    values.put(SCAN_QTY_COL, scanQty); // Updating new qty
//                    values.put(ADJ_QTY_COL, cursor.getString(cursor.getColumnIndexOrThrow(ADJ_QTY_COL)));
//                    values.put(USER_ID_COL, cursor.getString(cursor.getColumnIndexOrThrow(USER_ID_COL)));
//                    values.put(DEVICE_ID_COL, cursor.getString(cursor.getColumnIndexOrThrow(DEVICE_ID_COL)));
//                    values.put(ZONE_NAME_COL, cursor.getString(cursor.getColumnIndexOrThrow(ZONE_NAME_COL)));
//                    values.put(SC_QTY_COL, cursor.getString(cursor.getColumnIndexOrThrow(SC_QTY_COL)));
//                    values.put(SR_QTY_COL, cursor.getString(cursor.getColumnIndexOrThrow(SR_QTY_COL)));
//                    values.put(EN_QTY_COL, cursor.getString(cursor.getColumnIndexOrThrow(EN_QTY_COL)));
//                    values.put(CREATE_DATE_COL, cursor.getString(cursor.getColumnIndexOrThrow(CREATE_DATE_COL)));
//                    values.put(SYSTEM_QTY_COL, cursor.getString(cursor.getColumnIndexOrThrow(SYSTEM_QTY_COL)));
//                    values.put(S_QTY_COL, cursor.getString(cursor.getColumnIndexOrThrow(S_QTY_COL)));
//                    values.put(OUTLET_CODE_COL, cursor.getString(cursor.getColumnIndexOrThrow(OUTLET_CODE_COL)));
//                    values.put(SALE_PRICE_COL, cursor.getString(cursor.getColumnIndexOrThrow(SALE_PRICE_COL)));
//                    values.put(CPU_COL, cursor.getString(cursor.getColumnIndexOrThrow(CPU_COL)));
//                    values.put(SESSION_ID_COL, cursor.getString(cursor.getColumnIndexOrThrow(SESSION_ID_COL)));
//
//                    database.insert(TABLE_SCANITEMS, null, values);
//                }
//
//                checkCursor.close();
//            } while (cursor.moveToNext());
//        }
//
//        cursor.close();
//
//        // Delete all data from TABLE_TEMP_SCANITEMS after saving to TABLE_SCANITEMS
//        database.execSQL("DELETE FROM " + TABLE_TEMP_SCANITEMS);
//    }

    /*public void deleteScanItems(List<SaveInventory> items) {
        String defaultSelectionQry = BARCODE_COL;
        if (pref.isScanBySBarcode()) {
            defaultSelectionQry = S_BARCODE_COL;
        }
        SQLiteDatabase database = getReadableDatabase();
        for (SaveInventory item : items) {
            database.delete(TABLE_SCANITEMS, defaultSelectionQry + " = ?", new String[]{pref.isScanBySBarcode() ? item.sBarcode : item.barcode});
        }

    }*/

    public void deleteScanItems(List<SaveInventory> items) {
        SQLiteDatabase database = getReadableDatabase();
        for (SaveInventory item : items) {
            database.delete(TABLE_SCANITEMS,
                    S_BARCODE_COL + " = ? AND " + SALE_PRICE_COL + " = ?",
                    new String[]{item.sBarcode, String.valueOf(item.salePrice)});
        }
    }

    public void deleteScannedData() {
        SQLiteDatabase database = getReadableDatabase();

        long result = database.delete(TABLE_SCANITEMS, null, null);


        if (result > 0) {
            Log.e(TAG, "Scanned Items: Data delete successfully!");
        } else {
            Log.e(TAG, "Scanned Items: Data delete failed!");
        }
    }

    public boolean hasTempScanItems() {
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor cursor = db.rawQuery("SELECT COUNT(*) FROM " + TABLE_TEMP_SCANITEMS, null);
        boolean hasItems = false;
        if (cursor.moveToFirst()) {
            hasItems = cursor.getInt(0) > 0;
        }
        cursor.close();
        return hasItems;
    }

    public void deleteTempScannedData() {
        SQLiteDatabase database = getReadableDatabase();

        long result = database.delete(TABLE_TEMP_SCANITEMS, null, null);


        if (result > 0) {
            Log.e(TAG, "onResponse: Data delete successfully!");
        } else {
            Log.e(TAG, "onResponse: Data delete failed!");
        }
    }

    public void deleteInventoryData() {
        SQLiteDatabase db = getReadableDatabase();
        db.beginTransaction();
        try {
            db.delete(TABLE_INVENTORY, null, null);
            Log.e(TAG, "on InventoryData : Data delete successfully!");

            db.setTransactionSuccessful();
        } catch (Exception e) {
            Log.d(TAG, "Error saving saved sessions: " + e);
        } finally {
            db.endTransaction();
        }

        /*if (result > 0) {
            Log.e(TAG, "on InventoryData : Data delete successfully!");
        } else {
            Log.e(TAG, "on InventoryData : Data delete failed!");
        }*/
    }

    public boolean deleteSingleData(ScanItems scanItem) {

        SQLiteDatabase db = this.getWritableDatabase();

        long result = db.delete(
                TABLE_SCANITEMS,
                S_BARCODE_COL + " = ? AND " + SALE_PRICE_COL + " = ?",
                new String[]{scanItem.sBarcode, scanItem.salePrice}
        );
        db.close();

        if (result > 0) {
            Log.e(TAG, "onResponse: Item delete successfully!");
            return true;
        } else {
            Log.e(TAG, "onResponse: Item delete failed!");
            return false;
        }
    }

    public boolean deleteTempSingleData(ScanItems scanItem) {
        SQLiteDatabase db = this.getWritableDatabase();

        long result = db.delete(
                TABLE_TEMP_SCANITEMS,
                S_BARCODE_COL + " = ? AND " + SALE_PRICE_COL + " = ?",
                new String[]{scanItem.sBarcode, scanItem.salePrice}
        );
        db.close();

        if (result > 0) {
            Log.e(TAG, "onResponse: Item delete successfully!");
            return true;
        } else {
            Log.e(TAG, "onResponse: Item delete failed!");
            return false;
        }
    }
}