/*
 * Arello Mobile
 * Mobile Framework
 * Except where otherwise noted, this work is licensed under a Creative Commons Attribution 3.0 Unported License
 * http://creativecommons.org/licenses/by/3.0
 */

#import "BackgroundWorker.h"
#import <QuartzCore/QuartzCore.h>

@implementation BackgroundWorker

static BackgroundWorker* sharedWorker;
+(id) sharedWorker
{
	if (!sharedWorker)
		sharedWorker = [[self alloc] init];
	
	return sharedWorker;
}

-(UIView*) createLoadingViewWithRect:(CGRect) rect
{
	rect.origin.x = 0;
	rect.origin.y = 0;
	
	UIView* result = [[UIView alloc] initWithFrame:rect];
		
	result.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	UIColor* grayColor = [UIColor grayColor];
	grayColor = [grayColor colorWithAlphaComponent:0.4f];	
	result.backgroundColor = grayColor;
	
	UIActivityIndicatorView* activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[activityView startAnimating];
	
	activityView.center = CGPointMake(rect.size.width/2, rect.size.height/2);
	activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	[result addSubview:activityView];
	
		
	return result;
}

-(void) runSelectorInBackground:(SEL) selector target:(NSObject*) target object:(NSObject*) object showLoading:(BOOL) showLoading;
{
	UIView* inView = nil;
	
	if (showLoading)
		inView = [UIApplication sharedApplication].delegate.window;
	
	[self runSelectorInBackground:selector target:target object:object showLoadingInView:inView];

}
-(void) runSelectorInBackground:(SEL) selector target:(NSObject*) target object:(NSObject*) object showLoadingInView:(UIView*) view
{
	UIView* loadingView = nil;
	
	if (view) {
		loadingView = [self createLoadingViewWithRect:view.frame];
		[self showLoadingView:loadingView inView:view];
	}
			
	[self performSelectorInBackground:@selector(workThread:) withObject:[RunnableObject runnableObjectWithTarget:target selector:selector object:object loadingView:loadingView]];
}

-(void) runSelectorOnMainThread:(SEL) selector target:(NSObject*) target object:(NSObject*) object showLoadingInView:(UIView*) view
{
	UIView* loadingView = nil;
	
	if (view) {
		loadingView = [self createLoadingViewWithRect:view.frame];
		[self showLoadingView:loadingView inView:view];
	}
	
	[self performSelector:@selector(workThread:)
			   withObject:[RunnableObject runnableObjectWithTarget:target selector:selector object:object loadingView:loadingView]
			   afterDelay:0.1f];
}

-(void) workThread:(RunnableObject*) runnable
{
	@autoreleasepool {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		[runnable.target performSelector:runnable.selector withObject:runnable.object];
#pragma clang diagnostic pop
        
		if(runnable.loadingView)
			[self performSelectorOnMainThread:@selector(hideLoadingView:) withObject:runnable.loadingView waitUntilDone:YES];
	}
}
	 
-(void) showLoadingView:(UIView*) loadingView inView:(UIView*) inView
{
	CATransition* transition = [CATransition animation];
	transition.type = kCATransitionFade;
	transition.duration = 0.3f;
	
	[inView.layer addAnimation:transition forKey:nil];
	[inView addSubview:loadingView];
}

-(void) hideLoadingView:(UIView*) loadingView
{
	CATransition* transition = [CATransition animation];
	transition.type = kCATransitionFade;
	transition.duration = 0.3f;
	
	[loadingView.layer addAnimation:transition forKey:nil];
	
	[loadingView removeFromSuperview];
}

@end


@implementation RunnableObject

- (id) initWithTarget: (NSObject*)target selector:(SEL) selector object:(NSObject*)object loadingView:(UIView*) loadingView
{
	self = [super init];
	if (self != nil) {
		self.target = target;
		self.selector = selector;
		self.loadingView = loadingView;
		self.object = object;
	}
	return self;
}

+(id) runnableObjectWithTarget:(NSObject*) _target selector:(SEL) _selector object:(NSObject*)_object loadingView:(UIView*) _loadingView
{
	return [[RunnableObject alloc] initWithTarget:_target selector:_selector object:_object loadingView:_loadingView];
}


@end

