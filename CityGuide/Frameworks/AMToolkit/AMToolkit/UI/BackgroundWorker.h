/*
 * Arello Mobile
 * Mobile Framework
 * Except where otherwise noted, this work is licensed under a Creative Commons Attribution 3.0 Unported License
 * http://creativecommons.org/licenses/by/3.0
*/

#import <Foundation/Foundation.h>


@interface BackgroundWorker : NSObject {	
}

+ (id) sharedWorker;

- (void) runSelectorInBackground:(SEL) selector target:(NSObject*) target object:(NSObject*) object showLoading:(BOOL) showLoading;
- (void) runSelectorInBackground:(SEL) selector target:(NSObject*) target object:(NSObject*) object showLoadingInView:(UIView*) view;

- (void) runSelectorOnMainThread:(SEL) selector target:(NSObject*) target object:(NSObject*) object showLoadingInView:(UIView*) view;

- (UIView*) createLoadingViewWithRect:(CGRect) rect;

- (void) showLoadingView:(UIView*) loadingView inView:(UIView*) inView;
- (void) hideLoadingView:(UIView*) loadingView;

@end



@interface RunnableObject : NSObject

- (id) initWithTarget: (NSObject*)target selector: (SEL)selector object: (NSObject*)object loadingView: (UIView*)loadingView;
+ (id) runnableObjectWithTarget: (NSObject*)target selector:(SEL)selector object: (NSObject*)object loadingView: (UIView*)loadingView;

@property(nonatomic, strong) NSObject* target;
@property(nonatomic, assign) SEL selector;
@property(nonatomic, strong) UIView* loadingView;
@property(nonatomic, strong) NSObject* object;

@end

