package com.ms.inventory.activity;

import android.Manifest;
import android.app.ProgressDialog;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.HandlerThread;
import android.view.Gravity;
import android.widget.CheckBox;
import android.widget.LinearLayout;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.ms.inventory.R;
import com.ms.inventory.model.ScanItems;
import com.ms.inventory.utils.DBHelper;
import com.ms.inventory.utils.Utils;

import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Objects;

/**
 * @noinspection deprecation
 */
public class ImportActivity extends AppCompatActivity {

	private static final String TAG = "ImportActivity";
	private static final int PICK_XLS_FILE_REQUEST_CODE = 1025;
	private static final int STORAGE_PERMISSION_REQUEST_CODE = 1001;
	private static final int READ_PERMISSION_REQUEST_CODE = 1002;

	private Uri uriFile;
	private boolean isFirstLineHeader;
	private DBHelper DB;
	private ProgressDialog pd;
	private Handler mainHandler;
	private HandlerThread handlerThread;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_import);
		Objects.requireNonNull(getSupportActionBar()).setTitle("Import & Export");

		DB = DBHelper.getInstance(this);
		pd = new ProgressDialog(this);
		pd.setTitle("Importing Excel");
		pd.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
		pd.setCancelable(false);

		findViewById(R.id.btn_csv).setOnClickListener(v -> Toast.makeText(this, "CSV import not supported in this version", Toast.LENGTH_SHORT).show());

		findViewById(R.id.btn_excel).setOnClickListener(v -> openBrowserForExcel());

		findViewById(R.id.btn_backup_db).setOnClickListener(v -> {
			if (checkStoragePermission()) {
				backupExcel();
			} else {
				requestStoragePermission();
			}
		});
	}

	private boolean checkReadPermission() {
		return ContextCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED;
	}

	private void requestReadPermission() {
		ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.READ_EXTERNAL_STORAGE}, READ_PERMISSION_REQUEST_CODE);
	}

	private boolean checkStoragePermission() {
		return ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED;
	}

	private void requestStoragePermission() {
		ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, STORAGE_PERMISSION_REQUEST_CODE);
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
		AlertDialog.Builder d = new AlertDialog.Builder(this);
		d.setTitle("Import from Excel");
		d.setMessage("Please Pick a Excel (.xls) file.");

		LinearLayout layout = new LinearLayout(this);
		layout.setOrientation(LinearLayout.VERTICAL);
		layout.setPadding(50, 20, 20, 20);

		final CheckBox checkBox = new CheckBox(this);
		checkBox.setText(R.string.my_data_has_headers);
		checkBox.setChecked(true);
		layout.addView(checkBox);

		d.setView(layout);

		d.setNegativeButton("Cancel", (dialog, which) -> dialog.dismiss());
		d.setPositiveButton("OK", (dialog, which) -> {
			isFirstLineHeader = checkBox.isChecked();
			openFilePicker();
		});

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

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if (requestCode == PICK_XLS_FILE_REQUEST_CODE && resultCode == RESULT_OK) {
			if (data != null) {
				uriFile = data.getData();
				checkTempItemsAndProceed(Objects.requireNonNull(uriFile));
			}
		}
	}

	private void checkTempItemsAndProceed(Uri uri) {
		if (DB.hasTempScanItems()) {
			AlertDialog.Builder d = new AlertDialog.Builder(this);
			d.setTitle("Warning");
			d.setMessage("Temporary Scanned items are not empty, do you want to remove before importing?");
			d.setNegativeButton("No", (dialog, which) -> dialog.dismiss());
			d.setPositiveButton("Yes", (dialog, which) -> readExcelFile(uri));
			d.create().show();
		} else {
			readExcelFile(uri);
		}
	}

	private void readExcelFile(Uri uri) {
		String path = uri.toString();
		String type = path.substring(path.lastIndexOf(".") + 1);

		if (type.equalsIgnoreCase("xls")) {
			importExcel();
		} else {
			final String msg = "The file you have selected is not supported. Please select <b>Excel 97-2003 (.xls)</b> file.";
			runOnUiThread(() -> Utils.errorDialog(ImportActivity.this, "File Not Supported!", msg, true));
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
				HSSFWorkbook workbook = new HSSFWorkbook(inputStream);
				HSSFSheet sheet = workbook.getSheetAt(0);
				Iterator<Row> rows = sheet.iterator();

				final int rowCount = sheet.getLastRowNum();

				mainHandler.post(() -> {
					pd.setMax(rowCount);
					pd.setIndeterminate(false);
					pd.setMessage("Excel data is importing. Please wait...");
				});

				int count = 0;
				boolean isFirstRow = isFirstLineHeader;

				while (rows.hasNext()) {
					Row row = rows.next();

					if (isFirstRow) {
						isFirstRow = false;
						continue;
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
					Toast.makeText(ImportActivity.this, "Data importing completed", Toast.LENGTH_SHORT).show();
				});

			} catch (org.apache.poi.hssf.OldExcelFormatException e) {
				mainHandler.post(() -> {
					pd.dismiss();
					Toast.makeText(ImportActivity.this, "Corrupted XLS Document file", Toast.LENGTH_LONG).show();
				});
			} catch (IOException e) {
				mainHandler.post(() -> {
					pd.dismiss();
					Utils.errorDialog(ImportActivity.this, "Import Error", "Error found while data has been importing", true);
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
			toast = Toast.makeText(ImportActivity.this, "No Scanned Item Found to Export", Toast.LENGTH_SHORT);
		} else {
			String filePath = ExportExcel.exportToExcel(scanItemsList);
			if (filePath != null) {
				toast = Toast.makeText(ImportActivity.this, "Data Backup Successful!\n Saved at: " + filePath, Toast.LENGTH_LONG);
			} else {
				toast = Toast.makeText(ImportActivity.this, "Data Backup Failed!", Toast.LENGTH_SHORT);
			}
		}

		toast.setGravity(Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 200);
		toast.show();
	}

	public static class ExportExcel {

//		private static final String TAG = "ExcelExporter";
		private static final String DIRECTORY_NAME = "InventoryExports";

		public static String exportToExcel(List<ScanItems> scanItemsList) {
			File directory = new File(Environment.getExternalStoragePublicDirectory(
					Environment.DIRECTORY_DOCUMENTS), DIRECTORY_NAME);
			if (!directory.exists()) {
				if (!directory.mkdirs()) {
					android.util.Log.e(TAG, "Failed to create directory");
					return null;
				}
			}
			String timeStamp = new SimpleDateFormat("yyyyMMdd_hhmmss", Locale.getDefault()).format(new Date());
			String backupDBName = "backup_scanitems" + timeStamp + ".xls";

			String filePath = directory.getPath() + File.separator + backupDBName;

			try (Workbook workbook = new HSSFWorkbook()) {
				Sheet sheet = workbook.createSheet("Scan Items");

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

				try (FileOutputStream fileOut = new FileOutputStream(filePath)) {
					workbook.write(fileOut);
				}

				android.util.Log.i(TAG, "Export successful");
				return filePath;
			} catch (IOException e) {
				android.util.Log.e(TAG, "Error exporting to Excel: " + e.getMessage());
				return null;
			}
		}
	}
}