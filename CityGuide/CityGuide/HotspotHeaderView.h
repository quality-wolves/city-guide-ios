//
//  HeaderViewCell.h
//  CityGuide
//
//  Created by Vladislav Zozulyak on 11.03.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Hotspot;

@interface HotspotHeaderView : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void) setHotspot: (Hotspot *) hotspot;

@end
