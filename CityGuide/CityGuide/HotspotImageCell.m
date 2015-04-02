//
//  HotspotImageCell.m
//  CityGuide
//
//  Created by Tikhon Polyakov on 02.04.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import "HotspotImageCell.h"
#import "CityGuide-Swift.h"

@implementation HotspotImageCell

- (void) setImage: (Hotspot *) hotspot atIndex: (NSInteger) index {
    self.imageView.image = [[DataManager instance] imageByHotspot:hotspot];
}

@end
