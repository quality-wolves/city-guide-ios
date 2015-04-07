//
//  HeaderViewCell.m
//  CityGuide
//
//  Created by Vladislav Zozulyak on 11.03.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import "HeaderViewCell.h"
#import "CityGuide-Swift.h"

@implementation HeaderViewCell

- (void) setCategory: (CGCategory *) category {
    self.titleLabel.text = [category fullDescription];
    self.titleLabel.font = [self.titleLabel.font fontWithSize:10.66f];
    self.imageView.image = [UIImage imageNamed:[category imageFileName]];
}

@end
