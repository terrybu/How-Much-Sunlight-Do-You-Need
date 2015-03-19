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
#import "ColorConstants.h"
#import "FitzpatrickType.h"
#import "ResultViewController.h"

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@interface FirstViewController () {
    UIBarButtonItem *cameraButton;
    UIBarButtonItem *doneButton;
}

@property (strong, nonatomic) UIColor *pickedColor;
@property (strong, nonatomic) TouchPixelColorView *touchPixelRectView;
@property FitzpatrickType *mostSimilarType;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.imageView.backgroundColor = [UIColor blackColor];
    
    cameraButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraButton:)];
    self.navigationItem.rightBarButtonItem = cameraButton;
    
    [self setUpPreviewRect];
}

- (void) setUpPreviewRect {
    float sameLengthForRectSide = self.view.frame.size.width/6;
    _touchPixelRectView = [[TouchPixelColorView alloc]initWithFrame:CGRectMake(0, 0, sameLengthForRectSide, sameLengthForRectSide )];
    _touchPixelRectView.backgroundColor = [UIColor blackColor];
    //border
    _touchPixelRectView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _touchPixelRectView.layer.borderWidth = 1.5f;
    // drop shadow
    [_touchPixelRectView.layer setShadowColor:[UIColor grayColor].CGColor];
    [_touchPixelRectView.layer setShadowOpacity:3.0];
    [_touchPixelRectView.layer setShadowRadius:3.0];
    [_touchPixelRectView.layer setShadowOffset:CGSizeMake(3.0, 3.0)];
    [self.view addSubview:_touchPixelRectView];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    if (self.imageView.image == nil) {
        self.title = @"Select or take photo";
        _touchPixelRectView.hidden = YES;
        [self showActionSheet];
    }
    else if (self.imageView.image != nil) {
        self.title = @"Tap photo";
        self.navigationItem.leftBarButtonItem = cameraButton;
        doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Calculate" style:UIBarButtonItemStyleDone target:self action:@selector(showResultButton)];
        
        self.navigationItem.rightBarButtonItem = (self.pickedColor != nil) ? doneButton : nil;
        
    }
}

#pragma mark Touch and Navigation

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.imageView.image != nil) {
        CGFloat red, green, blue, alpha;
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint loc = [touch locationInView:self.view];
        self.pickedColor = [self.view colorOfPoint:loc];
        
        [self.pickedColor getRed:&red green:&green blue:&blue alpha:&alpha];
        NSLog(@"red %f green %f blue %f alpha %f", red, green, blue, alpha);
        
        self.touchPixelRectView.backgroundColor = self.pickedColor;
        _touchPixelRectView.hidden = NO;
        self.navigationItem.rightBarButtonItem = doneButton;
        
        _mostSimilarType = [FitzpatrickType comparePickedColorToFitzpatrickTypes:self.pickedColor];
        
        //    [self showRGBInPreview:red green:green blue:blue];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"resultSegue"])
    {
        UINavigationController *destination = segue.destinationViewController;
        ResultViewController *rvc = (ResultViewController *) destination.topViewController;
        rvc.pickedColor = _pickedColor;
        rvc.pickedFitzType = _mostSimilarType;
    }
}



#pragma mark IBAction and other actions related
- (IBAction)cameraButton:(id)sender {
    [self showActionSheet];
}


- (void) showActionSheet {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    alert.view.tintColor = Rgb2UIColor(205, 50, 100);
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {}];
    
    [alert addAction:cancelAction];
    
    UIAlertAction* showCameraAction = [UIAlertAction actionWithTitle:@"Take new photo with camera" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action)
                                       {
                                           [self showCamera];
                                           
                                       }];
    
    [alert addAction:showCameraAction];
    
    UIAlertAction* usePhotos = [UIAlertAction actionWithTitle:@"Use existing photos" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          [self showPhotosAlbum];
                                                      }];
    
    [alert addAction:usePhotos];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


- (void) showResultButton {
    [self performSegueWithIdentifier:@"resultSegue" sender:nil];
}


#pragma mark Camera Methods
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



#pragma mark Custom Logic for Color Comparisons
- (void)showRGBInPreview:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
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
    self.touchPixelRectView.redLab.text = [NSString stringWithFormat:@"%.f", red *255];
    self.touchPixelRectView.greenLab.text = [NSString stringWithFormat:@"%.f", green *255];
    self.touchPixelRectView.blueLab.text = [NSString stringWithFormat:@"%.f", blue *255];
    
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
