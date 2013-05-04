//
//  VideoViewController.m
//  Megan Fox
//
//  Created by  Alex Nevsky on 11.04.13.
//  Copyright (c) 2013 Alex Nevsky. All rights reserved.
//

#import "VideoViewController.h"

@interface VideoViewController ()

@end

@implementation VideoViewController {
    UIActivityIndicatorView *loadingIndicator;
}

@synthesize webView = _webView;
@synthesize backImageView = _backImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.atenwood.com/megan-fox/pages/video.html"]]];
    
    loadingIndicator = [[UIActivityIndicatorView alloc] init];
    [loadingIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loadingIndicator setColor:[UIColor redColor]];
    [loadingIndicator setHidesWhenStopped:YES];
    [_webView addSubview:loadingIndicator];
    
    _webView.scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    _backImageView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [loadingIndicator setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [loadingIndicator startAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    _backImageView.hidden = YES;
    [loadingIndicator setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [loadingIndicator stopAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if ([_webView canGoBack]) {
        _backImageView.hidden = NO;
        
        [[self.navigationController navigationBar] setTranslucent:NO];
    } else {
        _backImageView.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backTap:(id)sender {
    if ([_webView canGoBack]) {
        [_webView goBack];
        
        [[self.navigationController navigationBar] setTranslucent:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES]; // or popToRoot... if required.
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [loadingIndicator setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
}

@end
