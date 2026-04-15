package com.ms.inventory.activity;

import android.app.AlertDialog;
import android.content.Context;
import android.os.Bundle;
import android.os.Vibrator;
import android.util.Log;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.ms.inventory.R;
import com.ms.inventory.model.ScanItems;
import com.ms.inventory.utils.DBHelper;
import com.ms.inventory.utils.Utils;

public class UpdateTempScanItemActivity extends AppCompatActivity {

    private static final String TAG = "UpdateScanItemActivity";

    private DBHelper DB;
    private EditText edtuScanQty;
    private ScanItems scanItems ;
    String barcode, userBarcode, itemDescription, scanQty;
    Vibrator mVibrator;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_update_temp_scan_item);

        TextView tvuBarcode = findViewById(R.id.tvu_barcode_id);
        TextView tvuUserBarcode = findViewById(R.id.tvu_user_barcode_id);
        TextView tvuDescription = findViewById(R.id.tvu_description_id);
        edtuScanQty = findViewById(R.id.edtu_scan_qty_id);
//        FancyButton btnuCancel = findViewById(R.id.btnu_cancel_id);
//        FancyButton btnuSave = findViewById(R.id.btnu_save_id);
//        FancyButton btnuDelete = findViewById(R.id.btnu_delete_id);
        Button btnuCancel = findViewById(R.id.btnu_cancel_id);  // Changed to Button
        Button btnuSave = findViewById(R.id.btnu_save_id);      // Changed to Button
        Button btnuDelete = findViewById(R.id.btnu_delete_id);

        DB = new DBHelper(UpdateTempScanItemActivity.this);

        scanItems = (ScanItems) getIntent().getSerializableExtra("ITEM");
        barcode = scanItems.barcode;
        userBarcode = scanItems.userBarcode;
        itemDescription = scanItems.itemDescription;
        scanQty = scanItems.scanQty;

        tvuBarcode.setText(barcode);
        tvuUserBarcode.setText(userBarcode);
        tvuDescription.setText(itemDescription);
        edtuScanQty.setText(scanQty);

        mVibrator = (Vibrator) getSystemService(Context.VIBRATOR_SERVICE);

        btnuCancel.setOnClickListener(v -> finish());

        btnuSave.setOnClickListener(v -> processForUpdate());

        btnuDelete.setOnClickListener(v -> {
            errorVibration();
            deleteConfirmationDialog();
        });
    }

    private void processForUpdate() {
        String newQty = edtuScanQty.getText().toString().trim();

        if (newQty.isEmpty()) {
            Utils.errorDialog(this, "Empty Quantity!", "Scan Quantity is empty. Please enter quantity");
            errorVibration();
            return;
        }

        double newDoubleQty = Double.parseDouble(newQty);
        String newDoubleQtyStr = String.valueOf(newDoubleQty);

        try {
            if (newDoubleQty <= 0) {
                Utils.errorDialog(this, "Zero Quantity!", "Zero Quantity is not allowed. Please enter positive quantity");
                errorVibration();
                return;
            }
        } catch (NumberFormatException e) {
            Log.e(TAG, "processForUpdate: " + e);
            return;
        }

        if (newDoubleQtyStr.equals(scanQty)) {
            finish();
        } else {
            DB.updateTempScanItem(scanItems, newDoubleQtyStr);
            ViewTempScanItems.getInstance().loadScanItems(); // Update the item in the list
//            ViewTempScanItems.getInstance().updateScanItem(barcode, newDoubleQtyStr); // Update the item in the list
            Toast.makeText(UpdateTempScanItemActivity.this, "Item Updated", Toast.LENGTH_SHORT).show();
            finish();
        }
    }

    private void deleteConfirmationDialog() {
        AlertDialog.Builder d = new AlertDialog.Builder(this);
        d.setTitle("Confirmation");
        d.setMessage("Do you want to delete item");
        d.setNegativeButton("No", (dialog, which) -> dialog.dismiss());

        d.setPositiveButton("Yes", (dialog, which) -> {
            dialog.dismiss();
            processForDelete();

        });
        d.create().show();
    }

    private void processForDelete() {
        boolean checkDeleteData = DB.deleteTempSingleData(scanItems);
        if (checkDeleteData) {
            Toast.makeText(UpdateTempScanItemActivity.this, "Item delete successfully!", Toast.LENGTH_SHORT).show();
            Log.e(TAG, "onResponse: Item delete successfully!");
            ViewTempScanItems.getInstance().loadScanItems();
            finish();
            //Toast.makeText(ScanActivity.this, "Data delete successfully!", Toast.LENGTH_SHORT).show();
        } else {
            Toast.makeText(UpdateTempScanItemActivity.this, "Item delete failed!", Toast.LENGTH_SHORT).show();
            Log.e(TAG, "onResponse: Item delete failed!");
            //Toast.makeText(ScanActivity.this, "Data delete failed!", Toast.LENGTH_SHORT).show();
        }
    }

    private void errorVibration() {

        mVibrator.vibrate(600);

    }
}