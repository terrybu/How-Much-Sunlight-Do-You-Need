//
//  ResultViewController.h
//  ColorPicker
//
//  Created by Terry Bu on 3/16/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultViewController : UIViewController <UINavigationBarDelegate>

@property (strong, nonatomic) UIColor *pickedColor;


@property IBOutlet UIImageView *imageView;


- (IBAction) backButton:(id)sender;

@end
