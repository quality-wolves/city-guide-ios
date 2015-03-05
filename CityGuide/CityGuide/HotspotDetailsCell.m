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
#import "FavouritesManager.h"

@interface HotspotDetailsCell () <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;
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

- (IBAction)favouriteAction:(id)sender {
    _favouriteButton.selected = !_favouriteButton.selected;
    if (_favouriteButton.selected) {
        [[FavouritesManager sharedManager] addFavouriteHotspot:_hotspot];
    } else {
        [[FavouritesManager sharedManager] removeHotspotFromFavourites:_hotspot];
    }
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
    _favouriteButton.selected = [[FavouritesManager sharedManager] isFavourite:_hotspot];

}

- (void) makeSmallLayoutAnimated: (BOOL) animated {
    if (!animated) {
        self.descriptionLabel.alpha = 0;
        self.descriptionLabel.text = @"";
        self.favouriteButton.alpha = 0;
    } else {
        [UIView animateWithDuration:0.3f animations:^() {
            self.descriptionLabel.alpha = 0;
            self.favouriteButton.alpha = 0;
        } completion:^(BOOL finished) {
            self.descriptionLabel.text = @"";
        }];
    }
}

- (void) layoutSubviews {
    double fSize = _fSizeMin + (self.width - _wMin)/(_wMax - _wMin) * (_fSizeMax - _fSizeMin);
    self.titleLabel.font = [self.titleLabel.font fontWithSize:fSize];
    
    [super layoutSubviews];
}

- (void) makeLargeLayoutAnimated: (BOOL) animated {
    if (!animated) {
        self.descriptionLabel.alpha = 1;
        self.descriptionLabel.text = _hotspot.desc;
        self.favouriteButton.alpha = 1;
    } else {
        [UIView animateWithDuration:0.3f animations:^() {
            self.descriptionLabel.alpha = 1;
            self.descriptionLabel.text = _hotspot.desc;
            self.favouriteButton.alpha = 1;
        }];
    }

}

- (void)willTransitionFromLayout:(UICollectionViewLayout *)oldLayout toLayout:(UICollectionViewLayout *)newLayout {
    [super willTransitionFromLayout: oldLayout toLayout: newLayout];

    if ([oldLayout isKindOfClass:[HACollectionViewLargeLayout class]]) {
        [self makeSmallLayoutAnimated:YES];
    } else if ([newLayout isKindOfClass:[HACollectionViewLargeLayout class]]) {
        [self makeLargeLayoutAnimated:YES];
    }
    
    self.scrollView.userInteractionEnabled = newLayout == self.collectionLayouts.largeLayout;
}
@end