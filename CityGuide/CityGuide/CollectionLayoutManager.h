//
//  CollectionLayoutManager.h
//  CityGuide
//
//  Created by Chudin Yuriy on 17.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CollectionLayoutManager : NSObject

@property (nonatomic, readonly, strong) UICollectionViewLayout *smallLayout;
@property (nonatomic, readonly, strong) UICollectionViewLayout *largeLayout;

+ (instancetype) instance;

@end