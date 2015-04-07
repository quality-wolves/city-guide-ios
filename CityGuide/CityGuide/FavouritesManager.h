//
//  FavouritesManager.h
//  CityGuide
//
//  Created by Vladislav Zozulyak on 05.03.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Hotspot;

@interface FavouritesManager : NSObject

- (void) addFavouriteHotspot: (Hotspot *) hotspot;
- (void) removeHotspotFromFavourites: (Hotspot *) hotspot;
- (BOOL) isFavourite: (Hotspot *) hotspot;
- (NSArray *) allFavourites;

+ (FavouritesManager *) sharedManager;

@end
