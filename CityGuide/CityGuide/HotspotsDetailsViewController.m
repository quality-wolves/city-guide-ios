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
#import "MapViewController.h"
#import "HotspotSiteViewController.h"

@interface HotspotsDetailsViewController ()<HotspotDetailsDelegate>
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

- (void) hotspotDetailCell: (HotspotDetailsCell *) cell openHotspotMap: (Hotspot *) hotspot {
    if (!hotspot)
        return;
    
    MapViewController *mapVC = [[MapViewController alloc] initWithHotspots:@[hotspot]];
    [self.navigationController pushViewController:mapVC animated:YES];
}

- (void) hotspotDetailCell: (HotspotDetailsCell *) cell betterCallHotspot: (Hotspot *) hotspot {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", [hotspot.phone stringByReplacingOccurrencesOfString:@" " withString:@""]]];

    if (url)
        [[UIApplication sharedApplication] openURL:url];
}

- (void) hotspotDetailCell: (HotspotDetailsCell *) cell openHotspotSite: (Hotspot *) hotspot {
    if ([hotspot.site isValid]) {
        HotspotSiteViewController *siteVC = [[HotspotSiteViewController alloc] initWithHotspot:hotspot];
        [self.navigationController pushViewController:siteVC animated:YES];
    }
}

#pragma mark - UICollectionViewController

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HotspotDetailsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotspotDetailsCell" forIndexPath:indexPath];
    
    cell.delegate = self;
    [cell setHotspot:_hotspots[indexPath.row]];
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Did end diplaying cell: %@", indexPath);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.hotspots.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (void) viewDidLayoutSubviews {
    HACollectionViewLargeLayout *layout = [HACollectionViewLargeLayout new];
    layout.itemSize = CGSizeMake(self.collectionView.width, self.collectionView.height);
    self.collectionView.collectionViewLayout = layout;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_index inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    //    layout.minimumInteritemSpacing = 0;
    
}

@end
