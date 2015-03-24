//
//  HotspotSiteViewController.m
//  CityGuide
//
//  Created by Vladislav Zozulyak on 25.03.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

#import "HotspotSiteViewController.h"
#import "CityGuide-Swift.h"

@interface HotspotSiteViewController () <UIWebViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation HotspotSiteViewController

- (id) initWithHotspot: (Hotspot *) hotspot {
    if (self = [super init]) {
        self.hotspot = hotspot;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([_hotspot.name isValid])
        self.titleLabel.text = _hotspot.name;
    
    NSString *urlStr = _hotspot.site;
    if (![urlStr hasPrefix:@"http"]) {
        urlStr = [NSString stringWithFormat:@"http://%@", urlStr];
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void) showLoading {
    [self.activityIndicator startAnimating];
}

- (void) hideLoading {
    [self.activityIndicator stopAnimating];
}

- (void) webViewDidStartLoad:(UIWebView *)webView {
    [self showLoading];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    [self hideLoading];
}

- (BOOL) prefersStatusBarHidden {
    return YES;
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Web view failed with error: %@", error);
    [self hideLoading];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAppName message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
