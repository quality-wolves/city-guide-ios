//
//  AMWebViewController.m
//

#import "AMWebViewController.h"
#import "AMServiceProvider.h"
#import "UIView+Frame.h"
#import "NSObject+ClassName.h"

@interface AMWebViewController ()

@property (nonatomic, copy) NSString *startUrl;
@property (nonatomic, strong) AFHTTPClient *reachabilityClient;

@end

@implementation AMWebViewController

- (id) initWithURLString:(NSString *) urlString {
	if (self = [super init]) {
		self.startUrl = urlString;
	}
	return self;
}

- (void) viewDidLoad {
	[super viewDidLoad];
	if (self.presentingViewController) {
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeView:)];
	}
}

- (void) loadView {
	NSString *nibName = self.nibName ? self.nibName : [self className];
    NSString *nibPath = [[NSBundle mainBundle] pathForResource:nibName ofType:@"nib"];
	if (nibPath) {
		[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
	} else {
		UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		view.backgroundColor = [UIColor whiteColor];
		view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
								| UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
								| UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;

		UIWebView *webView = [[UIWebView alloc] initWithFrame:view.bounds];
		webView.delegate = self;
		webView.autoresizingMask = view.autoresizingMask;
		_webView = webView;
		
		UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		activityIndicator.x = (view.width - activityIndicator.width)/2;
		activityIndicator.y = (view.height - activityIndicator.height)/2;
		activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
		| UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		_pageLoadingActivityIndicator = activityIndicator;
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.width, view.height)];
		label.text = NSLocalizedString(@"The Internet connection appears to be offline.", @"");
		label.numberOfLines = 0;
		label.textAlignment = NSTextAlignmentCenter;
		label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
		| UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		[label sizeToFit];
		label.x = (view.width - label.width)/2;
		label.y = (view.height - label.height)/2;
		_internetConnectionLabel = label;
		
		[view addSubview:_internetConnectionLabel];
		[view addSubview:_webView];
		[view addSubview:activityIndicator];
		self.view = view;
	}
}


- (void) viewDidAppear: (BOOL) animated {
	[super viewWillAppear:YES];
    [self reloadButtons];
	self.reachabilityClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:self.startUrl]];
	__block AMWebViewController *weakSelf = self;
	[self.reachabilityClient setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
		[weakSelf proccessReachabilityStatus:status];
	}];
}

- (void) proccessReachabilityStatus:(AFNetworkReachabilityStatus) status {
	if (status == AFNetworkReachabilityStatusUnknown)
		return;
	if (status != AFNetworkReachabilityStatusNotReachable) {
		_internetConnectionLabel.hidden = YES;
		_webView.hidden = NO;
		_pageLoadingActivityIndicator.alpha = 1.;
		if (_startUrl && !_webView.isLoading)
			[_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_startUrl]]];
		[self.reachabilityClient setReachabilityStatusChangeBlock:nil];
		self.reachabilityClient = nil;

	} else {
		_internetConnectionLabel.hidden = NO;
		_webView.hidden = YES;
		_pageLoadingActivityIndicator.alpha = 0.;
	}
	
}

- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.reachabilityClient setReachabilityStatusChangeBlock:nil];
	self.reachabilityClient = nil;
}

- (void) webViewDidStartLoad: (UIWebView *) webView {
    [self reloadButtons];
    [UIView animateWithDuration:0.2f animations:^{
        _pageLoadingActivityIndicator.alpha = 1.0f;
        _stopButton.alpha = 1.0f;
    }];
	[_pageLoadingActivityIndicator startAnimating];
}

- (void) reloadButtons {
    _backButton.enabled = _webView.canGoBack;
    _forwardButton.enabled = _webView.canGoForward;
}

- (void) webViewDidFinishLoad: (UIWebView *) webView {
    [self reloadButtons];
    [UIView animateWithDuration:0.2f animations:^{
        _pageLoadingActivityIndicator.alpha = 0.0f;
        _stopButton.alpha = 0.0f;
    }];
	[_pageLoadingActivityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    _internetConnectionLabel.text = error.localizedDescription;
    [self webViewDidFinishLoad:webView];
}

- (void) closeView: (id) sender {
	if (self.presentingViewController)
		[self dismissViewControllerAnimated:YES completion:nil];
}

@end
