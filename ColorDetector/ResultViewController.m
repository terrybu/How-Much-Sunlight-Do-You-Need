//
//  ResultViewController.m
//  ColorPicker
//
//  Created by Terry Bu on 3/16/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

#import "ResultViewController.h"
#import "Constants.h"

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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sunlightRecoReceived:) name:kSunlightRecoTime object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sunburnTimeReceived:) name:kSunburnTime object:nil];
    
    self.webviewManager = [[WebviewManager alloc]init];
    self.webviewManager.delegate = self;
    self.webviewManager.fitzType = self.pickedFitzType;
    
    self.referenceLabel.text = @"This information was made possible by http://nadir.nilu.no/~olaeng/fastrt/VitD-ez_quartMEDandMED_v2.html, Norwegian Institute for Air Research, Ola Engelsen";
}

- (void) sunlightRecoReceived: (NSNotification *) notification {
    NSDictionary *info = notification.userInfo;
    self.actualSunlightTimeLabel.text = [NSString stringWithFormat:@"%@", [info objectForKey:kSunlightRecoTime]];
}

- (void) sunburnTimeReceived: (NSNotification *) notification {
    NSDictionary *info = notification.userInfo;
    self.actualSunburnTimeLabel.text = [NSString stringWithFormat:@"%@", [info objectForKey:kSunburnTime]];
}

- (IBAction) backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didFinishGettingPlacemarkInfo {
    self.basedOnLocationLabel.text = [NSString stringWithFormat:@"Based on your location at %@, %@ in %@", self.webviewManager.placemark.locality, self.webviewManager.placemark.postalCode, self.webviewManager.placemark.ISOcountryCode];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
