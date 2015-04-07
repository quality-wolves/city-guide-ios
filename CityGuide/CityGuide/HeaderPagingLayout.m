//
//  HeaderPagingLayout.m
//  CityGuide
//
//  Created by Vladislav Zozulyak on 03.04.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import "HeaderPagingLayout.h"

@implementation HeaderPagingLayout
//- (CGSize)collectionViewContentSize
//{
//    // Only support single section for now.
//    // Only support Horizontal scroll
//    NSUInteger count = [self.collectionView.dataSource collectionView:self.collectionView
//                                               numberOfItemsInSection:0];
//    
//    CGSize canvasSize = self.collectionView.frame.size;
//    CGSize contentSize = canvasSize;
//    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
//    {
//        NSUInteger rowCount = (canvasSize.height - self.itemSize.height) / (self.itemSize.height + self.minimumInteritemSpacing) + 1;
//        NSUInteger columnCount = (canvasSize.width - self.itemSize.width) / (self.itemSize.width + self.minimumLineSpacing) + 1;
//        NSUInteger page = ceilf((CGFloat)count / (CGFloat)(rowCount * columnCount));
//        contentSize.width = page * canvasSize.width;
//    }
//    
//    return contentSize;
//}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalOffset = proposedContentOffset.x;
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    
    NSArray *array = [super layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in array) {
        CGFloat itemOffset = layoutAttributes.frame.origin.x;
        if (ABS(itemOffset - horizontalOffset) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemOffset - horizontalOffset;
        }
    }
    
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

//
//- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGSize canvasSize = self.collectionView.frame.size;
//    
//    NSUInteger rowCount = (canvasSize.height - self.itemSize.height) / (self.itemSize.height + self.minimumInteritemSpacing) + 1;
//    NSUInteger columnCount = (canvasSize.width - self.itemSize.width) / (self.itemSize.width + self.minimumLineSpacing) + 1;
//    
//    CGFloat pageMarginX = (canvasSize.width - columnCount * self.itemSize.width - (columnCount > 1 ? (columnCount - 1) * self.minimumLineSpacing : 0)) / 2.0f;
//    CGFloat pageMarginY = (canvasSize.height - rowCount * self.itemSize.height - (rowCount > 1 ? (rowCount - 1) * self.minimumInteritemSpacing : 0)) / 2.0f;
//    
//    NSUInteger page = indexPath.row / (rowCount * columnCount);
//    NSUInteger remainder = indexPath.row - page * (rowCount * columnCount);
//    NSUInteger row = remainder / columnCount;
//    NSUInteger column = remainder - row * columnCount;
//    
//    CGRect cellFrame = CGRectZero;
//    cellFrame.origin.x = pageMarginX + column * (self.itemSize.width + self.minimumLineSpacing);
//    cellFrame.origin.y = pageMarginY + row * (self.itemSize.height + self.minimumInteritemSpacing);
//    cellFrame.size.width = self.itemSize.width;
//    cellFrame.size.height = self.itemSize.height;
//    
//    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
//    {
//        cellFrame.origin.x += page * canvasSize.width;
//    }
//    
//    return cellFrame;
//}
//
//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewLayoutAttributes * attr = [super layoutAttributesForItemAtIndexPath:indexPath];
//    attr.frame = [self frameForItemAtIndexPath:indexPath];
//    return attr;
//}
//
//- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    NSArray * originAttrs = [super layoutAttributesForElementsInRect:rect];
//    NSMutableArray * attrs = [NSMutableArray array];
//    
//    [originAttrs enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * attr, NSUInteger idx, BOOL *stop) {
//        NSIndexPath * idxPath = attr.indexPath;
//        CGRect itemFrame = [self frameForItemAtIndexPath:idxPath];
//        if (CGRectIntersectsRect(itemFrame, rect))
//        {
//            attr = [self layoutAttributesForItemAtIndexPath:idxPath];
//            [attrs addObject:attr];
//        }
//    }];
//    
//    return attrs;
//}
@end
