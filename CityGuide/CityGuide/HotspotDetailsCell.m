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
#import "HotspotImageCell.h"

@interface HotspotDetailsCell () <UIScrollViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;
@property (weak, nonatomic) IBOutlet UIView *bottomContainer;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *webLabel;
@property (weak, nonatomic) IBOutlet UILabel *addedToFavouritesLabel;


@end

@implementation HotspotDetailsCell

- (IBAction)favouriteAction:(id)sender {
    __weak HotspotDetailsCell *wself = self;
    _favouriteButton.selected = !_favouriteButton.selected;
    
    if (_favouriteButton.selected) {
        [[FavouritesManager sharedManager] addFavouriteHotspot:_hotspot];
        [UIView animateWithDuration:0.3 animations:^() {
            wself.addedToFavouritesLabel.alpha = 1;
        } completion: ^(BOOL finished) {
            if (finished) {
                [UIView animateKeyframesWithDuration:0.3f delay:1 options:0 animations:^() {
                    wself.addedToFavouritesLabel.alpha = 0;
                } completion:^(BOOL finished) {
                    
                }];
            }
        }];
    } else {
        [[FavouritesManager sharedManager] removeHotspotFromFavourites:_hotspot];
        [wself.addedToFavouritesLabel.layer removeAllAnimations];
        [UIView animateKeyframesWithDuration:0.3f delay:0 options:0 animations:^() {
            wself.addedToFavouritesLabel.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.width, self.collectionView.height);
}

- (void) awakeFromNib {
    [self.collectionView registerNib:[UINib nibWithNibName:@"HotspotImageCell" bundle:nil] forCellWithReuseIdentifier:@"HotspotImageCell"];
    
    self.bottomContainer.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.6] CGColor];
    self.bottomContainer.layer.borderWidth = 0.5;
    self.bottomContainer.backgroundColor = [UIColor clearColor];
    self.addedToFavouritesLabel.alpha = 0;
}

- (void)setHotspot:(Hotspot *)hotspot {
    _hotspot = hotspot;
//    self.imageView.image = [[DataManager instance] imageByHotspot: hotspot];
    self.titleLabel.text = hotspot.name;
    self.descriptionLabel.text = hotspot.desc;
    _favouriteButton.selected = [[FavouritesManager sharedManager] isFavourite:_hotspot];
    self.addressLabel.text = hotspot.address;//@"Carrer d'Elisabets, 11, 08001, Barcelona";
    self.phoneLabel.text = hotspot.phone;//@"+34 932426280";
    self.webLabel.text = hotspot.site;//@"Praktikhotels.com";
}

- (IBAction)webSiteAction:(id)sender {
    [self.delegate hotspotDetailCell:self openHotspotSite:self.hotspot];
}

- (IBAction)mapAction:(id)sender {
    [self.delegate hotspotDetailCell:self openHotspotMap:self.hotspot];
}

- (IBAction)phoneAction:(id)sender {
    [self.delegate hotspotDetailCell:self betterCallHotspot:self.hotspot];
}

#pragma mark - Collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HotspotImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotspotImageCell" forIndexPath:indexPath];
    [cell setImage: _hotspot atIndex: indexPath.row];
    return cell;
}

@end