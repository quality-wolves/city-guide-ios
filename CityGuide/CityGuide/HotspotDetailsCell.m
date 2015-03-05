//
//  HotspotDetailsCell.m
//  CityGuide
//
//  Created by Chudin Yuriy on 17.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import "HotspotDetailsCell.h"
#import "DataManager.h"
#import "CollectionLayouts.h"
#import "HACollectionViewLargeLayout.h"
#import "HACollectionViewSmallLayout.h"
#import "CityGuide-Swift.h"

@interface HotspotDetailsCell () <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property BOOL reachedPositiveScrollIndex;
@property double wMax, wMin, fSizeMax, fSizeMin;
@end

@implementation HotspotDetailsCell

- (void)awakeFromNib {
    _scrollView.delegate = self;
    _reachedPositiveScrollIndex = YES;
//    [_scrollView addSubview:self.refreshControl];
    [self makeSmallLayoutAnimated: NO];
    
    _wMax = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    _wMin = 145;
    
    _fSizeMax = 18;
    _fSizeMin = 14;


}

- (void) reload {
    [self.refreshControl endRefreshing];
    [self.delegate shouldCloseHotspotsDetails:self];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%f", scrollView.contentOffset.y);
    double offset = scrollView.contentOffset.y;
    if (offset > 0 || _reachedPositiveScrollIndex) {
        _reachedPositiveScrollIndex = YES;
        return;
    }
    
    offset = fabs(offset);
    
    double n = 65.f;

    double alpha = fabs(1 - offset/n);
    if (offset > n)
        alpha = 0.f;
//    self.alpha = alpha;
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _reachedPositiveScrollIndex = NO;
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y < -65) {
        _reachedPositiveScrollIndex = YES;
        [UIView animateWithDuration:0.7f animations:^() {
            self.alpha = 1;

        }];
        [self reload];
    }
    
//    NSLog(@"did end drag %f", _scrollView.contentOffset.y);
}


- (void)setHotspot:(Hotspot *)hotspot {
    _hotspot = hotspot;
    self.imageView.image = [[DataManager instance] imageByHotspot: hotspot];
    self.titleLabel.text = hotspot.name;

//    self.descriptionLabel.text = _hotspot.desc;
//    [self makeSmallLayoutAnimated:NO];
}

- (void) makeSmallLayoutAnimated: (BOOL) animated {
    void (^block)(void) = ^() {
        self.descriptionLabel.alpha = 0;
        self.descriptionLabel.text = @"";
    };
    
    if (animated)
        [UIView animateWithDuration:0.7f animations:[block copy]];
    else
        block();
}

- (void) layoutSubviews {
    double fSize = _fSizeMin + (self.width - _wMin)/(_wMax - _wMin) * (_fSizeMax - _fSizeMin);
    self.titleLabel.font = [self.titleLabel.font fontWithSize:fSize];
    
    [super layoutSubviews];
}

- (void) makeLargeLayoutAnimated: (BOOL) animated {
    void (^block)(void) = ^() {
        self.descriptionLabel.alpha = 1;
        self.descriptionLabel.text = _hotspot.desc;
    };
    
    if (animated)
        [UIView animateWithDuration:0.5f animations:[block copy]];
    else
        block();



}

- (void)willTransitionFromLayout:(UICollectionViewLayout *)oldLayout toLayout:(UICollectionViewLayout *)newLayout {
    [super willTransitionFromLayout: oldLayout toLayout: newLayout];

    if ([oldLayout isKindOfClass:[HACollectionViewLargeLayout class]]) {
        [UIView animateWithDuration:0.3f animations:^() {
            self.descriptionLabel.alpha = 0;
        } completion:^(BOOL finished) {
            self.descriptionLabel.text = @"";
        }];
    } else if ([newLayout isKindOfClass:[HACollectionViewLargeLayout class]]) {
        [UIView animateWithDuration:0.3f animations:^() {
            self.descriptionLabel.alpha = 1;
            self.descriptionLabel.text = _hotspot.desc;
        }];
    }
//    
//    if ([oldLayout isKindOfClass:[HACollectionViewSmallLayout class]]) {
//        [UIView animateWithDuration:0.1f animations:^() {
//            self.titleLabel.transform = CGAffineTransformIdentity;
//        }];
//    }
//    
//    if ([newLayout isKindOfClass:[HACollectionViewSmallLayout class]]) {
//        [UIView animateWithDuration:0.2f animations:^() {
//            self.titleLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.85, 0.85);
//            self.titleLabel.transform = CGAffineTransformTranslate(self.titleLabel.transform, -11, -4);
//
//        }];
//    }
    
    self.scrollView.userInteractionEnabled = newLayout == self.collectionLayouts.largeLayout;
}
//
//- (void)didTransitionFromLayout:(UICollectionViewLayout *)oldLayout toLayout:(UICollectionViewLayout *)newLayout {
//    if ([newLayout isKindOfClass:[HACollectionViewLargeLayout class]])
//        [self makeLargeLayoutAnimated:YES];
//    
//}

@end