//
//  ZipArchiveDelegateHelper.m
//  CityGuide
//
//  Created by Chudin Yuriy on 16.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import "ZipArchiveDelegateHelper.h"

@interface ZipArchiveDelegateHelper ()

@property (nonatomic, strong) void (^completionHandler)();

@end



@implementation ZipArchiveDelegateHelper

- (instancetype) initWithCompletionHandler: (void(^)()) handler {
	if(self = [super init]) {
		self.completionHandler = handler;
	}
	
	return self;
}

- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPath {
	NSLog(@"zipArchiveDidUnzipArchiveAtPath: %@", path);
	self.completionHandler();
}

- (void) dealloc {
	NSLog(@"ZipArchiveDelegateHelper deleted");
}

@end
