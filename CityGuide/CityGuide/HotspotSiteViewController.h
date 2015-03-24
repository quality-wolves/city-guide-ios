//
//  HotspotSiteViewController.h
//  CityGuide
//
//  Created by Vladislav Zozulyak on 25.03.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Hotspot;

@interface HotspotSiteViewController : UIViewController

@property (strong, nonatomic) Hotspot *hotspot;

- (id) initWithHotspot: (Hotspot *) hotspot;

@end
