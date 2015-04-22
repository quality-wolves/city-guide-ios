//
//  HotspotCollectionViewController.h
//  CityGuide
//
//  Created by Vladislav Zozulyak on 13.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import "HAPaperCollectionViewController.h"

@interface HotspotCollectionViewController : UIViewController
@property (nonatomic, strong) NSArray *hotspots;
- (id) initWithHotspots: (NSArray*) hotspots;

@end