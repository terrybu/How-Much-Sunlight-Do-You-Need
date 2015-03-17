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
@property IBOutlet UIImageView *selectionView;
@property IBOutlet UILabel *resultMessageLabel;
@property IBOutlet UILabel *actualTypeColorLabel;
@property IBOutlet UIView *actualTypeColorView;

- (IBAction) backButton:(id)sender;

@end
