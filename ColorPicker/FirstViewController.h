//
//  FirstViewController.h
//  ColorPicker
//
//  Created by Terry Bu on 3/16/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property IBOutlet UIImageView *imageView;


- (IBAction)cameraButton:(id)sender;

@end

