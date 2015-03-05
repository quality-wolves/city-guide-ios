//
//  HACollectionViewSmallLayout.m
//  Paper
//
//  Created by Heberti Almeida on 04/02/14.
//  Copyright (c) 2014 Heberti Almeida. All rights reserved.
//

#import "HACollectionViewSmallLayout.h"

@implementation HACollectionViewSmallLayout

- (id)init
{
    if (!(self = [super init])) return nil;

    double height = [UIScreen mainScreen].bounds.size.height/2.f - 35;
    
    self.itemSize = CGSizeMake(145, height);
//    double height = [UIScreen mainScreen].bounds.size.height - self.itemSize.height - 4;
    self.sectionInset = UIEdgeInsetsMake([UIScreen mainScreen].bounds.size.height-height, 0, 0, 1);
    self.minimumInteritemSpacing = 8.0f;
    self.minimumLineSpacing = 2.0f;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    return self;
}

//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
//{
//    return NO;
//}
//
@end
