//
//  DataManager.h
//  CityGuide
//
//  Created by Chudin Yuriy on 16.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SERVER_URL @"http://admin%40cityguide.com:12345678@cityguide.fuk-yeah.com/"

@class Hotspot;
typedef void (^CompletionHandler)(BOOL);


@interface DataManager : NSObject

+ (instancetype) instance;

- (void) downloadImages: (void(^)()) completionHandler;
- (void) downloadAndUnzip: (NSString*) urlPath completionHandler: (void(^)()) completionHandler;
- (UIImage*) imageByHotspot: (Hotspot*) hotspot;
- (UIImage*) documentsImage: (NSString *) imageFileName;
- (NSString*) documentsDirectory;

- (void) checkForUpdateWithCompletition: (CompletionHandler) completionHandler;
- (void) updateWithCompletition: (CompletionHandler) completionHandler;

@end