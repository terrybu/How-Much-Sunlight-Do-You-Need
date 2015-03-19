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
    
    self.fbShimmerView.contentView = self.typeLabel;
    self.typeLabel.text = self.pickedFitzType.typeName;
    self.fbShimmerView.shimmering = YES;
    self.fbShimmerView.shimmeringAnimationOpacity = 0.2; //makes the shimmer dramatic lower the value
    
    self.selectionView.backgroundColor = self.pickedColor;
    self.selectionView.layer.borderColor = [UIColor blackColor].CGColor;
    self.selectionView.layer.borderWidth = 1.5;
    
    self.resultMessageLabel.text = self.pickedFitzType.resultMessage;
    self.actualTypeColorLabel.text = self.pickedFitzType.typeName;
    
    self.actualTypeColorView.backgroundColor = self.pickedFitzType.uiColor;
    self.actualTypeColorView.layer.borderColor = [UIColor blackColor].CGColor;
    self.actualTypeColorView.layer.borderWidth = 1.5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
