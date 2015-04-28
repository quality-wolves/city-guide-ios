//
//  SoundtrackViewController.m
//  CityGuide
//
//  Created by Vladislav Zozulyak on 27.04.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import "SoundtrackViewController.h"
#import "CityGuide-Swift.h"
@implementation SoundtrackViewController

- (id) init {
    if (self = [super init]) {
        self.hotspots = [Hotspot hotspotsByCategory:[CGCategory allCategories][1]];
    }
    return self;
}

@end
