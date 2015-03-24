//
//  HeaderView.m
//  CityGuide
//
//  Created by Vladislav Zozulyak on 11.03.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import "HeaderView.h"
#import "HeaderViewCell.h"
#import "CityGuide-Swift.h"


@interface HeaderView()

@property (strong, nonatomic) NSArray *categories;
//@property (strong, nonatomic) 

@end

@implementation HeaderView

- (void)awakeFromNib {
    NSLog(@"Header loaded");
    self.categories = [CGCategory allHotspotCategories];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HeaderViewCell" bundle:nil] forCellWithReuseIdentifier:@"HeaderViewCell"];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 0;
}


#pragma mark - UICollectionViewController

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HeaderViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"HeaderViewCell" forIndexPath:indexPath];
    [cell setCategory:[self.categories objectAtIndex:indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate headerViewDidSelectedCategory:self.categories[indexPath.row]];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categories.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.width, collectionView.height);
    
}

@end
