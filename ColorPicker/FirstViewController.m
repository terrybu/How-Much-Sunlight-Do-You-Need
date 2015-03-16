//
//  FirstViewController.m
//  ColorPicker
//
//  Created by Terry Bu on 3/16/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

#import "FirstViewController.h"
#import "UIView+ColorOfPoint.h"

@interface FirstViewController ()

@property (strong, nonatomic) UIColor *pickedColor;
@property (strong, nonatomic) UIView *rectView;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _rectView = [[UIView alloc]initWithFrame:CGRectMake(10, 64, self.view.frame.size.width/5, self.view.frame.size.height/5)];
    _rectView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_rectView];
}

- (IBAction)cameraButton:(id)sender {
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
    
    self.rectView.backgroundColor = self.pickedColor;
    UILabel *redLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.rectView.bounds), 20)];
    UILabel *greenLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.rectView.bounds), 20)];
    UILabel *blueLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.rectView.bounds), 20)];
    
    NSLog(@"frame of rectview origin y :%f", _rectView.frame.origin.y);

    redLab.text = [NSString stringWithFormat:@"Red: %f", red];
    redLab.textColor = [UIColor redColor];
    greenLab.text = [NSString stringWithFormat:@"Green: %f", green];
    greenLab.textColor = [UIColor greenColor];
    blueLab.text = [NSString stringWithFormat:@"Blue: %f", blue];
    blueLab.textColor = [UIColor blueColor];
    
    [_rectView addSubview:redLab];
    [_rectView addSubview:greenLab];
    [_rectView addSubview:blueLab];
    
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
