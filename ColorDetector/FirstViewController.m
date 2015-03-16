//
//  FirstViewController.m
//  ColorPicker
//
//  Created by Terry Bu on 3/16/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

#import "FirstViewController.h"
#import "UIView+ColorOfPoint.h"
#import "TouchPixelColorView.h"

@interface FirstViewController ()

@property (strong, nonatomic) UIColor *pickedColor;
@property (strong, nonatomic) TouchPixelColorView *touchPixelRectView;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraButton:)];
    self.navigationItem.rightBarButtonItem = cameraButton;
    
    _touchPixelRectView = [[TouchPixelColorView alloc]initWithFrame:CGRectMake(10, 64, self.view.frame.size.width/5, self.view.frame.size.height/5)];
    _touchPixelRectView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_touchPixelRectView];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    if (self.imageView.image != nil) {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButton)];
        self.navigationItem.rightBarButtonItems = @[self.navigationItem.rightBarButtonItem, doneButton];
    }
}


- (IBAction)cameraButton:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Please select one from menu"
                                  delegate:self
                                  cancelButtonTitle:@"No"
                                  destructiveButtonTitle:@"Cancel"
                                  otherButtonTitles:@"Use Camera to Take Photo", @"Use Existing Photos", nil];
    
    [actionSheet showInView:self.view];  
}

- (void) doneButton {
    [self performSegueWithIdentifier:@"resultSegue" sender:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [self showCamera];
            break;
        case 2:
            [self showPhotosAlbum];
            break;
        default:
            break;
    }
}

- (void) showCamera {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.allowsEditing = NO;
        imagePickerController.editing = NO;
        imagePickerController.delegate = self;
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    else{
        NSLog(@"camera invalid");
    }
}

- (void) showPhotosAlbum {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.allowsEditing = NO;
    imagePickerController.editing = NO;
    imagePickerController.delegate = self;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (img) {
        self.imageView.image = img;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGFloat red, green, blue, alpha;

    UITouch *touch = [[event allTouches] anyObject];
    CGPoint loc = [touch locationInView:self.view];
    self.pickedColor = [self.view colorOfPoint:loc];
    
    [self.pickedColor getRed:&red green:&green blue:&blue alpha:&alpha];
    NSLog(@"red %f green %f blue %f alpha %f", red, green, blue, alpha);
    
    self.touchPixelRectView.backgroundColor = self.pickedColor;
    
    if (self.touchPixelRectView.redLab == nil && self.touchPixelRectView.greenLab == nil && self.touchPixelRectView.blueLab == nil) {
        self.touchPixelRectView.redLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.touchPixelRectView.bounds), 20)];
        self.touchPixelRectView.greenLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.touchPixelRectView.bounds), 20)];
        self.touchPixelRectView.blueLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.touchPixelRectView.bounds), 20)];
        [self.touchPixelRectView addSubview:self.touchPixelRectView.redLab];
        [self.touchPixelRectView addSubview:self.touchPixelRectView.greenLab];
        [self.touchPixelRectView addSubview:self.touchPixelRectView.blueLab];
        self.touchPixelRectView.redLab.textColor = [UIColor redColor];
        self.touchPixelRectView.greenLab.textColor = [UIColor greenColor];
        self.touchPixelRectView.blueLab.textColor = [UIColor blueColor];
    }
    self.touchPixelRectView.redLab.text = [NSString stringWithFormat:@"Red: %f", red];
    self.touchPixelRectView.greenLab.text = [NSString stringWithFormat:@"Green: %f", green];
    self.touchPixelRectView.blueLab.text = [NSString stringWithFormat:@"Blue: %f", blue];

    //adding a subview within a subview makes you understand frames better
    //Realize that when you add a label to a subview, the label's "frame" value will refer to the subview's frame.
    
    //If you add a subview to this view controller's view, the subview' frame (0, 64) refers to go 0 pixels from left-most point of the parent view, and then go 64 pixels down from the top of the parent view, and then place the subview there
    
    //But if you want to add a label INSIDE that subview and say initWithFrame(0,64), it refers to go 0 pixels from left-most point of the SUBVIEW and then go 64 pixels down from the top of the SUBVIEW ... and not vc's self.view
    
    //So for this example, note that the green label goes 20 pixels down from the top of the rectView, anod not just 20 pixels down from the parent view (which would be covered by the navbar and not shown anyways)
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
