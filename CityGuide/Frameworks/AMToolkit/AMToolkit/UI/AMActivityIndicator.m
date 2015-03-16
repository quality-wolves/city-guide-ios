//
//  PHActivityIndicator.m
//
//  Created by Anton Kaizer on 30.09.11.
//

#import "AMActivityIndicator.h"
#import <QuartzCore/QuartzCore.h>

#define kAnimationKey @"kActivityRotation"

@implementation AMActivityIndicator

- (id) initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self internalInitialization];
	}
	return self;
}

- (void) awakeFromNib {
	[super awakeFromNib];
	[self internalInitialization];
}

- (void) internalInitialization {
	if (self.stepsCount == 0)
		self.stepsCount = 8;
	[self startAnimating];
}

- (void) startAnimating {
	[self stopAnimating];
	if (self.stepsCount != -1 && self.stepsCount != 0 ) {
		CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
		anim.calculationMode = kCAAnimationDiscrete;
		NSMutableArray *keyTimesArray = [NSMutableArray arrayWithCapacity:self.stepsCount + 1];
		NSMutableArray *keyValuesArray = [NSMutableArray arrayWithCapacity:self.stepsCount + 2];
		for (NSInteger i=0; i < self.stepsCount + 1; ++i) {
			[keyTimesArray addObject:@(i*1./self.stepsCount)];
			[keyValuesArray addObject:@(i * 2 * M_PI/self.stepsCount)];
		}
		[keyValuesArray addObject:keyValuesArray[0]];
		anim.keyTimes = [keyTimesArray copy];
		anim.repeatCount = INFINITY;
		anim.removedOnCompletion = NO;
		anim.values = [keyValuesArray copy];
		anim.duration = 0.8;
		[self.layer addAnimation:anim forKey:kAnimationKey];
	} else {
		CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
		anim.fromValue = [NSNumber numberWithDouble:0.0];
		anim.toValue = [NSNumber numberWithDouble:M_PI * 2];
		anim.duration = 0.8;
		anim.removedOnCompletion = NO;
		anim.repeatCount = INFINITY;
		[self.layer addAnimation:anim forKey:kAnimationKey];
	}
}

- (void) stopAnimating {
	[self.layer removeAnimationForKey:kAnimationKey];
}

@end
