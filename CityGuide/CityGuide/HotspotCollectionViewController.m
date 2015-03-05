//
//  HotspotCollectionViewController.m
//  CityGuide
//
//  Created by Vladislav Zozulyak on 13.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import "HotspotCollectionViewController.h"
#import "HACollectionViewLargeLayout.h"
#import "HACollectionViewSmallLayout.h"
#import "HATransitionController.h"
#import "DataManager.h"
#import "HotspotCollectionView.h"
#import "HotspotDetailsCell.h"
#import "CollectionLayouts.h"
#import "HATransitionLayout.h"
#import "CityGuide-Swift.h"
#import "TLTransitionLayout.h"
#import "UICollectionView+TLTransitioning.h"
#import "HATransitionLayout.h"
#include <stdlib.h>

@interface HotspotCollectionViewController () <HotspotDetailsDelegate, HATransitionControllerDelegate> //<UINavigationControllerDelegate, HATransitionControllerDelegate>

@property (nonatomic, strong) HATransitionController *transitionController;

@property (nonatomic, assign) NSInteger slide;
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIImageView *topImage;
@property (nonatomic, strong) UIImageView *reflected;

@property (nonatomic, strong) NSArray *hotspots;
@property (nonatomic, strong) HotspotCollectionView *hotspotView;

@property (nonatomic, strong) NSTimer *slideTimer;

@property (nonatomic, strong) CollectionLayouts *collectionLayouts;
@property (strong, nonatomic) TLTransitionLayout *layout;

@end



@implementation HotspotCollectionViewController

- (id) init {
	CollectionLayouts *layouts = [CollectionLayouts new];
    if (self = [super initWithCollectionViewLayout: layouts.smallLayout]) {
		self.collectionLayouts = layouts;
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

	NSString *reuseId = [HotspotDetailsCell className];
	[self.collectionView registerNib: [UINib nibWithNibName: reuseId bundle:nil] forCellWithReuseIdentifier: reuseId];
	[self.collectionView setBackgroundColor:[UIColor clearColor]];
	
	[self setupSlides];

	[self setupHotspotView];
	
	// First Load
	[self changeSlide];
	
	[self startSlideTimer];
    self.transitionController = [[HATransitionController alloc] initWithCollectionView:self.collectionView];
    self.transitionController.delegate = self;
	
}

- (void) startSlideTimer {
	self.slideTimer = [NSTimer timerWithTimeInterval:5.0f target:self selector:@selector(changeSlide) userInfo:nil repeats:YES];
	[[NSRunLoop mainRunLoop] addTimer: self.slideTimer forMode:NSRunLoopCommonModes];
}

- (void) stopSlideTimer {
	[self.slideTimer invalidate];
	self.slideTimer = nil;
}

- (void) setupSlides {
	_slide = 0;
	
	
	// Init mainView
	_mainView = [[UIView alloc] initWithFrame:self.view.bounds];
	_mainView.clipsToBounds = YES;
	_mainView.layer.cornerRadius = 4;
	[self.view insertSubview:_mainView belowSubview:self.collectionView];
	
	// ImageView on top
	_topImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
	_reflected = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_topImage.bounds), 320, 320)];
	[_mainView addSubview:_topImage];
	[_mainView addSubview:_reflected];
	
	
	// Reflect imageView
	_reflected.transform = CGAffineTransformMakeScale(1.0, -1.0);
	
	
	// Gradient to top image
	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = _topImage.bounds;
	gradient.colors = @[(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4] CGColor],
						(id)[[UIColor colorWithWhite:0 alpha:0] CGColor]];
	[_topImage.layer insertSublayer:gradient atIndex:0];
	
	
	// Gradient to reflected image
	CAGradientLayer *gradientReflected = [CAGradientLayer layer];
	gradientReflected.frame = _reflected.bounds;
	gradientReflected.colors = @[(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor],
								 (id)[[UIColor colorWithWhite:0 alpha:0] CGColor]];
	[_reflected.layer insertSublayer:gradientReflected atIndex:0];
	
	
	// Content perfect pixel
	UIView *perfectPixelContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_topImage.bounds), 1)];
	perfectPixelContent.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
	[_topImage addSubview:perfectPixelContent];
}

- (void) setupHotspotView {
	__weak typeof(self) wself = self;
	
	self.hotspotView = [HotspotCollectionView create];
	self.hotspotView.backButtonAction = ^() { [wself.navigationController popViewControllerAnimated:YES]; };
	
	// Label Shadow
	[self.hotspotView.titleLabel setClipsToBounds:NO];
	[self.hotspotView.titleLabel.layer setShadowOffset:CGSizeMake(0, 0)];
	[self.hotspotView.titleLabel.layer setShadowColor:[[UIColor blackColor] CGColor]];
	[self.hotspotView.titleLabel.layer setShadowRadius:1.0];
	[self.hotspotView.titleLabel.layer setShadowOpacity:0.6];
	
	[self.hotspotView.backButton setClipsToBounds:NO];
	[self.hotspotView.backButton.layer setShadowOffset:CGSizeMake(0, 0)];
	[self.hotspotView.backButton.layer setShadowColor:[[UIColor blackColor] CGColor]];
	[self.hotspotView.backButton.layer setShadowRadius:1.0];
	[self.hotspotView.backButton.layer setShadowOpacity:0.6];
	
	Hotspot *hotspot = _hotspots[_slide];
	[self.hotspotView.backButton setTitle: [hotspot categoryName] forState: UIControlStateNormal];
	
	[self.view addSubview: self.hotspotView];
}

- (BOOL)prefersStatusBarHidden
{
	return YES;
}

- (void)updateWithProgress:(CGFloat)progress andOffset:(UIOffset)offset {
    [self.layout setTransitionProgress:progress];
}

- (void)interactionBeganAtPoint:(CGPoint)point
{
    UICollectionViewLayout *nextLayout = self.collectionLayouts.smallLayout;
    self.layout = (TLTransitionLayout *)[self.collectionView startInteractiveTransitionToCollectionViewLayout:nextLayout
                                                                                                   completion:^(BOOL completed, BOOL finish) {
                                   if (finish) {
//                                       self.collectionView.contentOffset = self.layout.toContentOffset;
                                       self.layout= nil;
                                       [self.view insertSubview: self.collectionView belowSubview:self.hotspotView];
                                   }
                                                                                                   }];
//    self.layout.toContentOffset = [self.collectionView toContentOffsetForLayout:self.layout indexPaths:self.collectionView.indexPathsForVisibleItems placement:TLTransitionLayoutIndexPathPlacementCenter];
}

#pragma mark - View

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear: animated];
	
//	self.navigationController.delegate = self;
	
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear: animated];
	
//	[self.view bringSubviewToFront: self.hotspotView];
}

- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear: animated];
}

#pragma mark - Change slider

- (void)changeSlide {
	if(!_hotspots.count)
		return;
		
    
    long prevSlide = _slide;
    if (_hotspots.count > 1)
        while (prevSlide == _slide)
            _slide = arc4random()%_hotspots.count;
//    if(_slide > _hotspots.count - 1)
//		_slide = 0;
	
	Hotspot *hotspot = _hotspots[_slide];
	
	UIImage *toImage = [[DataManager instance] imageByHotspot: hotspot];
    [UIView transitionWithView:_mainView
                      duration:0.6f
                       options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationCurveEaseInOut
                    animations:^{
                        _topImage.image = toImage;
                        _reflected.image = toImage;
						self.hotspotView.titleLabel.text = hotspot.name;
                    } completion:nil];
    _slide++;
}

#pragma mark - UICollectionViewController

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	HotspotDetailsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: [HotspotDetailsCell className] forIndexPath:indexPath];
	cell.collectionLayouts = self.collectionLayouts;
	cell.hotspot = self.hotspots[indexPath.row];
    cell.delegate = self;
    
//    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 0;
	
	return cell;
}

//
- (UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout {
    return [[TLTransitionLayout alloc] initWithCurrentLayout:fromLayout nextLayout:toLayout];
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self showDetailsForIndexPath: (NSIndexPath *) indexPath];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.hotspots.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

#pragma mark - Details

- (void) showDetailsForIndexPath: (NSIndexPath *) indexPath {
	[self stopSlideTimer];

    [self.collectionView cancelInteractiveTransitionInPlaceWithCompletion:nil];

    UICollectionViewLayout *toLayout = self.collectionLayouts.largeLayout; 
    CGFloat duration = 0.7;
    AHEasingFunction easing = QuarticEaseInOut;
    TLTransitionLayout *layout = (TLTransitionLayout *)[self.collectionView transitionToCollectionViewLayout:toLayout duration:duration easing:easing completion:nil];
    
    TLTransitionLayoutIndexPathPlacement placement = TLTransitionLayoutIndexPathPlacementCenter;
    CGPoint toOffset = [self.collectionView toContentOffsetForLayout:layout indexPaths:@[indexPath] placement:placement];
    layout.toContentOffset = toOffset;
    
    [self.collectionView setDecelerationRate: UIScrollViewDecelerationRateNormal];
    [self.view insertSubview: self.hotspotView aboveSubview:self.collectionView];

    
	[self.collectionView setDecelerationRate: UIScrollViewDecelerationRateFast];
	
	[self.view insertSubview: self.hotspotView belowSubview:self.collectionView];
}



- (void) hideDetails {
	[self startSlideTimer];
    [self.collectionView cancelInteractiveTransitionInPlaceWithCompletion:nil];

    UICollectionViewLayout *toLayout = self.collectionLayouts.smallLayout;
    CGFloat duration = 0.7;
    AHEasingFunction easing = CubicEaseInOut;
    TLTransitionLayout *layout = (TLTransitionLayout *)[self.collectionView transitionToCollectionViewLayout:toLayout duration:duration easing:easing completion: ^(BOOL completed, BOOL finished) {
            [self.view insertSubview: self.collectionView belowSubview:self.hotspotView];
    }];

    
}

- (void) shouldCloseHotspotsDetails:(HotspotDetailsCell *)cell {
    [self hideDetails];
}


@end