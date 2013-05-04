//
//  ImagesViewController.h
//  Megan Fox
//
//  Created by  Alex Nevsky on 11.04.13.
//  Copyright (c) 2013 Alex Nevsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagesViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *backTapGestureRecognizer;

- (IBAction)backTap:(id)sender;

@end
