//
//  AMStretchableButton.m
//  AMToolkit
//
//  Created by Alexey Bromot on 08.02.13.
//  Copyright (c) 2013 Alexey Bromot. All rights reserved.
//

#import "AMStretchableButton.h"
#import <QuartzCore/QuartzCore.h>

@interface AMStretchableButton ()

@property (nonatomic, strong) NSMutableDictionary *imagesForStates;

@end

@implementation AMStretchableButton

- (id) initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.imagesForStates = [NSMutableDictionary dictionary];
	}
	return self;
}

- (void) awakeFromNib {
	[super awakeFromNib];
	self.imagesForStates = [NSMutableDictionary dictionary];
	UIImage *imageNormalState = [self backgroundImageForState:UIControlStateNormal];
	
	if (imageNormalState)
		[self setBackgroundImage:imageNormalState forState:UIControlStateNormal];
	
	imageNormalState = [self backgroundImageForState:UIControlStateNormal];
	
	UIImage *imageHighlightedState = [self backgroundImageForState:UIControlStateHighlighted];
	
	if (imageNormalState != imageHighlightedState) {
		[self setBackgroundImage:imageHighlightedState forState:UIControlStateHighlighted];
	}
	
	UIImage *imageDisabledState = [self backgroundImageForState:UIControlStateDisabled];
	
	if (imageNormalState != imageDisabledState) {
		[self setBackgroundImage:imageDisabledState forState:UIControlStateDisabled];
	}
	
	UIImage *imageSelectedState = [self backgroundImageForState:UIControlStateSelected];
	
	if (imageNormalState != imageSelectedState) {
		[self setBackgroundImage:imageSelectedState forState:UIControlStateSelected];
	}
}

- (void) setBackgroundImage:(UIImage *)image forState:(UIControlState)state {
	if (image != nil) {
		[self.imagesForStates setObject:image forKey:@(state)];
		[super setBackgroundImage:[self stretchedImageWithImage:image] forState:state];
	} else {
		[self.imagesForStates removeObjectForKey:@(state)];
		[super setBackgroundImage:nil forState:state];
	}
	
}

- (UIImage *) stretchedImageWithImage:(UIImage *) image {
	UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
	imageView.contentStretch = self.contentStretch;
	imageView.contentMode = self.contentMode;
	imageView.frame = self.bounds;
	
	UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, image.scale);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	[imageView.layer renderInContext:ctx];
	UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return result;
}

- (void) updateImages {
	for (NSNumber *key in [self.imagesForStates allKeys]) {
		UIImage *image = [self.imagesForStates objectForKey:key];
		[self setBackgroundImage:image forState:[key integerValue]];
	}
}

- (void) setFrame:(CGRect)frame {
	BOOL shouldUpdateImages = !CGSizeEqualToSize(self.frame.size, frame.size);
	[super setFrame:frame];
	if (shouldUpdateImages)
		[self updateImages];
}

@end