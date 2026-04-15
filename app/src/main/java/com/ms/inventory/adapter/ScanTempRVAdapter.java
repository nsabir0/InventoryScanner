package com.ms.inventory.adapter;

import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.ms.inventory.R;
import com.ms.inventory.activity.UpdateTempScanItemActivity;
import com.ms.inventory.model.ScanItems;

import java.util.ArrayList;

public class ScanTempRVAdapter extends RecyclerView.Adapter<ScanTempRVAdapter.ViewHolder> {

    private final ArrayList<ScanItems> scanItemsArrayList;
    private final Context context;

    public ScanTempRVAdapter(ArrayList<ScanItems> scanItemsArrayList, Context context) {
        this.scanItemsArrayList = scanItemsArrayList;
        this.context = context;
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {

        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.scan_rv_item, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {

        final ScanItems modal = scanItemsArrayList.get(position);
        holder.barcodeTV.setText(modal.barcode);
        holder.userBarcodeTV.setText(modal.userBarcode);
        holder.itemDescriptionTV.setText(modal.itemDescription);
        holder.scanQtyTV.setText(modal.scanQty);

        holder.itemView.setOnClickListener(v -> {

            Intent i = new Intent(context, UpdateTempScanItemActivity.class);

            i.putExtra("ITEM", modal);
//            i.putExtra("userBarcode", modal.getUserBarcode());
//            i.putExtra("itemDescription", modal.getItemDescription());
//            i.putExtra("scanQty", modal.getScanQty());

            context.startActivity(i);
        });

    }

    @Override
    public int getItemCount() {
        return scanItemsArrayList.size();
    }

    public static class ViewHolder extends RecyclerView.ViewHolder {

        private final TextView barcodeTV;
        private final TextView userBarcodeTV;
        private final TextView itemDescriptionTV;
        private final TextView scanQtyTV;

        public ViewHolder(@NonNull View itemView) {
            super(itemView);
            barcodeTV = itemView.findViewById(R.id.idTVBarcode);
            userBarcodeTV = itemView.findViewById(R.id.idTVUserBarcode);
            itemDescriptionTV = itemView.findViewById(R.id.idTVItemDescription);
            scanQtyTV = itemView.findViewById(R.id.idTVScanQty);
        }
    }
}
