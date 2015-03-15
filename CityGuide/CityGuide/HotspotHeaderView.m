//
//  HeaderViewCell.m
//  CityGuide
//
//  Created by Vladislav Zozulyak on 11.03.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import "HotspotHeaderView.h"
#import "CityGuide-Swift.h"

@implementation HotspotHeaderView

- (void) setHotspot: (Hotspot *) h {
    self.titleLabel.text = [[h desc] uppercaseString];
    self.imageView.image = [[DataManager instance] imageByHotspot:h];
}

@end
