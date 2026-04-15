class ScanItem {
  int? id;
  String? itemCode;
  String? barcode;
  String? userBarcode;
  String? sBarcode;
  String? itemDescription;
  String? scanQty;
  String? adjQty;
  String? userId;
  String? deviceId;
  String? zoneName;
  String? scQty;
  String? srQty;
  String? enQty;
  String? createDate;
  String? systemQty;
  String? sQty;
  String? outletCode;
  String? salePrice;
  String? cpu;
  String? sessionId;

  ScanItem({
    this.id,
    this.itemCode,
    this.barcode,
    this.userBarcode,
    this.sBarcode,
    this.itemDescription,
    this.scanQty,
    this.adjQty,
    this.userId,
    this.deviceId,
    this.zoneName,
    this.scQty,
    this.srQty,
    this.enQty,
    this.createDate,
    this.systemQty,
    this.sQty,
    this.outletCode,
    this.salePrice,
    this.cpu,
    this.sessionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'UserID': userId,
      'DeviceID': deviceId,
      'SessionId': sessionId,
      'OutletCode': outletCode,
      'ZoneName': zoneName,
      'ItemCode': itemCode,
      'Barcode': barcode,
      'User_Barcode': userBarcode,
      'sBarcode': sBarcode,
      'ItemDescription': itemDescription,
      'SalePrice': salePrice,
      'SystemQty': systemQty,
      'ScanQty': scanQty,
      'ScQty': scQty,
      'AdjQty': adjQty,
      'SrQty': srQty,
      'EnQty': enQty,
      'Sqty': sQty,
      'ScanDate': createDate,
      'CPU': cpu,
    };
  }
}
