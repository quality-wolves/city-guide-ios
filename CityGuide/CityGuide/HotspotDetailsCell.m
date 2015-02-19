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

@end

@implementation HotspotDetailsCell

- (void)awakeFromNib {
    _scrollView.delegate = self;
    _reachedPositiveScrollIndex = YES;
    [_scrollView addSubview:self.refreshControl];
    [self makeSmallLayout];

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
    self.alpha = alpha;
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _reachedPositiveScrollIndex = NO;
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"offset: %f", scrollView.contentOffset.y);
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
}

- (void) makeSmallLayout {
    [UIView animateWithDuration:0.7f animations:^() {
        self.descriptionLabel.alpha = 0;
        self.descriptionLabel.text = @"";
    }];

}

- (void) makeLargeLayout {
    [UIView animateWithDuration:0.5f animations:^() {
        self.descriptionLabel.alpha = 1;
        self.descriptionLabel.text = _hotspot.desc;
    }];
}

- (void)willTransitionFromLayout:(UICollectionViewLayout *)oldLayout toLayout:(UICollectionViewLayout *)newLayout {
    [super willTransitionFromLayout: oldLayout toLayout: newLayout];

    if ([oldLayout isKindOfClass:[HACollectionViewLargeLayout class]])
        [self makeSmallLayout];
    
    self.scrollView.userInteractionEnabled = newLayout == self.collectionLayouts.largeLayout;
}

- (void)didTransitionFromLayout:(UICollectionViewLayout *)oldLayout toLayout:(UICollectionViewLayout *)newLayout {
    if ([newLayout isKindOfClass:[HACollectionViewLargeLayout class]])
        [self makeLargeLayout];
    
}

@end