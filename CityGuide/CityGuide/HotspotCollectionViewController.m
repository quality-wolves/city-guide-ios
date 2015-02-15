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

#import "CityGuide-Swift.h"

@interface HotspotCollectionViewController () <UINavigationControllerDelegate, HATransitionControllerDelegate>

@property (nonatomic, strong) HATransitionController *transitionController;

@property (nonatomic, assign) NSInteger slide;
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIImageView *topImage;
@property (nonatomic, strong) UIImageView *reflected;

@property (nonatomic, strong) NSArray *hotspots;
@property (nonatomic, strong) HotspotCollectionView *hotspotView;

@end

@implementation HotspotCollectionViewController

- (id) init {
    HACollectionViewSmallLayout *smallLayout = [[HACollectionViewSmallLayout alloc] init];
    if (self = [super initWithCollectionViewLayout:smallLayout]) {
    }
	
    return self;
}

- (id) initWithHotspots: (NSArray*) hotspots {
	if(self = [self init]) {
		self.hotspots = hotspots;
		[self internalViewDidLoad];
	}
	
	return self;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc = [self nextViewControllerAtPoint:CGPointZero];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UICollectionViewController *)nextViewControllerAtPoint:(CGPoint)point
{
    // We could have multiple section stacks and find the right one,
    HACollectionViewLargeLayout *largeLayout = [[HACollectionViewLargeLayout alloc] init];
    HAPaperCollectionViewController *nextCollectionViewController = [[HAPaperCollectionViewController alloc] initWithCollectionViewLayout:largeLayout];
    
    nextCollectionViewController.useLayoutToLayoutNavigationTransitions = YES;
    return nextCollectionViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.transitionController = [[HATransitionController alloc] initWithCollectionView: self.collectionView];
	self.transitionController.delegate = self;

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
    
    
    // First Load
    [self changeSlide];
    
    // Loop gallery - fix loop: http://bynomial.com/blog/?p=67
    NSTimer *timer = [NSTimer timerWithTimeInterval:5.0f target:self selector:@selector(changeSlide) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void) internalViewDidLoad {
	self.hotspotView = [HotspotCollectionView create];
	
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

	[self changeSlide];
}

- (void)interactionBeganAtPoint:(CGPoint)point
{
	// Very basic communication between the transition controller and the top view controller
	// It would be easy to add more control, support pop, push or no-op
	HotspotCollectionViewController *presentingVC = (HotspotCollectionViewController *)[self.navigationController topViewController];
	HotspotCollectionViewController *presentedVC = (HotspotCollectionViewController *)[presentingVC nextViewControllerAtPoint:point];
	if (presentedVC != nil)
	{
		[self.navigationController pushViewController:presentedVC animated:YES];
	}
	else
	{
		[self.navigationController popViewControllerAnimated:YES];
	}
}

#pragma mark - View

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear: animated];
	
	self.navigationController.delegate = self;
}

- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear: animated];
	
	self.navigationController.delegate = nil;
}

#pragma mark - Change slider

- (void)changeSlide {
	if(!_hotspots)
		return;
		
    //    if (_fullscreen == NO && _transitioning == NO) {
    if(_slide > _hotspots.count - 1)
		_slide = 0;
	
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
    //    }
}

#pragma mark - UINavigationControllerDelegate

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
	if (self.transitionController == animationController) {
		return self.transitionController;
	}
	
	return nil;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
	if(![fromVC isKindOfClass: [UICollectionViewController class]] || ![toVC isKindOfClass: [UICollectionViewController class]])
		return nil;
	
	//        if let frm = fromVC as? UICollectionViewController {
	//            if let tvc = toVC as? UICollectionViewController {
	//                self.transitionController?.navigationOperation = operation
	//                return self.transitionController
	//            }
	//        }
	
	if (!self.transitionController.hasActiveInteraction)
		return nil;
	
	self.transitionController.navigationOperation = operation;
	return self.transitionController;
}

@end