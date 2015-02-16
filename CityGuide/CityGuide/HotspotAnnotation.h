//
//  HotspotAnnotation.h
//  CityGuide
//
//  Created by Vladislav Zozulyak on 17.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CityGuide-Swift.h"

@interface HotspotAnnotation : NSObject<MKAnnotation>

// Center latitude and longitude of the annotation view.
// The implementation of this property must be KVO compliant.
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

// Title and subtitle for use by selection UI.
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (strong, nonatomic) Hotspot *hotspot;


- (id) initWithCoordinate: (CLLocationCoordinate2D) coord title: (NSString *) title;
- (id) initWithHotspot: (Hotspot *) hotspot;

//// Called as a result of dragging an annotation view.
//- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate NS_AVAILABLE(10_9, 4_0);


@end
