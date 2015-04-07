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


- (NSString *) formatHotspotLastUpdateDate {
    return [[[Hotspot lastUpdateDate] stringValueWithFormat:@"YYYY-MM-dd HH:mm:ss"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void) checkForUpdateWithCompletition: (CompletionHandler) completionHandler {    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSString *urlString = [NSString stringWithFormat:@"%@/is_updated/%@.json", SERVER_URL, [self formatHotspotLastUpdateDate]];
        NSURL *url = [NSURL URLWithString:urlString];
        NSLog(@"Url: %@", url);
        
        BOOL hasUpdates = NO;
        
        NSError *error = nil;
        NSString *response = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        
        if (error) {
            NSLog(@"Request has failed with error: %@", error);
        } else {
            NSData *responseData = [response dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            if ([json objectForKey:@"count"]) {
                NSInteger updatesCount = [[json objectForKey:@"count"] intValue];
                if (updatesCount > 0) {
                    hasUpdates = YES;
                }
            }
        }
        
        if (completionHandler)
            dispatch_async(dispatch_get_main_queue(), ^() {
                completionHandler(hasUpdates);
            });
    });
}

- (void) updateWithCompletition: (CompletionHandler) completionHandler {
    NSString *databaseUrl = [NSString stringWithFormat:@"%@/get_database", SERVER_URL];
    NSString *attachementsUrl = [NSString stringWithFormat:@"%@/get_attachments_that_has_loaded_after/%@", SERVER_URL, [self formatHotspotLastUpdateDate]];
    
    [[DataManager instance] downloadAndUnzip:databaseUrl completionHandler:^() {
        [[DataManager instance] downloadAndUnzip:attachementsUrl completionHandler:^() {
            if (completionHandler) {
                dispatch_async(dispatch_get_main_queue(), ^() {
                    completionHandler(YES);
                });
            }
        }];
    }];
    

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

- (UIImage*) documentsImage: (NSString *) imageFileName {
    NSString *path = [NSString stringWithFormat: @"%@/%@", [self documentsDirectory], imageFileName];
    NSLog(@"Path: %@", path);
    return [UIImage imageWithContentsOfFile: path];
}

- (UIImage*) imageByHotspot: (Hotspot*) hotspot {
	NSString *path = [NSString stringWithFormat: @"%@/%@", [self documentsDirectory], hotspot.imageFileName];
    NSLog(@"Path: %@", path);
	return [UIImage imageWithContentsOfFile: path];
}

- (NSString*) documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

#pragma mark - Privates

- (void) downloadAndUnzip: (NSString *) urlPath completionHandler: (void(^)()) completionHandler;
{
    NSLog(@"Download and unzip from %@", urlPath);
	dispatch_queue_t q = dispatch_get_global_queue(0, 0);
	dispatch_queue_t main = dispatch_get_main_queue();
	dispatch_async(q, ^{
		//Path info
		NSURL *url = [NSURL URLWithString:urlPath];
		NSData *data = [NSData dataWithContentsOfURL:url];
        if (data == nil) {
            NSLog(@"Data is nil");
        }
		NSString *fileName = [[url path] lastPathComponent];
		NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        NSLog(@"File path: %@", filePath);
		[data writeToFile:filePath atomically:YES];
		dispatch_async(main, ^ {
			ZipArchiveDelegateHelper *helper = [[ZipArchiveDelegateHelper alloc] initWithCompletionHandler: completionHandler];
			[SSZipArchive unzipFileAtPath:filePath toDestination: [self documentsDirectory] delegate: helper];
		});
	});
}

@end