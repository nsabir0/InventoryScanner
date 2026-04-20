class ApiResponse<T> {
  final bool status;
  final String message;
  final T? data;

  ApiResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json,
      {T? Function(dynamic)? parser}) {
    return ApiResponse<T>(
      status: json['Status'] ?? json['status'] ?? false,
      message: json['Message'] ?? json['message'] ?? '',
      data: parser != null
          ? parser(json['ReturnData'] ?? json['data'])
          : json['ReturnData'] ?? json['data'],
    );
  }

  bool get isSuccess => status;
}

class LoginResponse {
  final bool status;
  final String message;

  LoginResponse({
    required this.status,
    required this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['Status'] ?? false,
      message: json['Message'] ?? 'Unknown error',
    );
  }
}

class BarcodeSearchResult {
  final String productCode;
  final String productName;
  final double currentStock;
  final double sales;
  final double unitPrice;
  final String xtype;

  BarcodeSearchResult({
    required this.productCode,
    required this.productName,
    required this.currentStock,
    required this.sales,
    required this.unitPrice,
    required this.xtype,
  });

  factory BarcodeSearchResult.fromJson(Map<String, dynamic> json) {
    return BarcodeSearchResult(
      productCode: json['PRODUCTCODE']?.toString() ?? '',
      productName: json['PRODUCTNAME']?.toString() ?? '',
      currentStock: (json['CurrentStock'] as num?)?.toDouble() ?? 0.0,
      sales: (json['SALES'] as num?)?.toDouble() ?? 0.0,
      unitPrice: (json['UnitPrice'] as num?)?.toDouble() ?? 0.0,
      xtype: json['xtype']?.toString() ?? '0',
    );
  }
}

class SessionInfo {
  final String sessionId;
  final bool isDiscard;
  final String? sessionName;
  final DateTime? createDate;

  SessionInfo({
    required this.sessionId,
    required this.isDiscard,
    this.sessionName,
    this.createDate,
  });

  factory SessionInfo.fromJson(Map<String, dynamic> json) {
    return SessionInfo(
      sessionId: json['SessionId']?.toString() ?? '',
      isDiscard: json['IsDiscard'] ?? false,
      sessionName: json['SessionName']?.toString(),
      createDate: json['CreateDate'] != null
          ? DateTime.tryParse(json['CreateDate'].toString())
          : null,
    );
  }
}

class SessionDataItem {
  final String sessionId;
  final String barcode;
  final String sBarcode;
  final String userBarcode;
  final double startQty;
  final double scanQty;
  final String scanStartDate;
  final double mrp;
  final String description;
  final double cpu;
  final int totalPage;
  final bool status;
  final List<dynamic> data;

  SessionDataItem({
    required this.sessionId,
    required this.barcode,
    required this.sBarcode,
    required this.userBarcode,
    required this.startQty,
    required this.scanQty,
    required this.scanStartDate,
    required this.mrp,
    required this.description,
    required this.cpu,
    required this.totalPage,
    required this.status,
    required this.data,
  });

  factory SessionDataItem.fromJson(Map<String, dynamic> json) {
    return SessionDataItem(
      sessionId: json['SessionId']?.toString() ?? '',
      barcode: json['Barcode']?.toString() ?? '',
      sBarcode: json['sBarcode']?.toString() ?? '',
      userBarcode: json['USER_BARCODE']?.toString().trim() ?? '',
      startQty: (json['StartQty'] as num?)?.toDouble() ?? 0.0,
      scanQty: (json['ScanQty'] as num?)?.toDouble() ?? 0.0,
      scanStartDate: json['ScanStartDate']?.toString() ?? '',
      mrp: (json['MRP'] as num?)?.toDouble() ?? 0.0,
      description: json['Description']?.toString() ?? '',
      cpu: (json['CPU'] as num?)?.toDouble() ?? 0.0,
      totalPage: json['TotalPage'] ?? 1,
      status: json['Status'] ?? false,
      data: json['Data'] ?? [],
    );
  }
}

class ItemSearchResult {
  final String itemCode;
  final String barcode;
  final String name;
  final int currentStock;
  final int sale;
  final double unitPrice;

  ItemSearchResult({
    required this.itemCode,
    required this.barcode,
    required this.name,
    required this.currentStock,
    required this.sale,
    required this.unitPrice,
  });

  factory ItemSearchResult.fromJson(Map<String, dynamic> json) {
    return ItemSearchResult(
      itemCode: json['PRODUCTCODE']?.toString() ?? '',
      barcode: json['Barcode']?.toString() ?? '',
      name: json['PRODUCTNAME']?.toString() ?? '',
      currentStock: (json['CurrentStock'] as num?)?.toInt() ?? 0,
      sale: (json['SALES'] as num?)?.toInt() ?? 0,
      unitPrice: (json['UnitPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class SaveInventoryResponse {
  final bool status;
  final String message;
  final int? savedCount;

  SaveInventoryResponse({
    required this.status,
    required this.message,
    this.savedCount,
  });

  factory SaveInventoryResponse.fromJson(Map<String, dynamic> json) {
    return SaveInventoryResponse(
      status: json['Status'] ?? false,
      message: json['Message'] ?? '',
      savedCount: json['SavedCount'],
    );
  }

  bool get isSuccess => status;
}

class ScanItemInfo {
  final double adjQty;

  ScanItemInfo({required this.adjQty});

  factory ScanItemInfo.fromJson(Map<String, dynamic> json) {
    return ScanItemInfo(
      adjQty: (json['AdjQty'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
