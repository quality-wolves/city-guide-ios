//
//  HATransitionController.h
//  Paper
//
//  Created by Heberti Almeida on 11/02/14.
//  Copyright (c) 2014 Heberti Almeida. All rights reserved.
//

@import UIKit;

@protocol HATransitionControllerDelegate <NSObject>
- (void)interactionBeganAtPoint:(CGPoint)point;
- (void)updateWithProgress:(CGFloat)progress andOffset:(UIOffset)offset;
@end


@interface HATransitionController : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic) id <HATransitionControllerDelegate> delegate;
@property (nonatomic) BOOL hasActiveInteraction;
@property (nonatomic) UICollectionView *collectionView;

- (instancetype)initWithCollectionView:(UICollectionView*)collectionView;

@end
