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
    
    [self comparePickedColorToFitzpatrickTypes:self.pickedColor];
}

- (void) comparePickedColorToFitzpatrickTypes: (UIColor *) pickedColor {
    CGFloat r1, g1, b1, a1, r2, g2, b2, a2;
    [pickedColor getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    //I'm going to get the CGFLoat RGB values (0 being black and 1 being white) of the picked Color
    
    //this is a float to count the differences between the pickedColor and a Fitzpatrick Type.
    //if the score is the smallest, that type is the one we will say the MOST SIMILAR to the picked Color
    float disparityScore = 0;
    
    //Instantiate FitzpatrickType objects
    FitzpatrickType *type1 = [[FitzpatrickType alloc]initWithType:Type1];
    FitzpatrickType *type2 = [[FitzpatrickType alloc]initWithType:Type2];
    FitzpatrickType *type3 = [[FitzpatrickType alloc]initWithType:Type3];
    FitzpatrickType *type4 = [[FitzpatrickType alloc]initWithType:Type4];
    FitzpatrickType *type5 = [[FitzpatrickType alloc]initWithType:Type5];
    FitzpatrickType *type6 = [[FitzpatrickType alloc]initWithType:Type6];

    //Get all the types into an array
    NSArray *fitzpatrickArray = @[  type1, type2, type3, type4, type5, type6 ];
    NSMutableArray *scoresArray = [[NSMutableArray alloc]init];
    
    //we are going to get sum of the abs value difference between pickedColor and FitzpatrickTypes.
    for (int i=0; i < fitzpatrickArray.count; i++) {
        FitzpatrickType *fitz = fitzpatrickArray[i];
        UIColor *colorToCheck = fitz.uiColor;
        [colorToCheck getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
        if (disparityScore == 0) {
            disparityScore = fabs(r1-r2) + fabs(g1-g2) + fabs(b1-b2);
            [scoresArray addObject:[NSNumber numberWithFloat:disparityScore]];
        }
        else {
            float temp = fabs(r1-r2) + fabs(g1-g2) + fabs(b1-b2);
            disparityScore = fminf(disparityScore, temp);
            [scoresArray addObject:[NSNumber numberWithFloat:temp]];
        }
    }
    
    //The scoresArray is to keep track of WHICH TYPE had the lowest disparity score.
    NSNumber *disparityScoreWrapped = [NSNumber numberWithFloat:disparityScore];
    int indexOfDisparity = [scoresArray indexOfObject:disparityScoreWrapped];
    FitzpatrickType *mostSimilarType = fitzpatrickArray[indexOfDisparity];
    
    NSLog(@"%@", mostSimilarType.typeName);
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"resultSegue"])
    {
        UINavigationController *destination = segue.destinationViewController;
        ResultViewController *rvc = (ResultViewController *) destination.topViewController;
        rvc.pickedColor = self.pickedColor;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
