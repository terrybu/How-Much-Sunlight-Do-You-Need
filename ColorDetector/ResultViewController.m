//
//  ResultViewController.m
//  ColorPicker
//
//  Created by Terry Bu on 3/16/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

#import "ResultViewController.h"
#import "Constants.h"
#import "Reachability.h"

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
    [self.webviewManager loadUp];
    
    self.referenceLabel.text = @"This information was made possible by http://nadir.nilu.no/~olaeng/fastrt/VitD-ez_quartMEDandMED_v2.html, Norwegian Institute for Air Research, Ola Engelsen";
    
    Reachability* curReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [curReach currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        NSLog(@"internet reachable");
    }
    else {
        NSLog(@"internet UNREACHABLE");
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"No Internet"
                                                                       message:@"Some functionality like location-based and weather-based sunlight calculation will not work without internet."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okayAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {}];
        [alert addAction:okayAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
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


#pragma mark WebViewManager Delegate
- (void)didFinishGettingPlacemarkInfo {
    self.basedOnLocationLabel.text = [NSString stringWithFormat:@"Based on your location at %@, %@ in %@", self.webviewManager.placemark.locality, self.webviewManager.placemark.postalCode, self.webviewManager.placemark.ISOcountryCode];
}

- (void) didFinishGettingAllWeatherData {
    WeatherManager *weatherManager = [WeatherManager sharedWeatherManager];
    if (weatherManager.cloudsLevel <= 20) {
        self.sunCloudsIconImageView.image = [UIImage imageNamed:@"sun"];
    }
    else if (weatherManager.cloudsLevel > 20 && weatherManager.cloudsLevel < 60) {
        self.sunCloudsIconImageView.image = [UIImage imageNamed:@"broken"];
    }
    else if (weatherManager.cloudsLevel >= 60) {
        self.sunCloudsIconImageView.image = [UIImage imageNamed:@"clouds"];
    }
    self.cloudsStatusLabel.text = weatherManager.weatherDescriptionString;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
