//
//  WebviewManager.m
//  FitzpatrickSkinTypeDetector
//
//  Created by Terry Bu on 3/23/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

#import "WebviewManager.h"
#import "Constants.h"
#import "WeatherManager.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@implementation WebviewManager {
    CLLocationManager *locationManager;
    NSString *latitude;
    NSString *longitude;
}


-(id) init {
    self = [super init];
    self.webView = [[UIWebView alloc]init];
    
    [self loadUp];
    
    return self;
}

- (void) loadUp {
    [self.webView loadRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:kFormPageURL]]];
    self.webView.delegate = self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    if ([webView.request.URL.absoluteString isEqualToString:kFormPageURL]){
        [self webViewSetCorrectDate];
        [self webViewSetCorrectLocation];
        [self webViewSetFitzgeraldSkinType: self.fitzType.typeNumber];
    }
    
    if ([webView.request.URL.absoluteString isEqualToString:kResultPageURL]) {
        NSString *resultPageHTML = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
        NSArray *components = [resultPageHTML componentsSeparatedByString:@"<br>"];
        NSString *sanitizedMinRecoString = [components[4] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *resultMinRecoString = [self stringParseIntoHoursMins:sanitizedMinRecoString];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kSunlightRecoTime object:nil userInfo:@{ kSunlightRecoTime : resultMinRecoString }];
        
        NSString *sanitizedUVExposureTimeToObtainSunburn = [components[components.count-1] stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
        sanitizedUVExposureTimeToObtainSunburn = [sanitizedUVExposureTimeToObtainSunburn stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *resultSunburnString = [self stringParseIntoHoursMins:sanitizedUVExposureTimeToObtainSunburn];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kSunburnTime object:nil userInfo:@{ kSunburnTime : resultSunburnString }];
    }
}


#pragma mark Custom JavaScript to Inject Correct Info to Form
- (void) webViewSetCorrectDate {
    NSDate *today = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:today];
    
    //setting month
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByName(\"month\")[0].options[%d].selected = true", (int) [components month]-1]]; //because the 0th index is january and 11th index is dec
    
    //setting day
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByName(\"mday\")[0].options[%d].selected = true", (int) [components day]-1]]; //because the 0th index is january and 11th index is dec
}

- (void) webViewSetCorrectLocation {
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    if(IS_OS_8_OR_LATER){
        NSUInteger code = [CLLocationManager authorizationStatus];
        if (code == kCLAuthorizationStatusNotDetermined && ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                [locationManager requestAlwaysAuthorization];
            } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                [locationManager  requestWhenInUseAuthorization];
            } else {
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
    }
    [locationManager startMonitoringSignificantLocationChanges];
}

- (void) webViewSetFitzgeraldSkinType: (FitzpatrickTypeNum) typeNum {
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByName(\"skin_index\")[%d].checked = true", typeNum]]; //i was confused about indexing here but TypeNum correctly corresponds to the right index on the web side too, leave it
}

- (void) webViewClickSubmitButton {
    [self.webView stringByEvaluatingJavaScriptFromString:@"var inputs = document.getElementsByTagName('input'); for(var i = 0; i < inputs.length; i++) {if(inputs[i].type.toLowerCase() == 'submit') {inputs[i].click();}}"];
}



#pragma mark - CoreLocation Methods
- (void)locationManager:(CLLocationManager *)locationManager didUpdateLocations:(NSArray *)locations {
    CLLocation *myLocation = [locations lastObject];
    latitude = [[NSNumber numberWithFloat:myLocation.coordinate.latitude] stringValue];
    longitude = [[NSNumber numberWithFloat:myLocation.coordinate.longitude] stringValue];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:myLocation
                   completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error){
             NSLog(@"Geocode failed with error: %@", error);
             return;
         }
         self.placemark = [placemarks objectAtIndex:0];
         [self.delegate didFinishGettingPlacemarkInfo];
     }];

    [self webViewSetCorrectLocationWithActualJSManipulation];
    
    WeatherManager *weatherManager = [WeatherManager sharedWeatherManager];
    weatherManager.delegate = self;
    [weatherManager makeWeatherCallToOpenWeatherMapAPI: latitude longitude:longitude];
}

- (void) didFinishGettingWeatherCloudsInfo {
    [self webViewSetCorrectCloudsLevel];
    [self.delegate didFinishGettingAllWeatherData];
    [self webViewClickSubmitButton];
}

- (void) webViewSetCorrectCloudsLevel {
    WeatherManager *weatherManager = [WeatherManager sharedWeatherManager];
    if (weatherManager.cloudsLevel < 20) {
        [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName(\"sky_condition\")[0][0].selected = true"];
    }
    else if (weatherManager.cloudsLevel >= 25 && weatherManager.cloudsLevel < 50) {
        [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName(\"sky_condition\")[0][1].selected = true"];
    }
    else if (weatherManager.cloudsLevel >= 50 && weatherManager.cloudsLevel < 75) {
        [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName(\"sky_condition\")[0][2].selected = true"];
    }
    else if (weatherManager.cloudsLevel >= 75) {
        [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName(\"sky_condition\")[0][3].selected = true"];
    }
}

- (void) webViewSetCorrectLocationWithActualJSManipulation {
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName(\"location_specification\")[1].checked = true"];
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByName(\"latitude\")[0].value = %@", latitude]];
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByName(\"longitude\")[0].value = %@", longitude]];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Error while getting core location : %@",[error localizedFailureReason]);
    if ([error code] == kCLErrorDenied) {
        //you had denied
    }
    [manager stopUpdatingLocation];
}




#pragma mark Post-form methods (dealing with response time data)
- (NSString *) stringParseIntoHoursMins: (NSString *) unformattedTimeString{
    NSArray *components = [unformattedTimeString componentsSeparatedByString:@":"];
    NSInteger hourDigits = [components[0] integerValue];
    NSInteger minuteDigits = [components[1] integerValue];
    NSString *resultString;
    
    if (hourDigits == 0)
        resultString = [NSString stringWithFormat:@"%ld Minutes", (long)minuteDigits];
    else if (hourDigits == 1)
        resultString = [NSString stringWithFormat:@"1 Hour %ld Minutes", (long)minuteDigits];
    else
        resultString = [NSString stringWithFormat:@"%ld Hours %ld Minutes", (long)hourDigits, (long)minuteDigits];
    
    return resultString;
}



@end
