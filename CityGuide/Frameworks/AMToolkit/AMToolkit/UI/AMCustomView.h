//
//  BaseCustomView.h
//  Nandos
//

#import <UIKit/UIKit.h>

@interface AMCustomView : UIView

@property (nonatomic, strong) NSString *nibName;
- (instancetype) initWithNibName:(NSString *) nibName;

- (void) internalInitialization;
- (void) loadSelfFromNib;

@end
