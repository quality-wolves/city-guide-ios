//
//  HotspotSmallCell.m
//  CityGuide
//
//  Created by Vladislav Zozulyak on 14.03.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import "HotspotSmallCell.h"
#import "CityGuide-Swift.h"


@implementation HotspotSmallCell

- (void) setHotspot: (Hotspot *) hotspot {
    self.titleLabel.text = [[hotspot name] uppercaseString];
    self.backgroundImage.image = [[DataManager instance] imageByHotspot: hotspot];
}

@end
