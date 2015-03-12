//
//  HeaderView.h
//  CityGuide
//
//  Created by Vladislav Zozulyak on 11.03.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CGCategory;

@protocol HeaderViewDelegate;

@interface HeaderView : UICollectionReusableView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) NSObject <HeaderViewDelegate> *delegate;

@end


@protocol HeaderViewDelegate

- (void) headerViewDidSelectedCategory: (CGCategory *) category;

@end