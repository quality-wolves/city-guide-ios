//
//  HotspotImageCell.h
//  CityGuide
//
//  Created by Tikhon Polyakov on 02.04.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityGuide-Swift.h"

@interface HotspotImageCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (void) setImage: (Hotspot *) hotspot atIndex: (NSInteger) index;

@end
