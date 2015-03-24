//
//  DataManager.m
//  CityGuide
//
//  Created by Chudin Yuriy on 16.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import "DataManager.h"
#import "ZipArchiveDelegateHelper.h"
#import "SSZipArchive/SSZipArchive.h"

#import "CityGuide-Swift.h"


@interface DataManager ()

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
	}
	
	return self;
}

- (void) downloadDatabase:(NSString *) urlPath completionHandler: (void (^)()) completionHandler {
    dispatch_queue_t q = dispatch_get_global_queue(0,0);
    
    dispatch_async(q, ^{
        NSURL *url = [NSURL URLWithString:urlPath];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSLog(@"%@", data);
        // NSString *fileName = [[url path] lastPathComponent];
        NSString *filePath = [self documentsDirectory];
        [data writeToFile:filePath atomically:YES];
    });
}

- (void) downloadImages: (void(^)()) completionHandler {
	NSString *zipPath = [[NSBundle mainBundle] pathForResource:@"thumbnails" ofType: @"zip"];
	NSString *outputPath = [self documentsDirectory];
	
	NSLog(@"Unzip images to folder: %@", outputPath);
	ZipArchiveDelegateHelper *helper = [[ZipArchiveDelegateHelper alloc] initWithCompletionHandler: completionHandler];
	[SSZipArchive unzipFileAtPath: zipPath toDestination:outputPath delegate: helper];
}

- (UIImage*) imageByHotspot: (Hotspot*) hotspot {
	NSString *path = [NSString stringWithFormat: @"%@/%@", [self documentsDirectory], hotspot.imageFileName];
	return [UIImage imageWithContentsOfFile: path];
}

- (NSString*) documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

#pragma mark - Privates

- (void) downloadAndUnzip: (NSString *) urlPath completionHandler: (void(^)()) completionHandler;
{
	dispatch_queue_t q = dispatch_get_global_queue(0, 0);
	dispatch_queue_t main = dispatch_get_main_queue();
	dispatch_async(q, ^{
		//Path info
		NSURL *url = [NSURL URLWithString:urlPath];
		NSData *data = [NSData dataWithContentsOfURL:url];
		NSString *fileName = [[url path] lastPathComponent];
		NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
		[data writeToFile:filePath atomically:YES];
		dispatch_async(main, ^ {
			ZipArchiveDelegateHelper *helper = [[ZipArchiveDelegateHelper alloc] initWithCompletionHandler: completionHandler];
			[SSZipArchive unzipFileAtPath:filePath toDestination: [self documentsDirectory] delegate: helper];
		});
	});
}

@end