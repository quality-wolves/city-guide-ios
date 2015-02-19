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
    
    self.itemSize = CGSizeMake(142, 200);
//    double height = [UIScreen mainScreen].bounds.size.height - self.itemSize.height - 4;
    double height = [UIScreen mainScreen].bounds.size.height/2.f;
    self.sectionInset = UIEdgeInsetsMake(height, 10, 0, 10);
    self.minimumInteritemSpacing = 10.0f;
    self.minimumLineSpacing = 6.0f;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    return self;
}

//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
//{
//    return NO;
//}
//
@end
