//
//  FavouritesManager.m
//  CityGuide
//
//  Created by Vladislav Zozulyak on 05.03.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import "FavouritesManager.h"

#define FAVOURITES_IDS_STORE_KEY @"FAVOURITES_IDS_STORE_KEY"
@interface FavouritesManager()

@property (strong, nonatomic) NSMutableArray *favoritesIds;
@property (strong, nonatomic) NSMutableArray *favourites;

@end

@implementation FavouritesManager

- (id) init {
    if (self = [super init]) {
        [self load];
    }
    return self;
}

- (void) save {
    [[NSUserDefaults standardUserDefaults] setObject:_favoritesIds forKey:FAVOURITES_IDS_STORE_KEY];
}

- (BOOL) isFavourite: (Hotspot *) hotspot {
    NSNumber *idNumber = [NSNumber numberWithUnsignedInteger:[hotspot id]];
    if ([_favoritesIds indexOfObject:idNumber] == NSNotFound) {
        return NO;
    }
    return YES;
}

- (void) load {
    NSArray *storedIds = [[NSUserDefaults standardUserDefaults] objectForKey:FAVOURITES_IDS_STORE_KEY];

    if (!storedIds) {
        self.favoritesIds = [NSMutableArray new];
        self.favourites = [NSMutableArray new];
        return;
    }
    
    NSMutableArray *result = [NSMutableArray new];
    
    for (NSNumber *hId in storedIds) {
        [result addObject:[Hotspot hotspotById:hId.unsignedIntegerValue]];
    }
    
    self.favoritesIds = [storedIds mutableCopy];
    self.favourites = result;
}

- (void) addFavouriteHotspot: (Hotspot *) hotspot {
    NSNumber *idNumber = [NSNumber numberWithUnsignedInteger:[hotspot id]];
    if ([_favoritesIds indexOfObject:idNumber] == NSNotFound) {
        [_favoritesIds addObject:idNumber];
        [_favourites addObject:hotspot];
        [self save];
    }
    
}

- (void) removeHotspotFromFavourites: (Hotspot *) hotspot {
    NSNumber *idNumber = [NSNumber numberWithUnsignedInteger:[hotspot id]];
//    if ([_favoritesIds indexOfObject:idNumber] == NSNotFound) {
    [_favoritesIds removeObject:idNumber];
    [_favourites removeObject:hotspot];
//    }
}

- (NSArray *) allFavourites {
    return _favourites;
}

+ (FavouritesManager *) sharedManager {
    static FavouritesManager *instance;
    if (!instance)
        instance = [FavouritesManager new];
    
    return instance;
}

@end
