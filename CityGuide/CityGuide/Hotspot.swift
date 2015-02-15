//
//  Hotspot.swift
//  CityGuide
//
//  Created by Chudin Yuriy on 15.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

import Foundation

class Hotspot: BaseData {
	var id: UInt = 0
	var name: String?
	var desc: String?
	var category: String?
	var imageFileName: String?

	override init() {
		super.init();
	}
	
	class private func dataRequestString() -> String {
		return "SELECT id, name, description, category, image_file_name FROM hotspots"
	}
	
	class func hotspotById(id: UInt) -> Hotspot {
		return sendRequest(String(format: "%@ WHERE id = %d", dataRequestString(), id), converter: { (sqlite3_stmt stmt) -> AnyObject! in
			return self.itemWithSqlite3_stmt(stmt);
		})[0] as Hotspot;
	}
	
	class func allHotspots() -> Hotspot {
		return sendRequest("%@  id = %d", converter: { (sqlite3_stmt stmt) -> AnyObject! in
			return self.itemWithSqlite3_stmt(stmt);
		})[0] as Hotspot;
	}
	
	class private func itemWithSqlite3_stmt(stmt: COpaquePointer) -> AnyObject {
		var item = Hotspot();
		item.id = UInt(sqlite3_column_int(stmt, 0));
		item.name = String.fromCString(UnsafePointer <Int8> (sqlite3_column_text(stmt, CInt(1))));
		item.desc = String.fromCString(UnsafePointer <Int8> (sqlite3_column_text(stmt, CInt(2))));
		item.category = String.fromCString(UnsafePointer <Int8> (sqlite3_column_text(stmt, CInt(3))));
		item.imageFileName = String.fromCString(UnsafePointer <Int8> (sqlite3_column_text(stmt, CInt(4))));
		
		return item;
	}
}