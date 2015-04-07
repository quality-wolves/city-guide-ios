//
//  AMFileRequest.h
//  AMToolkit
//
//  Created by Anton Kaizer on 18.03.13.
//  Copyright (c) 2013 Arello Mobile. All rights reserved.
//

#import "AMServiceRequest.h"

@interface AMFileRequest : AMServiceRequest

@property (nonatomic) BOOL isUpload;

//if filePath returns nil, all data should be here
@property (nonatomic, strong) NSData *fileData;
@property (nonatomic, strong) NSString *fileName;

- (NSString *) formFileField;
- (NSString *) filePath;

@end
