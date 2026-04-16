import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../models/api_response.dart';
import '../services/storage_service.dart';
import 'package:get/get.dart';

class ApiService extends GetxService {
  final StorageService _storage = Get.find<StorageService>();
  final Logger _logger = Logger();

  // Timeout duration
  static const Duration _timeout = Duration(seconds: 30);

  /// Get base URL from storage
  String get _baseUrl {
    String url = _storage.baseUrl;
    if (url.isEmpty) {
      throw Exception('Base URL is not configured. Please check settings.');
    }
    return url;
  }

  /// Helper method to build URI with query parameters
  Uri _buildUri(String endpoint, {Map<String, String>? queryParameters}) {
    String baseUrl = _baseUrl;
    if (!baseUrl.endsWith('/')) baseUrl += '/';

    return Uri.parse('$baseUrl$endpoint').replace(
      queryParameters: queryParameters,
    );
  }

  /// Helper method to handle HTTP GET request (returns Map)
  Future<Map<String, dynamic>> _get(String endpoint,
      {Map<String, String>? queryParameters}) async {
    final uri = _buildUri(endpoint, queryParameters: queryParameters);
    _logger.d('GET: $uri');

    try {
      final response = await http.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else {
          _logger.e('Expected Map but got: ${decoded.runtimeType}');
          _logger.e('Response body: ${response.body}');
          throw Exception('Invalid response format: expected JSON object');
        }
      } else {
        throw Exception(
            'HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    } on TimeoutException {
      throw Exception('Connection timeout. Please check your network.');
    } on FormatException catch (e) {
      _logger.e('JSON decode error: $e');
      throw Exception('Invalid server response format.');
    } catch (e) {
      rethrow;
    }
  }

  /// Helper method to handle HTTP GET request (returns List)
  Future<List<dynamic>> _getList(String endpoint,
      {Map<String, String>? queryParameters}) async {
    final uri = _buildUri(endpoint, queryParameters: queryParameters);
    _logger.d('GET: $uri');

    try {
      final response = await http.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          return decoded;
        } else {
          _logger.e('Expected List but got: ${decoded.runtimeType}');
          _logger.e('Response body: ${response.body}');
          throw Exception('Invalid response format: expected JSON array');
        }
      } else {
        throw Exception(
            'HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    } on TimeoutException {
      throw Exception('Connection timeout. Please check your network.');
    } on FormatException catch (e) {
      _logger.e('JSON decode error: $e');
      throw Exception('Invalid server response format.');
    } catch (e) {
      rethrow;
    }
  }

  /// Helper method to handle HTTP POST request
  Future<Map<String, dynamic>> _post(String endpoint,
      {Map<String, dynamic>? body}) async {
    final uri = _buildUri(endpoint);
    _logger.d('POST: $uri');

    try {
      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else {
          _logger.e('Expected Map but got: ${decoded.runtimeType}');
          throw Exception('Invalid response format: expected JSON object');
        }
      } else {
        throw Exception(
            'HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    } on TimeoutException {
      throw Exception('Connection timeout. Please check your network.');
    } on FormatException catch (e) {
      _logger.e('JSON decode error: $e');
      throw Exception('Invalid server response format.');
    } catch (e) {
      rethrow;
    }
  }

  // ==================== AUTHENTICATION ====================

  /// Login API - Native: data/login?userName=X&password=Y
  Future<LoginResponse> login({
    required String userName,
    required String password,
  }) async {
    try {
      final response = await _get('data/login', queryParameters: {
        'userName': userName,
        'password': password,
      });

      return LoginResponse.fromJson(response);
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  // ==================== BARCODE & ITEM SEARCH ====================

  /// Get item by barcode - Native: Data/GetByBarcode
  Future<ApiResponse<List<BarcodeSearchResult>>> getByBarcode({
    required String barcode,
    required String depoCode,
    String searchText = '',
  }) async {
    try {
      final response = await _get('Data/GetByBarcode', queryParameters: {
        'barcode': barcode,
        'depoCode': depoCode,
        'searchText': searchText,
      });

      if (response['ReturnData'] is List) {
        List<BarcodeSearchResult> results = (response['ReturnData'] as List)
            .map((item) =>
                BarcodeSearchResult.fromJson(item as Map<String, dynamic>))
            .toList();

        return ApiResponse<List<BarcodeSearchResult>>(
          status: response['Status'] ?? false,
          message: response['Message'] ?? '',
          data: results,
        );
      }

      return ApiResponse<List<BarcodeSearchResult>>(
        status: response['Status'] ?? false,
        message: response['Message'] ?? 'No data found',
        data: [],
      );
    } catch (e) {
      throw Exception('Barcode search failed: ${e.toString()}');
    }
  }

  /// Search items - Native: ValuesApi/GetItemSearch
  Future<ApiResponse<List<ItemSearchResult>>> searchItems({
    required String searchText,
    required String depoCode,
  }) async {
    try {
      final response = await _get('ValuesApi/GetItemSearch', queryParameters: {
        'searchText': searchText,
        'depoCode': depoCode,
      });

      if (response['ReturnData'] is List) {
        List<ItemSearchResult> results = (response['ReturnData'] as List)
            .map((item) =>
                ItemSearchResult.fromJson(item as Map<String, dynamic>))
            .toList();

        return ApiResponse<List<ItemSearchResult>>(
          status: response['Status'] ?? false,
          message: response['Message'] ?? '',
          data: results,
        );
      }

      return ApiResponse<List<ItemSearchResult>>(
        status: response['Status'] ?? false,
        message: response['Message'] ?? 'No items found',
        data: [],
      );
    } catch (e) {
      throw Exception('Item search failed: ${e.toString()}');
    }
  }

  // ==================== SESSION MANAGEMENT ====================

  /// Get sessions list - Native: ValuesApi/GetSession
  Future<List<SessionInfo>> getSessions({
    required String fromDate,
    required String toDate,
  }) async {
    try {
      final response = await _getList('ValuesApi/GetSession', queryParameters: {
        'FromDate': fromDate,
        'ToDate': toDate,
      });

      _logger.d('Sessions fetched: ${response.length}');

      return response
          .map((item) => SessionInfo.fromJson(item as Map<String, dynamic>))
          .where((session) => !session.isDiscard)
          .toList();
    } catch (e, stackTrace) {
      _logger.e('Failed to fetch sessions: $e');
      _logger.e('Stack trace: $stackTrace');
      throw Exception('Failed to fetch sessions: ${e.toString()}');
    }
  }

  /// Get session data (paginated) - Native: ValuesApi/GetSessionList
  /// Returns a List containing one object with TotalPage and Data array
  Future<SessionDataItem> getSessionData({
    required String sessionId,
    required int pageNo,
    int dataRowSize = 80000,
  }) async {
    try {
      final response =
          await _getList('ValuesApi/GetSessionList', queryParameters: {
        'SessionId': sessionId,
        'PageNo': pageNo.toString(),
        'DataRowSize': dataRowSize.toString(),
      });

      if (response.isNotEmpty) {
        _logger.d('Session data page $pageNo: ${response.length} item(s)');
        return SessionDataItem.fromJson(response[0] as Map<String, dynamic>);
      }

      throw Exception('No data received for session');
    } catch (e, stackTrace) {
      _logger.e('Failed to fetch session data: $e');
      _logger.e('Stack trace: $stackTrace');
      throw Exception('Failed to fetch session data: ${e.toString()}');
    }
  }

  // ==================== INVENTORY OPERATIONS ====================

  /// Save inventory data - Native: Data/SaveInventory
  /// Accepts a list of inventory items to save
  Future<SaveInventoryResponse> saveInventory({
    required List<Map<String, dynamic>> inventoryData,
  }) async {
    try {
      // Native sends data as JSON array in POST body
      final response = await _post('Data/SaveInventory', body: {
        'data': inventoryData,
      });

      return SaveInventoryResponse.fromJson(response);
    } catch (e) {
      throw Exception('Failed to save inventory: ${e.toString()}');
    }
  }

  /// Save inventory in chunks (for large datasets)
  /// Native processes 6 items at a time
  Future<SaveInventoryResponse> saveInventoryInChunks({
    required List<Map<String, dynamic>> inventoryData,
    int chunkSize = 6,
    Function(int progress, int total)? onProgress,
  }) async {
    int totalItems = inventoryData.length;
    int successfulItems = 0;
    int failedItems = 0;

    for (int i = 0; i < inventoryData.length; i += chunkSize) {
      int endIndex = (i + chunkSize < inventoryData.length)
          ? i + chunkSize
          : inventoryData.length;

      List<Map<String, dynamic>> chunk = inventoryData.sublist(i, endIndex);

      try {
        final response = await saveInventory(inventoryData: chunk);

        if (response.status) {
          successfulItems += chunk.length;
          onProgress?.call(successfulItems, totalItems);
        } else {
          failedItems += chunk.length;
          throw Exception(response.message);
        }
      } catch (e) {
        failedItems += chunk.length;
        rethrow;
      }
    }

    return SaveInventoryResponse(
      status: failedItems == 0,
      message: 'Saved: $successfulItems, Failed: $failedItems',
      savedCount: successfulItems,
    );
  }

  /// Adjust quantity - Native: Data/AdjustQty (if exists)
  /// This endpoint may vary based on your API
  Future<SaveInventoryResponse> adjustQuantity({
    required String barcode,
    required String sessionId,
    required double adjustedQty,
    required String userId,
    required String deviceId,
  }) async {
    try {
      final response = await _post('Data/AdjustQty', body: {
        'Barcode': barcode,
        'SessionId': sessionId,
        'AdjustedQty': adjustedQty,
        'UserId': userId,
        'DeviceId': deviceId,
      });

      return SaveInventoryResponse.fromJson(response);
    } catch (e) {
      throw Exception('Failed to adjust quantity: ${e.toString()}');
    }
  }

  // ==================== HELPER METHODS ====================

  /// Check if API is accessible
  Future<bool> testConnection() async {
    try {
      final uri = _buildUri('data/login');
      final response = await http.get(uri).timeout(_timeout);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Get current date formatted as YYYY-MM-DD
  String getFormattedDate([DateTime? date]) {
    final d = date ?? DateTime.now();
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }
}
