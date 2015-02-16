//
//  HotspotAnnotation.m
//  CityGuide
//
//  Created by Vladislav Zozulyak on 17.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import "HotspotAnnotation.h"


@implementation HotspotAnnotation

- (id) initWithCoordinate: (CLLocationCoordinate2D) coord title: (NSString *) title {
    if (self = [super init]) {
        _coordinate = coord;
        _title = title;
    }
    return self;
}

- (id) initWithHotspot: (Hotspot *) h {
    if (self = [self initWithCoordinate:CLLocationCoordinate2DMake(h.lat, h.lon) title:h.name]) {
        self.hotspot = h;
    }
    return self;
}

@end
