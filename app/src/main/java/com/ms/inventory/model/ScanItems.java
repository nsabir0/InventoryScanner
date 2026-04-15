package com.ms.inventory.model;

import java.io.Serializable;

public class ScanItems implements Serializable {

    public String itemCode;
    public String barcode;
    public String userBarcode;
    public String sBarcode;
    public String itemDescription;
    public String scanQty;
    public String adjQty;
    public String userId;
    public String deviceId;
    public String zoneName;
    public String scQty;
    public String srQty;
    public String enQty;
    public String createDate;
    public String systemQty;
    public String sQty;
    public String outletCode;
    public String salePrice;
    public String cpu;
    public String sessionId;
    public int id;

    public ScanItems(String itemCode, String barcode, String userBarcode, String sBarcode, String itemDescription, String scanQty, String adjQty, String userId, String deviceId, String zoneName, String scQty, String srQty, String enQty, String createDate, String systemQty, String sQty, String outletCode, String salePrice, String cpu, String sessionId) {
        this.itemCode = itemCode;
        this.userBarcode = userBarcode;
        this.sBarcode = sBarcode;
        this.barcode = barcode;
        this.itemDescription = itemDescription;
        this.scanQty = scanQty;
        this.adjQty = adjQty;
        this.userId = userId;
        this.deviceId = deviceId;
        this.zoneName = zoneName;
        this.scQty = scQty;
        this.srQty = srQty;
        this.enQty = enQty;
        this.createDate = createDate;
        this.systemQty = systemQty;
        this.sQty = sQty;
        this.outletCode = outletCode;
        this.salePrice = salePrice;
        this.cpu = cpu;
        this.sessionId = sessionId;
    }

    public String getItemCode() {
        return itemCode;
    }

    public void setItemCode(String itemCode) {
        this.itemCode = itemCode;
    }

    public String getBarcode() {
        return barcode;
    }

    public void setBarcode(String barcode) {
        this.barcode = barcode;
    }

    public String getUserBarcode() {
        return userBarcode;
    }

    public void setUserBarcode(String userBarcode) {
        this.userBarcode = userBarcode;
    }

    public String getSBarcode() {
        return sBarcode;
    }

    public void setSBarcode(String sBarcode) {
        this.sBarcode = sBarcode;
    }

    public String getCpu() {
        return cpu;
    }

    public void setCpu(String cpu) {
        this.cpu = cpu;
    }

    public String getSessionId() {
        return sessionId;
    }

    public void setSessionId(String sessionId) {
        this.sessionId = sessionId;
    }

    public String getItemDescription() {
        return itemDescription;
    }

    public void setItemDescription(String itemDescription) {
        this.itemDescription = itemDescription;
    }

    public String getScanQty() {
        return scanQty;
    }

    public void setScanQty(String scanQty) {
        this.scanQty = scanQty;
    }

    public String getAdjQty() {
        return adjQty;
    }

    public void setAdjQty(String adjQty) {
        this.adjQty = adjQty;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    public String getZoneName() {
        return zoneName;
    }

    public void setZoneName(String zoneName) {
        this.zoneName = zoneName;
    }

    public String getScQty() {
        return scQty;
    }

    public void setScQty(String scQty) {
        this.scQty = scQty;
    }

    public String getSrQty() {
        return srQty;
    }

    public void setSrQty(String srQty) {
        this.srQty = srQty;
    }

    public String getEnQty() {
        return enQty;
    }

    public void setEnQty(String enQty) {
        this.enQty = enQty;
    }

    public String getCreateDate() {
        return createDate;
    }

    public void setCreateDate(String createDate) {
        this.createDate = createDate;
    }

    public String getSystemQty() {
        return systemQty;
    }

    public void setSystemQty(String systemQty) {
        this.systemQty = systemQty;
    }

    public String getSQty() {
        return sQty;
    }

    public void setSQty(String sQty) {
        this.sQty = sQty;
    }

    public String getOutletCode() {
        return outletCode;
    }

    public void setOutletCode(String outletCode) {
        this.outletCode = outletCode;
    }

    public String getSalePrice() {
        return salePrice;
    }

    public void setSalePrice(String salePrice) {
        this.salePrice = salePrice;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

}

