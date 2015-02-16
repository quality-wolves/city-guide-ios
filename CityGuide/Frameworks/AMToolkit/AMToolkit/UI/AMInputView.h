/*
 * Arello Mobile
 * Mobile Framework
 * Except where otherwise noted, this work is licensed under a Creative Commons Attribution 3.0 Unported License
 * http://creativecommons.org/licenses/by/3.0
 */

#import <UIKit/UIKit.h>


@interface AMInputView : UIScrollView

@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (nonatomic, strong) IBOutlet UIView *accessoryView;
@property (nonatomic, strong) IBOutletCollection(UIControl) NSArray *controls;

- (IBAction) hideInputViews;
- (IBAction) selectPreviousInputControl:(id) sender;
- (IBAction) selectNextInputControl:(id) sender;

@end