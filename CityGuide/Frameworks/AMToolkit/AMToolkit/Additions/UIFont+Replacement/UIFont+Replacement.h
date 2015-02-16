//
//  UIFont+Replacement.h
//  FontReplacer
//
//  Copyright (c) 2011 Cédric Luthi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Replacement)

+ (NSDictionary *) replacementDictionary;
+ (void) setReplacementDictionary:(NSDictionary *)aReplacementDictionary;

@end
