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
    
}

- (void) reload {
    [self.refreshControl endRefreshing];
    [self.delegate shouldCloseHotspotsDetails:self];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    double offset = scrollView.contentOffset.y;
    if (offset > 0)
        return;
    
    offset = fabs(offset);
//    NSLog(@"offset: %f", offset);
    double alpha = fabs(100 - offset)/100.f;
    if (offset > 100)
        alpha = 0.f;
    self.alpha = alpha;
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    NSLog(@"offset: %f", scrollView.contentOffset.y);
    if (scrollView.contentOffset.y < -30) {
//        NSLog(@"=== reload ===");
        [self reload];
    }
    
//    NSLog(@"did end drag %f", _scrollView.contentOffset.y);
}


- (void)setHotspot:(Hotspot *)hotspot {
    self.imageView.image = [[DataManager instance] imageByHotspot: hotspot];
    self.titleLabel.text = hotspot.name;
    self.descriptionLabel.text = hotspot.desc;
}

- (void)willTransitionFromLayout:(UICollectionViewLayout *)oldLayout toLayout:(UICollectionViewLayout *)newLayout {
    [super willTransitionFromLayout: oldLayout toLayout: newLayout];
    
    self.scrollView.userInteractionEnabled = newLayout == self.collectionLayouts.largeLayout;
}

@end