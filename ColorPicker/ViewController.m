//
//  ViewController.m
//  ColorPicker
//
//  Created by Terry Bu on 3/16/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

#import "ViewController.h"
#import "UIView+ColorOfPoint.h"

@interface ViewController ()

@property (strong, nonatomic) UIColor *pickedColor;
@property (strong, nonatomic) UIView *rectView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _rectView = [[UIView alloc]initWithFrame:CGRectMake(0, 66, self.view.frame.size.width/10, self.view.frame.size.height/10)];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
