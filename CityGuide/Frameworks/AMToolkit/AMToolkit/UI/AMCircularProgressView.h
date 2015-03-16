/*
 * Arello Mobile
 * Mobile Framework
 * Except where otherwise noted, this work is licensed under a Creative Commons Attribution 3.0 Unported License
 * http://creativecommons.org/licenses/by/3.0
 */

#import <UIKit/UIKit.h>


@interface AMCircularProgressView : UIView {
	UIActivityIndicatorView *activityIndicator;
	UIColor *inactiveColor;
	UIColor *activeColor;
	UIColor *shadowColor;
	
	BOOL hidesWhenStopped;
	float progress;
}

- (void) startAnimating;
- (void) stopAnimating;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIColor *inactiveColor;
@property (nonatomic, strong) UIColor *activeColor;
@property (nonatomic, strong) UIColor *shadowColor;

@property (nonatomic) BOOL hidesWhenStopped;
@property (nonatomic) float progress;

@end
