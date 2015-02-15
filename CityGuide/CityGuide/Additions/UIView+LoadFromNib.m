//
//  UIView+LoadFromNib.m
//

#import "UIView+LoadFromNib.h"
#import "NSObject+ClassName.h"

@implementation UIView (LoadFromNib)

+ (instancetype) loadFromNib {
    return [self loadFromNib:[self className]];
}

+ (instancetype) loadFromNib:(NSString *) nibName {
    return [self loadFromNib:nibName withOwner:nil];
}

+ (instancetype) loadFromNib:(NSString *) nibName withOwner:(id) owner {
    NSArray *loadedObjects = [[NSBundle mainBundle] loadNibNamed:nibName owner:owner options:nil];
    for (id obj in loadedObjects) {
        if ([obj isKindOfClass:self]) {
            return obj;
        }
    }
    return nil;
}

@end