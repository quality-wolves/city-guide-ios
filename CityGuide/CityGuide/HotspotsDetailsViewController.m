//
//  HotspotsDetailsViewController.m
//  CityGuide
//
//  Created by Vladislav Zozulyak on 20.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import "HotspotsDetailsViewController.h"
#import "FavouritesManager.h"
#import "HotspotDetailsCell.h"
#import "HACollectionViewLargeLayout.h"

@interface HotspotsDetailsViewController ()
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSUInteger index;
@end

@implementation HotspotsDetailsViewController

- (id) initWithHotspot: (Hotspot *) hotspot {
    if (self = [super initWithNibName:@"HotspotsDetailsViewController" bundle:nil]) {
        self.hotspots = @[hotspot];
    }
    return self;
}

- (id) initWithHotspots: (NSArray *) hotspots showAtIndex: (NSUInteger) index {
    if (self = [super initWithNibName:@"HotspotsDetailsViewController" bundle:nil]) {
        self.hotspots = hotspots;
        self.index = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerNib: [UINib nibWithNibName: @"HotspotDetailsCell" bundle:nil] forCellWithReuseIdentifier: @"HotspotDetailsCell"];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewController

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HotspotDetailsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotspotDetailsCell" forIndexPath:indexPath];
    
    [cell setHotspot:_hotspots[indexPath.row]];
    
    return cell;
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    HotspotsDetailsViewController *vc = [[HotspotsDetailsViewController alloc] initWithHotspot:[_hotspots objectAtIndex:indexPath.row]];
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.hotspots.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0) {
//        CGFloat w = self.collectionView.frame.size.width;
//        return CGSizeMake(w, 210);
//        
//    }
//    
//    CGFloat padding = 10;
//    CGFloat w = (self.collectionView.frame.size.width - padding)/2.0f;
//    return CGSizeMake(w, w/1.35f);
//    
//}
//
- (void) viewDidLayoutSubviews {
//    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    HACollectionViewLargeLayout *layout = [HACollectionViewLargeLayout new];
    layout.itemSize = CGSizeMake(self.collectionView.width, self.collectionView.height);
    self.collectionView.collectionViewLayout = layout;
    //    CGFloat padding = 20;
//        CGFloat w = (self.collectionView.frame.size.width - padding)/2.0f;
//    layout.minimumInteritemSpacing = 0;
//    layout.minimumLineSpacing = 0;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_index inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    //    layout.minimumInteritemSpacing = 0;
    
}

@end
