//
//  UIView+LoadFromNib.h
//

#import <UIKit/UIKit.h>

@interface UIView (LoadFromNib)

+ (instancetype) loadFromNib;
+ (instancetype) loadFromNib:(NSString *) nibName;
+ (instancetype) loadFromNib:(NSString *) nibName withOwner:(id) owner;

@end
