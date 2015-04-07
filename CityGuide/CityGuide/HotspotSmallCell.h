//
//  HotspotSmallCell.h
//  CityGuide
//
//  Created by Vladislav Zozulyak on 14.03.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Hotspot;
@interface HotspotSmallCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

- (void) setHotspot: (Hotspot *) hotspot;

@end
