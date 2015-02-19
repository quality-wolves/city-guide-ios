//
//  HotspotsDetailsViewController.h
//  CityGuide
//
//  Created by Vladislav Zozulyak on 20.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityGuide-swift.h"

@interface HotspotsDetailsViewController : UIViewController

@property (strong, nonatomic) Hotspot *hotspot;
- (id) initWithHotspot: (Hotspot *) hotspot;

@end