//
//  HotspotAnnotationView.m
//  CityGuide
//
//  Created by Vladislav Zozulyak on 17.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import "HotspotAnnotationView.h"

@implementation HotspotAnnotationView

- (id) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        if ([annotation isKindOfClass:[HotspotAnnotation class]]) {
            HotspotAnnotation *ha = (HotspotAnnotation *) annotation;
            self.image = [UIImage imageNamed:[ha.hotspot categoryImageName]];
        }
    }
    return self;
}

@end
