//
//  WhatsonCollectionViewController.m
//  CityGuide
//
//  Created by Tikhon Polyakov on 23.04.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import "WhatsonCollectionViewController.h"
#import "CityGuide-Swift.h"
@interface WhatsonCollectionViewController ()
@end

@implementation WhatsonCollectionViewController


- (id) init {
    if (self = [super init]) {
        self.hotspots = [Hotspot hotspotsByCategory:[CGCategory allCategories][0]];
    }
    return self;
}

@end
