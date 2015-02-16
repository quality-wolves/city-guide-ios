//
//  DataManager.h
//  CityGuide
//
//  Created by Chudin Yuriy on 16.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Hotspot;

@interface DataManager : NSObject

+ (instancetype) instance;

- (void) downloadImages: (void(^)()) completionHandler;
- (UIImage*) imageByHotspot: (Hotspot*) hotspot;

@end