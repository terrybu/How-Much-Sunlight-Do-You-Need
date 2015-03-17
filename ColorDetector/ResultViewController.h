//
//  ResultViewController.h
//  ColorPicker
//
//  Created by Terry Bu on 3/16/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitzpatrickType.h"

@interface ResultViewController : UIViewController <UINavigationBarDelegate>

@property (strong, nonatomic) FitzpatrickType *pickedFitzType;
@property (strong, nonatomic) UIColor *pickedColor;

@property IBOutlet UILabel *typeLabel;
@property IBOutlet UIImageView *imageView;
@property IBOutlet UILabel *resultMessageLabel;


- (IBAction) backButton:(id)sender;

@end
