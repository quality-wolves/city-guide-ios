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
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;
@end

@implementation HotspotDetailsCell

- (IBAction)favouriteAction:(id)sender {
    _favouriteButton.selected = !_favouriteButton.selected;
    if (_favouriteButton.selected) {
        [[FavouritesManager sharedManager] addFavouriteHotspot:_hotspot];
    } else {
        [[FavouritesManager sharedManager] removeHotspotFromFavourites:_hotspot];
    }
}

- (void)setHotspot:(Hotspot *)hotspot {
    _hotspot = hotspot;
    self.imageView.image = [[DataManager instance] imageByHotspot: hotspot];
    self.titleLabel.text = hotspot.name;
    self.descriptionLabel.text = hotspot.desc;
    _favouriteButton.selected = [[FavouritesManager sharedManager] isFavourite:_hotspot];

}

@end