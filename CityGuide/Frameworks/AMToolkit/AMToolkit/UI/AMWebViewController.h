//
//  AMWebViewController.h
//

#import <UIKit/UIKit.h>

@interface AMWebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *pageLoadingActivityIndicator;
@property (nonatomic, weak) IBOutlet UIButton *stopButton;
@property (nonatomic, weak) IBOutlet UIButton *refreshButton;
@property (nonatomic, weak) IBOutlet UIButton *backButton;
@property (nonatomic, weak) IBOutlet UIButton *forwardButton;
@property (nonatomic, weak) IBOutlet UILabel *internetConnectionLabel;

- (id) initWithURLString:(NSString *) urlString;

@end
