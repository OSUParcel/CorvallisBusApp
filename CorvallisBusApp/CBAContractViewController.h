//
//  CBAContractViewController.h
//  CorvallisBusApp
//
//  Created by Cezary Wojcik on 4/20/14.
//  Copyright (c) 2014 Corvallis Bus App. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBAContractViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *contractTextView;
@property (strong, nonatomic) NSString *contract;

@end
