package com.ms.inventory.activity;

import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.ms.inventory.R;
import com.ms.inventory.adapter.ScanTempRVAdapter;
import com.ms.inventory.model.ScanItems;
import com.ms.inventory.utils.DBHelper;

import java.util.ArrayList;

public class ViewTempScanItems extends AppCompatActivity {

    @SuppressLint("StaticFieldLeak")
    private static ViewTempScanItems instance;

    private ArrayList<ScanItems> scanItemsArrayList;
    private DBHelper DB;
    private RecyclerView scanItemsRV;
    private EditText edtSearch;
    Button btnDeleteTemp;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_view_temp_scan_items);

        instance = this;

        DB = new DBHelper(this);
        scanItemsArrayList = new ArrayList<>();
        scanItemsRV = findViewById(R.id.idRVTempScanItems);
        edtSearch = findViewById(R.id.edt_search);
        Button btnSearch = findViewById(R.id.btn_search);
        btnDeleteTemp = findViewById(R.id.btn_temp_delete);

        // Text change listener to the barcode EditText
        edtSearch.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                searchItem(s.toString());
            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });

        btnDeleteTemp.setOnClickListener(v -> deleteConfirmationDialog());

        btnSearch.setOnClickListener(v -> {
            String query = edtSearch.getText().toString().toUpperCase().trim();
            searchItem(query);
        });

        loadScanItems();
    }

    public static ViewTempScanItems getInstance() {
        return instance;
    }

    public void loadScanItems() {
        scanItemsArrayList = DB.readTempScanItems();
        refreshRecyclerView();
        if (scanItemsArrayList.isEmpty()) {
            btnDeleteTemp.setVisibility(View.GONE);
        } else {
            btnDeleteTemp.setVisibility(View.VISIBLE);
        }
    }

    public void searchItem(String query) {
        // If the query is empty, reload all items
        if (query.isEmpty()) {
            loadScanItems();
        } else {
            // Otherwise, search the item based on barcode
            ScanItems searchedItem = DB.searchTempScanItems(query.toUpperCase().trim());
            if (searchedItem != null) {
                scanItemsArrayList.clear();
                scanItemsArrayList.add(searchedItem);
                refreshRecyclerView();
            }
        }
    }

    private void deleteConfirmationDialog() {
        AlertDialog.Builder d = new AlertDialog.Builder(this);
        d.setTitle("Confirmation");
        d.setMessage("Do you want to Delete All Items");
        d.setNegativeButton("No", (dialog, which) -> dialog.dismiss());

        d.setPositiveButton("Yes", (dialog, which) -> {
            DB.deleteTempScannedData();
            loadScanItems();
            dialog.dismiss();
        });
        d.create().show();
    }

    //    public void updateScanItem(String barcode, String newQuantity) {
//        for (ScanItems item : scanItemsArrayList) {
//            if (item.getBarcode().equals(barcode)) {
//                item.setScanQty(newQuantity);
//                break;
//            }
//        }
//        loadScanItems();
//    }

    public void refreshRecyclerView() {
        ScanTempRVAdapter scanTempRVAdapter = new ScanTempRVAdapter(scanItemsArrayList, this);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(this, RecyclerView.VERTICAL, false);
        scanItemsRV.setLayoutManager(linearLayoutManager);
        scanItemsRV.setAdapter(scanTempRVAdapter);
    }
}
