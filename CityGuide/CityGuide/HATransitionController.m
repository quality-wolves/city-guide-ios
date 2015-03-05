//
//  HATransitionController.m
//  Paper
//
//  Created by Heberti Almeida on 11/02/14.
//  Copyright (c) 2014 Heberti Almeida. All rights reserved.
//

#import "HATransitionController.h"
#import "HATransitionLayout.h"

@interface HATransitionController ()

@property (nonatomic) HATransitionLayout* transitionLayout;
@property (nonatomic) id <UIViewControllerContextTransitioning> context;
@property (nonatomic) double progress;
@property (nonatomic) CGFloat initialPinchDistance;
@property (nonatomic) CGPoint initialPinchPoint;
@property (nonatomic) CGFloat initialScale;

@end


@implementation HATransitionController

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
{
    self = [super init];
    if (self != nil)
    {
        
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
//        pinchGesture.delaysTouchesBegan = NO;
        [collectionView addGestureRecognizer:pinchGesture];

//        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerGesture:)];
//        panGestureRecognizer.delegate = self;
//        panGestureRecognizer.minimumNumberOfTouches = 1;
//        panGestureRecognizer.maximumNumberOfTouches = 1;
//        panGestureRecognizer.delaysTouchesBegan = YES;
//        panGestureRecognizer.cancelsTouchesInView = NO;
//        [collectionView addGestureRecognizer:panGestureRecognizer];
        
        self.progress = 0;
        self.collectionView = collectionView;
    }
    return self;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)updateWithProgress:(CGFloat)progress andOffset:(UIOffset)offset {
    [self.delegate updateWithProgress:progress andOffset:offset];
}


- (void)endInteractionWithSuccess:(BOOL)success
{
    if (self.context == nil)
    {
        self.hasActiveInteraction = NO;
    }
    
    if (success)
    {
        [self.collectionView finishInteractiveTransition];
        [self.context finishInteractiveTransition];
    }
    else
    {
        [self.collectionView cancelInteractiveTransition];
        [self.context cancelInteractiveTransition];
    }
}

- (void)oneFingerGesture:(UIPanGestureRecognizer *)sender {
    
    CGPoint point = [sender locationInView:sender.view];
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        if (_hasActiveInteraction)
            [self endInteractionWithSuccess:(_progress > 0.2)];
    }
    if (sender.state == UIGestureRecognizerStateCancelled)
    {
        if (_hasActiveInteraction)
            [self endInteractionWithSuccess:NO];
    }
    else if (sender.numberOfTouches == 1)
    {
        
//        float distance = [sender translationInView:self.collectionView].y;
        
        // get the main touch point
        point = [sender locationInView:sender.view];
        double transition = [sender translationInView:self.collectionView].y;
        NSLog(@"Progress: %f", transition);
        if (transition < 0) {
            self.progress = 0;
            return;
        }

        if (sender.state == UIGestureRecognizerStateBegan)
        {
            // start the pinch in our out
            if (!self.hasActiveInteraction)
            {
                self.hasActiveInteraction = YES;    // the transition is in active motion
                [self.delegate interactionBeganAtPoint:point];
            }
        }
        
        if (self.hasActiveInteraction)
        {
            self.progress = MAX(MIN(fabs(transition) / 250.f, 1.0), 0.0);
            
            [self updateWithProgress:_progress andOffset:UIOffsetZero];
        }
    }
}


- (void)handlePinch:(UIPinchGestureRecognizer *)sender
{
    // here we want to end the transition interaction if the user stops or finishes the pinch gesture
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        if (_hasActiveInteraction)
            [self endInteractionWithSuccess:(_progress > 0.3)];
    }
    else if (sender.state == UIGestureRecognizerStateCancelled)
    {
        if (_hasActiveInteraction)
            [self endInteractionWithSuccess:NO];
    }
    else if (sender.numberOfTouches == 2)
    {
        // here we expect two finger touch
        CGPoint point;      // the main touch point
        CGPoint point1;     // location of touch #1
        CGPoint point2;     // location of touch #2
        CGFloat distance;   // computed distance between both touches
        
        // return the locations of each gesture’s touches in the local coordinate system of a given view
        point1 = [sender locationOfTouch:0 inView:sender.view];
        point2 = [sender locationOfTouch:1 inView:sender.view];
        distance = sqrt((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y));
        
        // get the main touch point
        point = [sender locationInView:sender.view];
        
        if (sender.state == UIGestureRecognizerStateBegan)
        {
            // start the pinch in our out
            if (!self.hasActiveInteraction)
            {
                self.initialPinchDistance = distance;
                self.initialPinchPoint = point;
                self.hasActiveInteraction = YES;    // the transition is in active motion
                [self.delegate interactionBeganAtPoint:point];
            }
        }
        
        if (self.hasActiveInteraction)
        {
            if (sender.state == UIGestureRecognizerStateChanged)
            {
                // update the progress of the transtition as the user continues to pinch
                CGFloat delta = distance - self.initialPinchDistance;
                CGFloat offsetX = point.x - self.initialPinchPoint.x;
                //                CGFloat offsetY = point.y - self.initialPinchPoint.y;
                CGFloat offsetY = (point.y - self.initialPinchPoint.y) + delta/M_PI;
                UIOffset offsetToUse = UIOffsetMake(offsetX, offsetY);
                
                CGFloat distanceDelta = distance - self.initialPinchDistance;
                distanceDelta = -distanceDelta;
                //                CGFloat dimension = sqrt(self.collectionView.bounds.size.width * self.collectionView.bounds.size.width + self.collectionView.bounds.size.height * self.collectionView.bounds.size.height);
                //                CGFloat progress = MAX(MIN((distanceDelta / dimension), 1.0), 0.0);
                self.progress = MAX(MIN(((distanceDelta) / 500), 1.0), 0.0);
//                NSLog(@"Progress: %f", _progress);
                // tell our UICollectionViewTransitionLayout subclass (transitionLayout)
                // the progress state of the pinch gesture
                //
                [self updateWithProgress:_progress andOffset:offsetToUse];
            }
        }
    }
}


@end
