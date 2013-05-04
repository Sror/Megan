//
//  MeganFoxViewController.m
//  Megan Fox
//
//  Created by  Alex Nevsky on 31.03.13.
//  Copyright (c) 2013 Alex Nevsky. All rights reserved.
//

#import "MeganFoxViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Social/Social.h>
#import "Reachability.h"

@interface MeganFoxViewController ()

- (void)reachabilityChanged:(NSNotification*)note;

@end

@implementation MeganFoxViewController {
    CGRect screenBounds;
    CGFloat screenScale;
    CGSize screenSize;
    NSString *textToShare;
    NSString *twitterTextToShare;
    UIImage *imageToShare;
    NSURL *urlToShare;
    UIAlertView *networkAlert;
    UINavigationBar *navigationBar;
}

@synthesize backgroundImageView = _backgroundImageView;
@synthesize tapRecognizer = _tapRecognizer;
@synthesize buttonSetView = _buttonSetView;
@synthesize newsButton = _newsButton;
@synthesize imagesButton = _imagesButton;
@synthesize videoButton = _videoButton;
@synthesize aboutButton = _aboutButton;
@synthesize facebookButton = _facebookButton;
@synthesize twitterButton = _twitterButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    screenBounds = [[UIScreen mainScreen] bounds];
    screenScale = [[UIScreen mainScreen] scale];
    screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
    
    navigationBar = [self.navigationController navigationBar];
    [navigationBar setBarStyle:UIBarStyleBlack];
    [navigationBar setTranslucent:YES];
    navigationBar.hidden = YES;
    
    float offset = 0;
    if (!navigationBar.hidden) {
        offset = navigationBar.frame.size.height * screenScale;
    }
    
    UIImage *bgImage = [UIImage imageNamed:@"Megan-Fox-Black-And-White.jpg"];
    UIImage *newBgImage = [self imageWithImage:bgImage trimToSize:CGSizeMake(screenSize.width, screenSize.height - offset)];
    [_backgroundImageView setImage:newBgImage];
    
    [self custominizeButtonStyle:_newsButton];
    [self custominizeButtonStyle:_imagesButton];
    [self custominizeButtonStyle:_videoButton];
    [self custominizeButtonStyle:_aboutButton];
    
    [self custominizeShareButtons];
    
    textToShare = @"Oh, Megan... She is so amazing and stunning! Don't miss her iPhone app!";
    twitterTextToShare = @"Oh, Megan is so amazing and stunning! Don't miss her iPhone app!";
    imageToShare = [UIImage imageNamed:@"Megan-Fox-Black-And-White.jpg"];
    urlToShare = [NSURL URLWithString:@"https://www.facebook.com/Megan.Actress"];
    
    networkAlert = [[UIAlertView alloc] initWithTitle:@"Network connection" message:@"You must be connected to the Internet to use this app." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [self testReachability];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    navigationBar.hidden = YES;
    
    UIInterfaceOrientation uiInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (uiInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || uiInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        [_backgroundImageView setImage:[UIImage imageNamed:@"Megan-Fox-Tree-Armani-Landscape.jpg"]];
    } else {
        float offset = 0;
        if (!navigationBar.hidden) {
            offset = navigationBar.frame.size.height * screenScale;
        }
        
        UIImage *bgImage = [UIImage imageNamed:@"Megan-Fox-Black-And-White.jpg"];
        UIImage *newBgImage = [self imageWithImage:bgImage trimToSize:CGSizeMake(screenSize.width, screenSize.height - offset)];
        [_backgroundImageView setImage:newBgImage];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    navigationBar.hidden = NO;
}

- (UIImage *)imageWithImage:(UIImage *)image trimToSize:(CGSize)newSize {
    float trimFromX = 0;
    
    if (screenSize.width < 640) {
        trimFromX = newSize.width;
    }
    
    CGRect clippedRect  = CGRectMake(trimFromX, 0, newSize.width, newSize.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], clippedRect);
    UIImage *newImage   = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return newImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)facebookTap:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        //  Create an instance of the Facebook Sheet
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        // Sets the completion handler.  Note that we don't know which thread the
        // block will be called on, so we need to ensure that any UI updates occur
        // on the main queue
        controller.completionHandler = ^(SLComposeViewControllerResult result) {
            switch(result) {
                    //  This means the user cancelled without sending the Post
                case SLComposeViewControllerResultCancelled:
                    break;
                    //  This means the user hit 'Share'
                case SLComposeViewControllerResultDone:
                    break;
                default:
                    break;
            }
            
            //  Dismiss the Facebook Sheet
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:^{
                }];
            });
        };

        //  Set the initial body of the Post
        [controller setInitialText:textToShare];
        
        //  Adds an image to the Post
        if (![controller addImage:imageToShare]) {
            NSLog(@"Unable to add the image!");
        }
        
        //  Add an URL to the Post. You can add multiple URLs.
        if (![controller addURL:urlToShare]){
            NSLog(@"Unable to add the URL!");
        }
        
        //  Presents the Facebook Sheet to the user
        [self presentViewController:controller animated:YES completion:^{
        }];
    }
}

- (IBAction)twitterTap:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        //  Create an instance of the Tweet Sheet
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        // Sets the completion handler.  Note that we don't know which thread the
        // block will be called on, so we need to ensure that any UI updates occur
        // on the main queue
        controller.completionHandler = ^(SLComposeViewControllerResult result) {
            switch(result) {
                    //  This means the user cancelled without sending the Tweet
                case SLComposeViewControllerResultCancelled:
                    break;
                    //  This means the user hit 'Send'
                case SLComposeViewControllerResultDone:
                    break;
                default:
                    break;
            }
            
            //  Dismiss the Tweet Sheet
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:^{
                }];
            });
        };
        
        //  Set the initial body of the Tweet
        [controller setInitialText:twitterTextToShare];
        
        //  Adds an image to the Tweet.
        if (![controller addImage:imageToShare]) {
            NSLog(@"Unable to add the image!");
        }
        
        //  Add an URL to the Tweet.  You can add multiple URLs.
        if (![controller addURL:urlToShare]){
            NSLog(@"Unable to add the URL!");
        }
        
        //  Presents the Tweet Sheet to the user
        [self presentViewController:controller animated:YES completion:^{
        }];
    }
}

- (IBAction)tapOnScreen:(id)sender {
    if (_buttonSetView.hidden) {
        _buttonSetView.hidden = NO;
        
        //[NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(hideButtonMenu) userInfo:nil repeats:NO];
    } else {
        _buttonSetView.hidden = YES;
    }
}

- (void)hideButtonMenu
{
    _buttonSetView.hidden = YES;
}

- (void)custominizeButtonStyle:(UIButton *)button
{
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    button.tintColor = [UIColor blackColor];
    
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.borderWidth = 0.5f;
    button.layer.cornerRadius = 10.0f;
    
    button.layer.masksToBounds = NO;
    button.layer.shadowColor = [UIColor redColor].CGColor;
    button.layer.shadowOpacity = 0.75;
    button.layer.shadowRadius = 12;
    button.layer.shadowOffset = CGSizeMake(9.0f, 9.0f);
}

- (void)custominizeShareButtons
{
    _facebookButton.imageView.layer.cornerRadius = 10.0f;
    _twitterButton.imageView.layer.cornerRadius = 10.0f;
    
    _facebookButton.layer.masksToBounds = NO;
    _facebookButton.layer.shadowColor = [UIColor redColor].CGColor;
    _facebookButton.layer.shadowOpacity = 0.75;
    _facebookButton.layer.shadowRadius = 12;
    _facebookButton.layer.shadowOffset = CGSizeMake(9.0f, 9.0f);
    
    _twitterButton.layer.masksToBounds = NO;
    _twitterButton.layer.shadowColor = [UIColor redColor].CGColor;
    _twitterButton.layer.shadowOpacity = 0.75;
    _twitterButton.layer.shadowRadius = 12;
    _twitterButton.layer.shadowOffset = CGSizeMake(9.0f, 9.0f);
}

- (void)testReachability
{
    // here we set up a NSNotification observer.
    // the Reachability that caused the notification is passed in the object parameter
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    // allocate a reachability object
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.atenwood.com"];
    
    // start the notifier which will cause the reachability object to retain itself!
    [reach startNotifier];
}

- (void)reachabilityChanged:(NSNotification*)note
{
    /*
     NSNotifications to tell you when the interface has changed.
     They will be delivered on the MAIN THREAD so you can do UI updates from within the function.
     */
    
    Reachability *reach = [note object];
    
    if ([reach isReachable]) {
        _buttonSetView.hidden = NO;
        
        _newsButton.enabled = YES;
        _imagesButton.enabled = YES;
        _videoButton.enabled = YES;
        _aboutButton.enabled = YES;
        
        [networkAlert dismissWithClickedButtonIndex:0 animated:YES];
    } else {
        _buttonSetView.hidden = YES;
        
        _newsButton.enabled = NO;
        _imagesButton.enabled = NO;
        _videoButton.enabled = NO;
        _aboutButton.enabled = NO;
        
        [networkAlert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) { // OK
        //do something
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        [_backgroundImageView setImage:[UIImage imageNamed:@"Megan-Fox-Tree-Armani-Landscape.jpg"]];
    } else {
        float offset = 0;
        if (!navigationBar.hidden) {
            offset = navigationBar.frame.size.height * screenScale;
        }
        
        UIImage *bgImage = [UIImage imageNamed:@"Megan-Fox-Black-And-White.jpg"];
        UIImage *newBgImage = [self imageWithImage:bgImage trimToSize:CGSizeMake(screenSize.width, screenSize.height - offset)];
        [_backgroundImageView setImage:newBgImage];
    }
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
