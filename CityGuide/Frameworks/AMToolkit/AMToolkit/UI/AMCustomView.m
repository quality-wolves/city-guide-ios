//
//  BaseCustomView.m
//  Nandos
//

#import "AMCustomView.h"
#import "UIView+LoadFromNib.h"
#import "NSObject+ClassName.h"
#import "UIView+Frame.h"

@interface AMCustomView () {
    AMCustomView *realView;
}

@end

@implementation AMCustomView

- (instancetype) initWithNibName:(NSString *) nibName {
	if ( self = [super initWithFrame:CGRectZero]) {
		self.nibName = nibName;
		[self internalInitialization];
		[self loadSelfFromNib];
	}
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		[self internalInitialization];
        [self loadSelfFromNib];
		if (CGRectEqualToRect(frame, CGRectZero)) {
			[self sizeToFit];
		}
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
	if ( self = [super initWithCoder:aDecoder]) {
		[self internalInitialization];
	}
	return self;
}

- (void) internalInitialization {
	
}

- (void) loadSelfFromNib {
    realView = [AMCustomView loadFromNib:(self.nibName ? self.nibName : [self className]) withOwner:self];
    if ( !CGRectIsEmpty(self.frame) )
        realView.frame = self.bounds;
    [self addSubview:realView];
    self.backgroundColor = [UIColor clearColor];
}

- (void) awakeFromNib {
    if (self.superview && (!realView || !realView.superview)) {
        [self loadSelfFromNib];
    }
}

- (void) sizeToFit {
	UIViewAutoresizing mask = realView.autoresizingMask;
	realView.autoresizingMask = UIViewAutoresizingNone;
	self.size = realView.size;
	realView.autoresizingMask = mask;
}

@end
