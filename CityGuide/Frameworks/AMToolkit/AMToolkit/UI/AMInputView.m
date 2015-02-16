/*
 * Arello Mobile
 * Mobile Framework
 * Except where otherwise noted, this work is licensed under a Creative Commons Attribution 3.0 Unported License
 * http://creativecommons.org/licenses/by/3.0
 */

#import "AMInputView.h"

@interface AMInputView () <UIGestureRecognizerDelegate> {
	UIView *_accessoryView;
	UITapGestureRecognizer *_tapRecognizer;
	BOOL _keyboardVisible;
	UIEdgeInsets _originalInset;
	UIView *contentView;
}

@property (nonatomic, weak) UIView *controlForScrolling;

- (void) scrollToView: (UIView *) view;

@end


@implementation AMInputView

@synthesize contentView;
@synthesize controls;

#pragma mark -
#pragma mark Initialization

- (UIView *) createToolbar {
	UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
	toolbar.barStyle = UIBarStyleBlackTranslucent;
	
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"Previous", @"Previous"), NSLocalizedString(@"Next", @"Next"), nil]];
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.tintColor = [UIColor blackColor];
	segmentedControl.momentary = YES;
	[segmentedControl addTarget:self action:@selector(segmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
	
	UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
	UIBarButtonItem *spaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hideInputViews)];
	
	toolbar.items = [NSArray arrayWithObjects:leftBarButtonItem, spaceBarButtonItem, rightBarButtonItem, nil];
	return toolbar;
}

- (void) screenTap:(UITapGestureRecognizer *) rec {
    [self performSelector:@selector(hideInputViews) withObject:nil afterDelay:0.01f inModes:@[NSRunLoopCommonModes]];
}

- (IBAction) hideInputViews {
    [self endEditing:NO];
	self.controlForScrolling = nil;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
	if ([touch.view canBecomeFirstResponder]) {
		UIView *s = touch.view;
		while ((s = s.superview) && (s != self));
		if (s) {
			self.controlForScrolling = touch.view;
		}
	}
    return YES;
}

- (void) updateAccessoryViews {
	for (id c in self.controls) {
		if ([c respondsToSelector:@selector(setInputAccessoryView:)]) {
			[c setInputAccessoryView:_accessoryView];
		}
	}
}

- (void) layoutSubviews {
	[super layoutSubviews];
	[self updateAccessoryViews];
}

- (void) internalInit {
	if (!self.inputAccessoryView) {
		_accessoryView = [self createToolbar];
	}
	else {
		_accessoryView = self.inputAccessoryView;
	}
	
	_tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTap:)];
	_tapRecognizer.delegate = self;
	_tapRecognizer.cancelsTouchesInView = NO;
	[self addGestureRecognizer:_tapRecognizer];

	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) setInputAccessoryView:(UIView *)inputAccessoryView {
	_accessoryView = inputAccessoryView;
	
	if (!self.inputAccessoryView) {
		_accessoryView = [self createToolbar];
	}
	else {
		_accessoryView = self.inputAccessoryView;
	}
	[self updateAccessoryViews];
}

- (void) setControls:(NSArray *)_controls {
	controls = _controls;
	[self updateAccessoryViews];
}

- (id) init {
	if (self = [super init]) {
		[self internalInit];
	}
	return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		[self internalInit];
	}
	return self;
}

- (id) initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self internalInit];
	}
	return self;
}

#pragma mark -
#pragma mark Keyboard Notifications

- (void) beginAnimationWithKeyboardCurveAndDurationFromNotification: (NSNotification *)notify {
    NSDictionary* userInfo = [notify userInfo];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
}

- (CGRect) keyboardFrameFromNotification: (NSNotification *)notify {
    NSDictionary* userInfo = [notify userInfo];
    CGRect keyboardEndFrame;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    return keyboardEndFrame;
}

- (void) keyboardWillShow: (NSNotification *) notification {
	[self beginAnimationWithKeyboardCurveAndDurationFromNotification:notification];
	
	CGRect keyboardFrame = [self keyboardFrameFromNotification:notification];
	
	CGRect selfScreenFrame = [self.window convertRect:self.frame fromView:self.superview];
		
	CGFloat slideSize = keyboardFrame.size.height - ([UIScreen mainScreen].bounds.size.height - selfScreenFrame.origin.y - self.frame.size.height);
	
	if (!_keyboardVisible)
		_originalInset = self.contentInset;
	
	if (slideSize > 0)
		self.contentInset = self.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0,slideSize , 0);
		
	[UIView commitAnimations];
	
	[self scrollToView:self.controlForScrolling];
	
	_keyboardVisible = YES;
}

- (void) keyboardWillHide: (NSNotification *) notification {
	[self beginAnimationWithKeyboardCurveAndDurationFromNotification:notification];
	self.scrollIndicatorInsets = self.contentInset = _originalInset;
	[UIView commitAnimations];
	self.controlForScrolling = nil;
	_keyboardVisible = NO;
}

#pragma mark -
#pragma mark TextControl Responders

- (NSInteger) selectedControlIndex {
	NSIndexSet *selectedControl = [self.controls indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		if ([obj isFirstResponder]) {
			*stop = YES;
			return YES;
		}
		return NO;
	}];
	return selectedControl.count ? [selectedControl lastIndex] : NSNotFound;
}

- (void) selectPreviousInputControl:(id) sender {
	NSInteger index = [self selectedControlIndex];
	if (index != NSNotFound && index > 0) {
		UIView *textControlToSelect = [self.controls objectAtIndex:index - 1];
		[textControlToSelect becomeFirstResponder];
		[self scrollToView:textControlToSelect];
	}
}

- (void) selectNextInputControl:(id) sender {
	NSInteger index = [self selectedControlIndex];
	if (index != NSNotFound && index < [self.controls count] - 1) {
		UIView *textControlToSelect = [self.controls objectAtIndex:index + 1];
		[textControlToSelect becomeFirstResponder];
		[self scrollToView:textControlToSelect];
	}
}

- (void) segmentedControlChanged: (UISegmentedControl *) sender {
	switch (sender.selectedSegmentIndex) {
		case 0:
			[self selectPreviousInputControl:sender];
			break;
		case 1:
			[self selectNextInputControl:sender];
			break;
		default:
			break;
	}
}

#pragma mark -
#pragma mark UI


- (void) setContentView: (UIView *) newContentView {
	if (contentView != newContentView) {
		[contentView removeFromSuperview];
		
		contentView = newContentView;
		
		[self addSubview:contentView];
		self.contentSize = contentView.frame.size;
	}
}
- (void) scrollToView: (UIView *) view {
	if (view) {
        CGPoint viewPos = [view.superview convertPoint:view.frame.origin toView:self.superview];
        
        CGFloat shouldPosY = (self.frame.size.height - self.contentInset.bottom - view.frame.size.height)/2;
        
        CGFloat diffY = shouldPosY - viewPos.y;
        
        CGPoint positionInScrollView = [view.superview convertPoint:view.frame.origin toView:self];
		
        if ((positionInScrollView.y + shouldPosY + view.frame.size.height) >= self.contentSize.height) {
            [self setContentOffset:CGPointMake(self.contentOffset.x, self.contentSize.height - (self.frame.size.height - self.contentInset.bottom)) animated:YES];
        }
        else if (self.contentOffset.y - diffY < 0) {
			[self setContentOffset:CGPointMake(self.contentOffset.x, 0) animated:YES];
		} else {
            [self setContentOffset:CGPointMake(self.contentOffset.x, self.contentOffset.y - diffY) animated:YES];
		}		
    }
}

#pragma mark -
#pragma mark Memory management

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	
	self.contentView = nil;
	self.controls = nil;
	
}


@end
