//
//  DataManager.m
//  CityGuide
//
//  Created by Chudin Yuriy on 16.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import "DataManager.h"
#import "SSZipArchive/SSZipArchive.h"

#import "CityGuide-Swift.h"

@interface DataManager () <SSZipArchiveDelegate>

@end

@implementation DataManager

+ (instancetype) instance {
	static DataManager *manager = nil;
	if(manager)
		return manager;
	
	return manager = [DataManager new];
}

- (instancetype) init {
	if(self = [super init]) {
		[self unzipImages: @"thumbnails.zip"];
	}
	
	return self;
}

- (NSString*) documentsDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

- (void) unzipImages: (NSString*) zipPath {
	NSString *outputPath = [self documentsDirectory];
	
	zipPath = [[NSBundle mainBundle] pathForResource:@"thumbnails" ofType: @"zip"];
	
	NSLog(@"Unzip images to folder: %@", outputPath);
	[SSZipArchive unzipFileAtPath: zipPath toDestination:outputPath delegate:self];
}

- (UIImage*) imageByHotspot: (Hotspot*) hotspot {
	NSString *path = [NSString stringWithFormat: @"%@/%@", [self documentsDirectory], hotspot.imageFileName];
	return [UIImage imageWithContentsOfFile: path];
}

#pragma mark - Unzip Delegate

- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPath {
	NSLog(@"zipArchiveDidUnzipArchiveAtPath: %@", path);
}

@end