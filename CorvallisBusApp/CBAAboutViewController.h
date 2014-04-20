//
//  CBAAboutViewController.h
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 4/20/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBAAboutViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *cezaryWojcikButton;
@property (weak, nonatomic) IBOutlet UIButton *russelBarnesButton;
@property (weak, nonatomic) IBOutlet UIButton *legalButton;

- (IBAction)cezaryWojcikButtonPressed:(UIButton *)sender;
- (IBAction)russelBarnesButtonPressed:(UIButton *)sender;
- (IBAction)legalButtonPressed:(UIButton *)sender;

@end
