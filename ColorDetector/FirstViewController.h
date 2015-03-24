//
//  FirstViewController.h
//  ColorPicker
//
//  Created by Terry Bu on 3/16/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property IBOutlet UIImageView *imageView;
@property IBOutlet UIImageView *sunGlassesView;
@property IBOutlet UILabel *tapAnywhereLabel;




- (IBAction)cameraButton:(id)sender;




@end

