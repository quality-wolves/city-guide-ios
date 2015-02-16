/*
 * Arello Mobile
 * Mobile Framework
 * Except where otherwise noted, this work is licensed under a Creative Commons Attribution 3.0 Unported License
 * http://creativecommons.org/licenses/by/3.0
 */

#import "AMRadioButtonContainer.h"

@implementation AMRadioButtonContainer {
	NSMutableArray *buttons;
}

- (void) buttonDidSelected: (UIButton*) button {
	if (! [buttons containsObject:button])
		return;
	
	for (UIButton *b in buttons) {
		b.selected = NO;
	}
	
	button.selected = YES;
}

- (void) selectButton: (UIButton*) button {
	[self buttonDidSelected:button];	
}

- (void) didAddSubview:(UIView *)subview {
	[super didAddSubview:subview];
	if ([subview isKindOfClass:[UIButton class]]) {
		if (!buttons) buttons = [NSMutableArray new];
		UIButton *button = (UIButton *) subview;
		[button addTarget:self action:@selector(buttonDidSelected:) forControlEvents:UIControlEventTouchUpInside];
		[buttons addObject:button];
		if ([buttons count] == 1)
			button.selected = YES;
	}
}

- (void)dealloc {
	 buttons = nil;
}

@end
