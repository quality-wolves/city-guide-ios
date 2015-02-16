//
//  HotspotDetailsCell.h
//  CityGuide
//
//  Created by Chudin Yuriy on 17.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Hotspot;

@interface HotspotDetailsCell : UICollectionViewCell

@property (nonatomic, copy) Hotspot *hotspot;

@end