//
//  ResultViewController.m
//  ColorPicker
//
//  Created by Terry Bu on 3/16/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

#import "ResultViewController.h"

@interface ResultViewController ()

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.typeLabel.text = self.pickedFitzType.typeName;
    self.imageView.backgroundColor = self.pickedColor;
    self.resultMessageLabel.text = self.pickedFitzType.resultMessage;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
