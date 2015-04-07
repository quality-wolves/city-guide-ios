//
//  Category.swift
//  CityGuide
//
//  Created by Chudin Yuriy on 15.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

import Foundation

enum CategoryEnum: UInt {
	case Stay = 0
	case Eat, Buy, Drink, See, Do, Favourites, Map, Whatson, DayInBarcelona, BasicInformation, Soundtrack

//	func description() -> String {
//		switch self {
//		case .Stay:
//			return "Stay"
//		case .Eat:
//			return "Eat"
//		case .Buy:
//			return "Buy"
//		case .Drink:
//			return "Drink"
//		case .See:
//			return "See"
//		case .Do:
//			return "Do"
//		case .Favourites:
//			return "Favourites"
//		case .Map:
//			return "Map"
//		case .Whatson:
//			return "Whatson"
//		case .Soundtrack:
//			return "Soundtrack"
//		default:
//			return String(self.rawValue)
//		}
//	}
}

class CGCategory: NSObject {
	var id: CategoryEnum = CategoryEnum.Stay
	var name: String!
	
	init(id: CategoryEnum, name: String) {
		self.id = id
		self.name = name
	}
    
    func mapiconFileName() -> String {
        switch id {
        case .Stay: return "map_stay.png"
        case .Eat: return "map_eat.png"
        case .Buy: return "map_buy.png"
        case .Drink: return "map_drink.png"
        case .See: return "map_see.png"
        case .Do: return "map_do.png"
        default: return ""
        }
    }
	
	func imageFileName() -> String {
		switch id {
        case .Stay: return "Menu2 2"
        case .Eat: return "Salero"
        case .Buy: return "BARCELONA-BUY 5"
        case .Drink: return "Drink-1 2"
        case .See: return "See 2"
        case .Do: return "Cine"
        case .Favourites: return "favourites-menu"
        case .Map: return "map-menu"
        case .Whatson: return "whatson-menu"
        case .DayInBarcelona: return "dayin-menu"
        case .BasicInformation: return "basicinformation-menu"
        case .Soundtrack: return "soundtrack-menu"
		}
	}
    
    func fullDescription() -> String {
        return self.name.uppercaseString + ": " + "DISCOVER ALL THE COOL PLACES TO STAY DURING YOUR TRIP TO BARCELONA"
    }
	
    class func categoryByName(name: String) -> CGCategory? {
        var categories = CGCategory.allCategories()
        for c in categories {
            if c.name.lowercaseString == name.lowercaseString {
                return c
            }
        }
        return nil
    }
    
    class func allHotspotCategories() -> [CGCategory] {
        return [CGCategory(id: CategoryEnum.Stay, name: "Stay"),
            CGCategory(id: CategoryEnum.Eat, name: "Eat"),
            CGCategory(id: CategoryEnum.Buy, name: "Buy"),
            CGCategory(id: CategoryEnum.Drink, name: "Drink"),
            CGCategory(id: CategoryEnum.See, name: "See"),
            CGCategory(id: CategoryEnum.Do, name: "Do")];
    }
    
	class func allCategories() -> [CGCategory] {
		return [CGCategory(id: CategoryEnum.Stay, name: "Stay"),
				CGCategory(id: CategoryEnum.Eat, name: "Eat"),
				CGCategory(id: CategoryEnum.Buy, name: "Buy"),
				CGCategory(id: CategoryEnum.Drink, name: "Drink"),
				CGCategory(id: CategoryEnum.See, name: "See"),
				CGCategory(id: CategoryEnum.Do, name: "Do"),
				CGCategory(id: CategoryEnum.Favourites, name: "Favourites"),
				CGCategory(id: CategoryEnum.Map, name: "Map"),
				CGCategory(id: CategoryEnum.Whatson, name: "What's on"),
                CGCategory(id: CategoryEnum.DayInBarcelona, name: "A day in Barcelona"),
                CGCategory(id: CategoryEnum.BasicInformation, name: "Basic Information"),
				CGCategory(id: CategoryEnum.Soundtrack, name: "Soundtrack")];
	}
    
    class func allCategoriesExceptHotspots() -> [CGCategory] {
        return [
        CGCategory(id: CategoryEnum.Favourites, name: "Favourites"),
        CGCategory(id: CategoryEnum.Map, name: "Map"),
        CGCategory(id: CategoryEnum.Whatson, name: "What's on"),
        CGCategory(id: CategoryEnum.DayInBarcelona, name: "A day in Barcelona"),
        CGCategory(id: CategoryEnum.BasicInformation, name: "Basic Information"),
        CGCategory(id: CategoryEnum.Soundtrack, name: "Soundtrack")];
    }
}