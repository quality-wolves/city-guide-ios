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

- (void) setCategory: (CGCategory *) category {
    self.titleLabel.text = [category fullDescription];
    self.imageView.image = [UIImage imageNamed:[category imageFileName]];
}

@end
