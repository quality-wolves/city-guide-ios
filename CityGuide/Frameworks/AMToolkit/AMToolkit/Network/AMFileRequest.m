//
//  AMFileRequest.m
//  AMToolkit
//
//  Created by Anton Kaizer on 18.03.13.
//  Copyright (c) 2013 Arello Mobile. All rights reserved.
//

#import "AMFileRequest.h"

@implementation AMFileRequest

- (NSString *) filePath {
	return nil;
}

- (NSString *) acceptableContentType {
	return self.isUpload ? [super acceptableContentType] : nil;
}

- (NSString *) formFileField {
	return @"data[file]";
}

@end
