package com.ms.inventory.adapter;

import android.annotation.SuppressLint;
import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.ms.inventory.R;
import com.ms.inventory.model.InventoryData;
import com.ms.inventory.utils.DBHelper;

import java.util.List;

public class ItemSearchAdapter extends BaseAdapter {

	List<InventoryData.Data> list;
	Context context;
	int resource;
	DBHelper DB;

	public ItemSearchAdapter(Context context, List<InventoryData.Data> list) {
		this.context = context;
		this.list = list;
		this.resource = R.layout.search_list_item;
		DB = DBHelper.getInstance(context);

	}

	@Override
	public int getCount() {
		return list.size();
	}

	@Override
	public Object getItem(int position) {
		return list.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@SuppressLint("SetTextI18n")
	@Override
	public View getView(int position, View convertView, ViewGroup parent) {

		View view = convertView;

		ViewHolder holder;

		if (view == null) {
			view = View.inflate(context, resource, null);
			holder = new ViewHolder(view);
			view.setTag(holder);

		} else {

			holder = (ViewHolder) view.getTag();

		}

		InventoryData.Data item = list.get(position);


		holder.textView1.setText(item.getDescription());
		holder.textView4.setText("MRP: " + item.getMrp());

		if (!item.getBarcode().isEmpty()) {
//			String userBarcode = DB.getUserBarcodeFromInventory(item.barcode);
			String userBarcode = item.getUserBarcode();
			holder.textView2.setText("Barcode: " + item.getBarcode());
			if (userBarcode.isEmpty()) {
				holder.textView3.setVisibility(View.GONE);
			} else {
				holder.textView3.setText("UserBarcode: " + userBarcode);
			}
		} else {
			holder.textView2.setVisibility(View.GONE);
		}
		return view;
	}


	static class ViewHolder {
		TextView textView1, textView2, textView3, textView4;

		ViewHolder(View v) {
			textView1 = v.findViewById(R.id.tvName);
			textView2 = v.findViewById(R.id.tvBarcode);
			textView3 = v.findViewById(R.id.tvUBarcode);
			textView4 = v.findViewById(R.id.tvMrp);
		}
	}
}
