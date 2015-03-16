//
//  HotspotCollectionViewController.m
//  CityGuide
//
//  Created by Vladislav Zozulyak on 13.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import "HotspotCollectionViewController.h"
#import "DataManager.h"
#import "HotspotSmallCell.h"
#import "HotspotHeaderView.h"
#import "HotspotsDetailsViewController.h"


#import "CityGuide-Swift.h"

#include <stdlib.h>

@interface HotspotCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *hotspots;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end



@implementation HotspotCollectionViewController

- (id) init {
    if (self = [super initWithNibName:@"HotspotCollectionViewController" bundle:nil]) {
        
    }
    return self;
}

- (id) initWithHotspots: (NSArray*) hotspots {
	if(self = [self init]) {
		self.hotspots = hotspots;
	}
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = [[_hotspots lastObject] categoryName];
	[self.collectionView registerNib: [UINib nibWithNibName: @"HotspotSmallCell" bundle:nil] forCellWithReuseIdentifier: @"HotspotSmallCell"];
	[self.collectionView registerNib: [UINib nibWithNibName: @"HotspotHeaderView" bundle:nil] forCellWithReuseIdentifier: @"HotspotHeaderView"];
}

- (BOOL)prefersStatusBarHidden {
	return YES;
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewController

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) { //header cell
        HotspotHeaderView *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"HotspotHeaderView" forIndexPath:indexPath];
        
        Hotspot *h = _hotspots[indexPath.row];
        [cell setHotspot: h];
        
        return cell;
    }
    
	HotspotSmallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"HotspotSmallCell" forIndexPath:indexPath];
    [cell setHotspot:_hotspots[indexPath.row]];
	
	return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HotspotsDetailsViewController *vc = [[HotspotsDetailsViewController alloc] initWithHotspots:_hotspots showAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.hotspots.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CGFloat w = self.collectionView.frame.size.width;
        return CGSizeMake(w, 210);
        
    }
    
    CGFloat padding = 10;
    CGFloat w = (self.collectionView.frame.size.width - padding)/2.0f;
    return CGSizeMake(w, w/1.35f);

}

- (void) viewDidLayoutSubviews {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;

//    CGFloat padding = 20;
//    CGFloat w = (self.collectionView.frame.size.width - padding)/2.0f;
//    layout.itemSize = CGSizeMake(w, w/1.35f);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 0;
//    layout.minimumInteritemSpacing = 0;

}

@end