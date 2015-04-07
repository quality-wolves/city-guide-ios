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

@protocol HotspotDetailsDelegate;

@interface HotspotDetailsCell : UICollectionViewCell<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) NSObject<HotspotDetailsDelegate> *delegate;
@property (nonatomic, strong) Hotspot *hotspot;
@end

@protocol HotspotDetailsDelegate

- (void) hotspotDetailCell: (HotspotDetailsCell *) cell openHotspotMap: (Hotspot *) hotspot;
- (void) hotspotDetailCell: (HotspotDetailsCell *) cell betterCallHotspot: (Hotspot *) hotspot;
- (void) hotspotDetailCell: (HotspotDetailsCell *) cell openHotspotSite: (Hotspot *) hotspot;

@end