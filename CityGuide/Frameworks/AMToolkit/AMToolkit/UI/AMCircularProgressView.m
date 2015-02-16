/*
 * Arello Mobile
 * Mobile Framework
 * Except where otherwise noted, this work is licensed under a Creative Commons Attribution 3.0 Unported License
 * http://creativecommons.org/licenses/by/3.0
 */

#import "AMCircularProgressView.h"

static inline float radians(double degrees) { return degrees * M_PI / 180.0; }


@implementation AMCircularProgressView

@synthesize activityIndicator;
@synthesize inactiveColor;
@synthesize activeColor;
@synthesize shadowColor;

@synthesize hidesWhenStopped;
@synthesize progress;


#pragma mark -
#pragma mark Construction / Destruction

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		frame.size.width = 34.0;
		frame.size.height = 34.0;
		self.frame = frame;
		
		self.inactiveColor = [UIColor whiteColor];
		self.activeColor = self.backgroundColor;
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
		
		activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(floorf(self.frame.size.width / 2.0 - 10.0), floorf(self.frame.size.height / 2.0 - 10.0), 20.0, 20.0)];
		activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
		activityIndicator.hidesWhenStopped = YES;
		
		[self addSubview:activityIndicator];
		
		hidesWhenStopped = YES;
		progress = 0.0;
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		CGRect frame = self.frame;
		frame.size.width = 34.0;
		frame.size.height = 34.0;
		self.frame = frame;
		
		self.inactiveColor = [UIColor colorWithWhite:1.0 alpha:0.5];
		self.activeColor = self.backgroundColor;
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
		
		activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(floorf(self.frame.size.width / 2.0 - 10.0), floorf(self.frame.size.height / 2.0 - 10.0), 20.0, 20.0)];
		activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
		activityIndicator.hidesWhenStopped = YES;
		
		[self addSubview:activityIndicator];
		
		hidesWhenStopped = YES;
		progress = 0.0;
	}
	return self;
}


#pragma mark -
#pragma mark Displaying

- (void) drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextClearRect(context, rect);
	
	if (shadowColor) {
		CGContextSetFillColorWithColor(context, [shadowColor CGColor]);
		CGContextFillEllipseInRect(context, CGRectMake(34.0 / 2 - 25.0 / 2, 34.0 / 2 - 25.0 / 2, 25.0, 25.0));
	}
	
	float angle = 360;
	float innerRadius = 12.5;
	float outerRadius = rect.size.width / 2.0;
	
	float initialX = 0;
	float initialY = 0;
	
	CGContextSetFillColorWithColor(context, [inactiveColor CGColor]);
	
	initialX = rect.size.width / 2.0 + innerRadius * cosf((float)radians((double)(360 * progress - 90)));
	initialY = rect.size.height / 2.0 + innerRadius * sinf((float)radians((double)(360 * progress - 90)));
	
	CGContextMoveToPoint(context, initialX, initialY);
	
	for (int i = 360 * progress - 90 + 1; i < angle - 90; i += 2) {
		float x = rect.size.width / 2.0 + innerRadius * cosf((float)radians((double)i));
		float y = rect.size.height / 2.0 + innerRadius * sinf((float)radians((double)i));
		CGContextAddLineToPoint(context, x, y);
	}
	
	for (int i = angle - 90 + 1; i > 360 * progress - 90; i -= 2) {
		float x = rect.size.width / 2.0 + outerRadius * cosf((float)radians((double)i));
		float y = rect.size.height / 2.0 + outerRadius * sinf((float)radians((double)i));
		CGContextAddLineToPoint(context, x, y);
	}
	
	CGContextMoveToPoint(context, initialX, initialY);
	CGContextClosePath(context);
	CGContextFillPath(context);
	
	angle = 360 * progress;
	
	CGContextSetFillColorWithColor(context, [activeColor CGColor]);
	
	initialX = rect.size.width / 2.0 + outerRadius * cosf((float)radians((double)(-90)));
	initialY = rect.size.height / 2.0 + outerRadius * sinf((float)radians((double)(-90)));
	
	CGContextMoveToPoint(context, initialX, initialY);
	
	for (int i = -90 + 1; i < angle - 90; i += 2) {
		float x = rect.size.width / 2.0 + innerRadius * cosf((float)radians((double)i));
		float y = rect.size.height / 2.0 + innerRadius * sinf((float)radians((double)i));
		CGContextAddLineToPoint(context, x, y);
	}
	for (int i = angle - 90 + 1; i > -90; i -= 2) {
		float x = rect.size.width / 2.0 + outerRadius * cosf((float)radians((double)i));
		float y = rect.size.height / 2.0 + outerRadius * sinf((float)radians((double)i));
		CGContextAddLineToPoint(context, x, y);
	}
	
	CGContextMoveToPoint(context, initialX, initialY);
	CGContextClosePath(context);
	CGContextFillPath(context);
}

#pragma mark -
#pragma mark Custom setters

- (void) setProgress:(float)aProgress {
	if (aProgress < 0.0)
		progress = 0.0;
	else if (aProgress > 1.0)
		progress = 1.0;
	else
		progress = aProgress;
	
	[self setNeedsDisplay];
}

#pragma mark -
#pragma mark Control Methods

- (void) startAnimating {
	if (hidesWhenStopped)
		self.hidden = NO;
	[activityIndicator startAnimating];
}

- (void) stopAnimating {
	if (hidesWhenStopped)
		self.hidden = YES;
	[activityIndicator stopAnimating];
}


@end
