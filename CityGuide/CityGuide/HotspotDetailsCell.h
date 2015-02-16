//
//  HotspotDetailsCell.h
//  CityGuide
//
//  Created by Chudin Yuriy on 17.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Hotspot;
@class CollectionLayouts;

@interface HotspotDetailsCell : UICollectionViewCell

@property (nonatomic, strong) Hotspot *hotspot;
@property (nonatomic, strong) CollectionLayouts *collectionLayouts;

@end