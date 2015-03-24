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
	var imageFileName: String?
    var lat: Double = 0
    var lon: Double = 0
	var category: CGCategory?
    var lastUpdated: NSDate?
    var phone: String?
    var site: String?
    var address: String?

	override init() {
		super.init();
	}
	
	func categoryName() -> String {
		return category!.name;
	}
	
	class private func dataRequestString() -> String {
		return "SELECT id, name, description, category, image_file_name, lat, lng, updated_at, phone, site, address FROM hotspots"
	}
	
	class func hotspotById(id: UInt) -> Hotspot {
		let array = convertArray(sendRequest(String(format: "%@ WHERE id = %d", dataRequestString(), id), converter: { (sqlite3_stmt stmt) -> AnyObject! in
			return self.itemWithSqlite3_stmt(stmt);
		}));
		
		return array[0];
	}
    
    class func lastUpdateDate() -> NSDate {
        var lastUpdateDate: NSDate? = nil
        
        let array = convertArray(sendRequest("SELECT id, name, description, category, image_file_name, lat, lng, updated_at, phone, site, address FROM hotspots order by updated_at desc limit 1", converter: { (sqlite3_stmt stmt) -> AnyObject! in
            return self.itemWithSqlite3_stmt(stmt);
        }));
        
        if (array.count > 0) {
            let h = array[0]
            lastUpdateDate = h.lastUpdated
        }
        
        if lastUpdateDate == nil {
            lastUpdateDate = NSDate(timeIntervalSince1970: 0)
        }
        
        return lastUpdateDate!
    }
    
    func categoryImageName() -> String {

        if let c = self.category {
            println("Category image = " + c.mapiconFileName())
            return c.mapiconFileName()
        }
        println("no image")
        return ""
    }
	
	class func hotspotsByCategory(category: CGCategory) -> [Hotspot] {
        var array: [Hotspot];
        
        if (category.id == CategoryEnum.Favourites) {
            array = FavouritesManager.sharedManager().allFavourites() as [Hotspot]
        } else {
            let categoryString = category.name.lowercaseString
            array = convertArray(sendRequest(String(format: "%@ WHERE category = \"%@\"", dataRequestString(), categoryString), converter: { (sqlite3_stmt stmt) -> AnyObject! in
                return self.itemWithSqlite3_stmt(stmt)
            }));
        }
        
		for item in array {
			item.category = category;
		}
		
		return array;
	}
	
	class func allHotspots() -> [Hotspot] {
		return convertArray(sendRequest(dataRequestString(), converter: { (sqlite3_stmt stmt) -> AnyObject! in
			return self.itemWithSqlite3_stmt(stmt);
		}));
	}
	
	class private func convertArray(array: NSArray) -> [Hotspot] {
		var hotspots: [Hotspot] = [];
		for item in array {
			hotspots.append(item as Hotspot);
		}
		
		return hotspots;
	}
    
    override func isEqual(object: AnyObject?) -> Bool {
        if let obj = object as? Hotspot {
            
            return self.id == obj.id
        }
        return super.isEqual(object)
    }
	
	class private func itemWithSqlite3_stmt(stmt: COpaquePointer) -> AnyObject {
		var item = Hotspot();
		item.id = UInt(sqlite3_column_int(stmt, 0));
		item.name = String.fromCString(UnsafePointer <Int8> (sqlite3_column_text(stmt, CInt(1))));
		item.desc = String.fromCString(UnsafePointer <Int8> (sqlite3_column_text(stmt, CInt(2))));
        var n = String.fromCString(UnsafePointer <Int8> (sqlite3_column_text(stmt, CInt(3))))
        item.category = CGCategory.categoryByName(n!)
        var filename = String(format: "hotspots-%d-%@", item.id, String.fromCString(UnsafePointer <Int8> (sqlite3_column_text(stmt, CInt(4))))!);
        var pathExtension = filename.pathExtension
        item.imageFileName = String(format: "%@-large.%@", filename.stringByDeletingPathExtension, pathExtension)
        
        item.lat = sqlite3_column_double(stmt, CInt(5))
        item.lon = sqlite3_column_double(stmt, CInt(6))
        if let dateString = String.fromCString(UnsafePointer <Int8> (sqlite3_column_text(stmt, CInt(7)))) {
            var dateFormatter: NSDateFormatter = NSDateFormatter()
            var format:NSString = "YYYY-MM-dd HH:mm:ss"
            dateFormatter.dateFormat = format
            var dateStr = dateString as NSString
            dateStr = dateStr.substringToIndex(format.length)
            NSLog("date str: %@", dateStr)
            item.lastUpdated = dateFormatter.dateFromString(dateStr)
        }
        item.phone = String.fromCString(UnsafePointer <Int8> (sqlite3_column_text(stmt, CInt(8))))
        item.site = String.fromCString(UnsafePointer <Int8> (sqlite3_column_text(stmt, CInt(9))))
        item.address = String.fromCString(UnsafePointer <Int8> (sqlite3_column_text(stmt, CInt(10))))
		
		return item;
	}
}