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
    var isPrimary: Bool?
//	var imageFileName: String
    var lat: Double = 0
    var lon: Double = 0
	var category: CGCategory?
    var lastUpdated: NSDate?
    var phone: String?
    var site: String?
    var address: String?
    private var images: [UIImage]?

	override init() {
		super.init();
	}
    
    func convertedFileName(id: UInt, fileName: String?) -> String? {
        if let fileName = fileName {
            var filename = String(format: "hotspot_images-%d-%@", id, fileName);
            var pathExtension = filename.pathExtension
            return String(format: "%@-large.%@", filename.stringByDeletingPathExtension, pathExtension)
        }
        return ""
    }
    
//    func imageFileNames:
    
    var imageFileName: String? {
        let nsarray: NSArray = Hotspot.sendRequest(String(format:"select id, file_file_name from hotspot_images where hotspot_id = %d order by id limit 1", id), converter: { (sqlite3_stmt stmt) -> AnyObject! in
            return self.convertedFileName(UInt(sqlite3_column_int(stmt, 0)), fileName:String.fromCString(UnsafePointer <Int8> (sqlite3_column_text(stmt, CInt(1)))));
        })
        
        if nsarray.count > 0 {
            return nsarray.objectAtIndex(0) as! String
        }
        
        return nil
    }
    
    func getImages() -> [UIImage] {
        if let array = images {
            return array
        }
        
        //
        let nsarray: NSArray = Hotspot.sendRequest(String(format:"select id, file_file_name from hotspot_images where hotspot_id = %d order by id", id), converter: { (sqlite3_stmt stmt) -> AnyObject! in
            return self.convertedFileName(UInt(sqlite3_column_int(stmt, 0)), fileName:String.fromCString(UnsafePointer <Int8> (sqlite3_column_text(stmt, CInt(1)))));
        })
        
        images = []
        
        for file_file_name in nsarray {
            let documentsPath : AnyObject = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0]
            let destinationPath:String = documentsPath.stringByAppendingPathComponent(file_file_name as! String)

            if NSFileManager.defaultManager().fileExistsAtPath(destinationPath) {
                var img: UIImage? = UIImage(contentsOfFile: destinationPath)
                images?.append(img!)
            }
            
        }
        
        return images!
        
    }
	
	func categoryName() -> String {
		return category!.name;
	}
	
    class private func selectFromHotspots(query:String?) -> [Hotspot] {
        var queryString: String!
        
        if let query = query {
            queryString = String(format:"%@ %@", dataRequestString(), query)
        } else {
            queryString = dataRequestString()
        }
        
        let array = convertArray(sendRequest(queryString, converter: { (sqlite3_stmt stmt) -> AnyObject! in
            return self.itemWithSqlite3_stmt(stmt);
        }));
        return array
    }
    
	class private func dataRequestString() -> String {
		return "SELECT id, name, description, category, is_primary, lat, lng, updated_at, phone, site, address FROM hotspots"
	}
	
	class func hotspotById(id: UInt) -> Hotspot {
        let array = selectFromHotspots(String(format:"WHERE id = %d", id))
		
		return array[0];
	}
    
    class func lastUpdateDate() -> NSDate {
        var lastUpdateDate: NSDate? = nil
        
        let array = selectFromHotspots("order by updated_at desc limit 1")
        
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
            array = FavouritesManager.sharedManager().allFavourites() as! [Hotspot]
        } else {
            let categoryString = category.name.lowercaseString
            array = selectFromHotspots(String(format: "WHERE category = \"%@\"", categoryString))
        }
        
		for item in array {
			item.category = category;
		}
		
		return array;
	}
	
	class func allHotspots() -> [Hotspot] {
		return selectFromHotspots(nil)
	}
	
	class private func convertArray(array: NSArray) -> [Hotspot] {
		var hotspots: [Hotspot] = [];
		for item in array {
			hotspots.append(item as! Hotspot);
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

        var is_primary_str: String? = String.fromCString(UnsafePointer <Int8> (sqlite3_column_text(stmt, CInt(4))))
        item.isPrimary = is_primary_str == "f" ? false : true
        
        item.lat = sqlite3_column_double(stmt, CInt(5))
        item.lon = sqlite3_column_double(stmt, CInt(6))
        if let dateString = String.fromCString(UnsafePointer <Int8> (sqlite3_column_text(stmt, CInt(7)))) {
            var dateFormatter: NSDateFormatter = NSDateFormatter()
            var format:NSString = "YYYY-MM-dd HH:mm:ss"
            dateFormatter.dateFormat = format as String
            var dateStr = dateString as NSString
            dateStr = dateStr.substringToIndex(format.length)
            NSLog("date str: %@", dateStr)
            item.lastUpdated = dateFormatter.dateFromString(dateStr as String)
        }
        item.phone = String.fromCString(UnsafePointer <Int8> (sqlite3_column_text(stmt, CInt(8))))
        item.site = String.fromCString(UnsafePointer <Int8> (sqlite3_column_text(stmt, CInt(9))))
        item.address = String.fromCString(UnsafePointer <Int8> (sqlite3_column_text(stmt, CInt(10))))
		
        
        
		return item;
	}
}