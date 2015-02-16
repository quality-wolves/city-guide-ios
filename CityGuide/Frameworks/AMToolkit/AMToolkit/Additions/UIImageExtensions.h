/*
 * Arello Mobile
 * Mobile Framework
 * Except where otherwise noted, this work is licensed under a Creative Commons Attribution 3.0 Unported License
 * http://creativecommons.org/licenses/by/3.0
 */

#import <Foundation/Foundation.h>


@interface UIImage(CFImageExtensions)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

- (UIImage*)imageFromRect:(CGRect) rect;

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees ;

@end
