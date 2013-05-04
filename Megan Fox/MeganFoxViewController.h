//
//  MeganFoxViewController.h
//  Megan Fox
//
//  Created by  Alex Nevsky on 31.03.13.
//  Copyright (c) 2013 Alex Nevsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeganFoxViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;
@property (weak, nonatomic) IBOutlet UIView *buttonSetView;
@property (weak, nonatomic) IBOutlet UIButton *newsButton;
@property (weak, nonatomic) IBOutlet UIButton *imagesButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIButton *aboutButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;

- (IBAction)facebookTap:(id)sender;
- (IBAction)twitterTap:(id)sender;

- (IBAction)tapOnScreen:(id)sender;

@end
