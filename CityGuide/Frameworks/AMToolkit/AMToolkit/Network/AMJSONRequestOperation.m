//
//  AMJSONRequestOperation.m
//  PullToRefreshSample
//
//  Created by Anton Kaizer on 11.02.13.
//  Copyright (c) 2013 Arello Mobile. All rights reserved.
//

#import "AMJSONRequestOperation.h"
#import "AMHTTPStatusCodes.h"
#import "NSDictionary+Validation.h"
#import "NSString+Additions.h"

@interface AMJSONRequestOperation ()

@property (nonatomic, strong) NSError *contentTypeError;

@end

@implementation AMJSONRequestOperation

#pragma mark - AFHTTPRequestOperation

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	if ([response isKindOfClass:[NSHTTPURLResponse class]] ) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        [super performSelector:@selector(setResponse:) withObject:response];
#pragma clang diagnostic pop
		if ([self hasAcceptableContentType]) {
			[super connection:connection didReceiveResponse:response];
		} else {
			NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
			[userInfo setValue:[NSString stringWithFormat:NSLocalizedString(@"Expected content type %@, got %@", nil), [[self class] acceptableContentTypes], [self.response MIMEType]] forKey:NSLocalizedDescriptionKey];
			self.contentTypeError = [[NSError alloc] initWithDomain:AFNetworkingErrorDomain code:NSURLErrorCannotDecodeContentData userInfo:userInfo];
			[connection cancel];
			[super connectionDidFinishLoading:connection];
        }
	}
}

- (NSError *) error {
	if (self.contentTypeError)
		return self.contentTypeError;
	else
		return [super error];
}

@end
