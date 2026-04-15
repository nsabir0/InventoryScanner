# API Service Layer - Complete Implementation

## Overview
This document describes the complete API service layer implemented using the `http` package, replacing the previous Dio-based implementation.

## Architecture

### Files Structure
```
lib/data/
├── models/
│   └── api_response.dart          # API response model classes
├── services/
│   ├── api_service.dart           # Main API service with all endpoints
│   └── storage_service.dart       # Local storage service
└── providers/
    └── api_client.dart            # API client wrapper (GetxService)
```

## API Endpoints Implemented

### 1. Authentication
**Endpoint:** `data/login`
- **Method:** GET
- **Parameters:** 
  - `userName` (String)
  - `password` (String)
- **Response:** `LoginResponse`
- **Native Reference:** `LoginActivity.java` line 200

```dart
Future<LoginResponse> login({
  required String userName,
  required String password,
})
```

### 2. Barcode Search
**Endpoint:** `Data/GetByBarcode`
- **Method:** GET
- **Parameters:**
  - `barcode` (String)
  - `depoCode` (String)
  - `searchText` (String, optional)
- **Response:** `ApiResponse<List<BarcodeSearchResult>>`
- **Native Reference:** `ScanActivity.java` line 975

```dart
Future<ApiResponse<List<BarcodeSearchResult>>> getByBarcode({
  required String barcode,
  required String depoCode,
  String searchText = '',
})
```

### 3. Item Search
**Endpoint:** `ValuesApi/GetItemSearch`
- **Method:** GET
- **Parameters:**
  - `searchText` (String)
  - `depoCode` (String)
- **Response:** `ApiResponse<List<ItemSearchResult>>`

```dart
Future<ApiResponse<List<ItemSearchResult>>> searchItems({
  required String searchText,
  required String depoCode,
})
```

### 4. Get Sessions
**Endpoint:** `ValuesApi/GetSession`
- **Method:** GET
- **Parameters:**
  - `FromDate` (String, format: YYYY-MM-DD)
  - `ToDate` (String, format: YYYY-MM-DD)
- **Response:** `List<SessionInfo>`
- **Native Reference:** `SessionActivity.java` line 132

```dart
Future<List<SessionInfo>> getSessions({
  required String fromDate,
  required String toDate,
})
```

### 5. Get Session Data (Paginated)
**Endpoint:** `ValuesApi/GetSessionList`
- **Method:** GET
- **Parameters:**
  - `SessionId` (String)
  - `PageNo` (int)
  - `DataRowSize` (int, default: 50000)
- **Response:** `SessionDataItem`
- **Native Reference:** `SessionActivity.java` line ~200

```dart
Future<SessionDataItem> getSessionData({
  required String sessionId,
  required int pageNo,
  int dataRowSize = 50000,
})
```

### 6. Save Inventory
**Endpoint:** `Data/SaveInventory`
- **Method:** POST
- **Body:** JSON array of inventory items
- **Response:** `SaveInventoryResponse`
- **Native Reference:** `ScanActivity.java` line 1494

```dart
Future<SaveInventoryResponse> saveInventory({
  required List<Map<String, dynamic>> inventoryData,
})
```

### 7. Save Inventory in Chunks
- Processes large datasets in batches (default: 6 items per chunk)
- Includes progress callback
- Matches native Android batch processing logic

```dart
Future<SaveInventoryResponse> saveInventoryInChunks({
  required List<Map<String, dynamic>> inventoryData,
  int chunkSize = 6,
  Function(int progress, int total)? onProgress,
})
```

### 8. Adjust Quantity
**Endpoint:** `Data/AdjustQty`
- **Method:** POST
- **Parameters:**
  - `Barcode` (String)
  - `SessionId` (String)
  - `AdjustedQty` (double)
  - `UserId` (String)
  - `DeviceId` (String)

```dart
Future<SaveInventoryResponse> adjustQuantity({
  required String barcode,
  required String sessionId,
  required double adjustedQty,
  required String userId,
  required String deviceId,
})
```

## Response Models

### ApiResponse<T>
Generic wrapper for all API responses:
```dart
{
  "Status": true,
  "Message": "Success",
  "ReturnData": [...] // or {}
}
```

### LoginResponse
```dart
{
  "Status": true,
  "Message": "Login successful"
}
```

### BarcodeSearchResult
```dart
{
  "PRODUCTCODE": "ITEM001",
  "PRODUCTNAME": "Product Name",
  "CurrentStock": 100.0,
  "SALES": 50.0,
  "UnitPrice": 10.99,
  "xtype": "0" // "0" = integer qty, "1" = decimal qty
}
```

### SessionInfo
```dart
{
  "SessionId": "SSN001",
  "IsDiscard": false,
  "SessionName": "Session Name",
  "CreateDate": "2024-01-15T10:30:00"
}
```

### SessionDataItem
```dart
{
  "SessionId": "SSN001",
  "Barcode": "123456789",
  "sBarcode": "987654321",
  "USER_BARCODE": "USER123",
  "StartQty": 100.0,
  "ScanQty": 50.0,
  "ScanStartDate": "2024-01-15",
  "MRP": 10.99,
  "Description": "Product Description",
  "CPU": 8.50,
  "TotalPage": 5,
  "Status": true,
  "Data": [...] // Array of inventory items
}
```

## Usage Examples

### 1. Login
```dart
final apiService = Get.find<ApiClient>().apiService;

try {
  final response = await apiService.login(
    userName: 'admin',
    password: 'password123',
  );
  
  if (response.status) {
    // Login successful
  } else {
    // Show error message
    print(response.message);
  }
} catch (e) {
  // Handle connection error
  print('Login failed: $e');
}
```

### 2. Barcode Search
```dart
try {
  final response = await apiService.getByBarcode(
    barcode: '123456789',
    depoCode: 'DC001',
  );
  
  if (response.isSuccess && response.data != null) {
    final item = response.data!.first;
    print('Product: ${item.productName}');
    print('Stock: ${item.currentStock}');
  }
} catch (e) {
  print('Search failed: $e');
}
```

### 3. Download Session Data
```dart
try {
  // First, get sessions
  final sessions = await apiService.getSessions(
    fromDate: '2024-01-01',
    toDate: apiService.getFormattedDate(),
  );
  
  // Then download data for each session
  for (final session in sessions) {
    int page = 1;
    int totalPages = 1;
    
    do {
      final data = await apiService.getSessionData(
        sessionId: session.sessionId,
        pageNo: page,
      );
      
      totalPages = data.totalPage;
      // Process data.data...
      
      page++;
    } while (page <= totalPages);
  }
} catch (e) {
  print('Download failed: $e');
}
```

### 4. Save Inventory in Chunks
```dart
try {
  final response = await apiService.saveInventoryInChunks(
    inventoryData: inventoryList,
    chunkSize: 6,
    onProgress: (progress, total) {
      print('Saving: $progress / $total');
    },
  );
  
  print('Saved: ${response.savedCount} items');
} catch (e) {
  print('Save failed: $e');
}
```

## Features

### 1. Error Handling
- **Timeout:** 30 seconds for all requests
- **HTTP Status Codes:** Proper handling of 200, 201, and error codes
- **Network Errors:** Catch and rethrow with descriptive messages
- **JSON Parsing:** FormatException handling for invalid responses

### 2. Logging
Integrated with `logger` package for:
- Request URLs
- Request bodies (POST)
- Response status codes
- Response bodies
- Error messages

### 3. Base URL Management
- Automatically retrieves base URL from `StorageService`
- Handles URL formatting (adds http:// if missing, ensures trailing /)
- Validates URL is configured before making requests

### 4. Helper Methods
```dart
// Test API connection
Future<bool> testConnection()

// Get formatted date (YYYY-MM-DD)
String getFormattedDate([DateTime? date])
```

## Migration from Dio to HTTP

### Key Changes:
1. **Replaced Package:** `dio: ^5.4.0` → `http: ^1.2.0`
2. **Simplified Client:** Removed Dio interceptors, using direct http methods
3. **Response Handling:** Manual JSON decoding instead of Dio's automatic parsing
4. **Timeout:** Using `.timeout()` method instead of Dio's built-in timeout

### Benefits:
- ✅ Smaller bundle size
- ✅ Simpler API for REST calls
- ✅ Native Flutter/HTTP semantics
- ✅ No significant functionality loss for this use case

## Testing

### Connection Test
```dart
final isConnected = await apiService.testConnection();
if (isConnected) {
  print('API is accessible');
} else {
  print('API is not accessible');
}
```

## Notes

1. **URL Format:** All endpoints are relative to the base URL configured in settings
2. **JSON Format:** API expects and returns JSON in the same format as native Android
3. **Pagination:** Session data supports pagination with configurable page size
4. **Batch Processing:** Save inventory supports chunked processing for large datasets
5. **Threading:** All methods are async and should be called from UI with proper loading states

## Future Enhancements

- [ ] Add retry logic for failed requests
- [ ] Implement request caching
- [ ] Add request/response interceptors if needed
- [ ] Implement file upload/download for Excel import/export
- [ ] Add offline request queue
