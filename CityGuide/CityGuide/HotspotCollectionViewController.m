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


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;


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
    int count = _hotspots.count;
    self.countLabel.text = [NSString stringWithFormat:@"More than %d cool places", count];
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
/*
 var flowLayout: UICollectionViewFlowLayout? = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
 var padding:CGFloat = 5
 let rowsize = ceil((self.collectionView.height-38)/5)
 NSLog("%@ %@", rowsize, rowsize*2+14)
 var w:CGFloat = self.collectionView.frame.size.width/2.0 - padding
 flowLayout?.itemSize = CGSizeMake(w, rowsize+1)
 flowLayout?.minimumLineSpacing = 0;
 flowLayout?.headerReferenceSize = CGSizeMake(self.collectionView.width, rowsize*2+14);
 
 */

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float padding = 5;
    int rowSize = ceil((collectionView.height-38)/5.f);
    float w = collectionView.width/2.0 - padding;
    float imgScaleFactor = 335.0/640.0;
    
    if (indexPath.row == 0) {
        CGFloat w = self.collectionView.frame.size.width;
        return CGSizeMake(w, w * imgScaleFactor + 54);
    }
    
    return CGSizeMake(w, w * imgScaleFactor + 29);

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