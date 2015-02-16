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
	case Eat, Buy, Drink, See, Do, Favourites, Map, Whatson, Soundtrack

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

class Category {
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
		case .Buy, .Favourites: return "BARCELONA-BUY 5"
		case .Drink, .Map: return "Drink-1 2"
		case .See, .Whatson: return "See 2"
		case .Do, .Soundtrack: return "Cine"
		}
	}
	
    class func categoryByName(name: String) -> Category? {
        var categories = Category.allCategories()
        for c in categories {
            if c.name.lowercaseString == name.lowercaseString {
                return c
            }
        }
        return nil
    }
    
	class func allCategories() -> [Category] {
		return [Category(id: CategoryEnum.Stay, name: "Stay"),
				Category(id: CategoryEnum.Eat, name: "Eat"),
				Category(id: CategoryEnum.Buy, name: "Buy"),
				Category(id: CategoryEnum.Drink, name: "Drink"),
				Category(id: CategoryEnum.See, name: "See"),
				Category(id: CategoryEnum.Do, name: "Do"),
				Category(id: CategoryEnum.Favourites, name: "Favourites"),
				Category(id: CategoryEnum.Map, name: "Map"),
				Category(id: CategoryEnum.Whatson, name: "Whatson"),
				Category(id: CategoryEnum.Soundtrack, name: "Soundtrack")];
	}
}