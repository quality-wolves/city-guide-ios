//
//  ZipArchiveDelegateHelper.h
//  CityGuide
//
//  Created by Chudin Yuriy on 16.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSZipArchive/SSZipArchive.h"

@interface ZipArchiveDelegateHelper: NSObject <SSZipArchiveDelegate>

- (instancetype) initWithCompletionHandler: (void(^)()) handler;

@end