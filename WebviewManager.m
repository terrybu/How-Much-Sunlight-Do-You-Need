//
//  WebviewManager.m
//  FitzpatrickSkinTypeDetector
//
//  Created by Terry Bu on 3/23/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

#import "WebviewManager.h"
#import "Constants.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@implementation WebviewManager {
    CLLocationManager *locationManager;
    NSString *latitude;
    NSString *longitude;
    NSMutableData *responseData;
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
    [self webViewClickSubmitButton];
    
    
    //For Weather API Call
    NSString *urlstring = [NSString stringWithFormat: @"http://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@", latitude, longitude];
    NSURL *requestURL = [NSURL URLWithString:urlstring];
    NSMutableURLRequest *myURLRequest = [NSMutableURLRequest requestWithURL:requestURL];
    myURLRequest.HTTPMethod = @"GET";
    [myURLRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //create url connection and fire the request you made above
    NSURLConnection *connect = [[NSURLConnection alloc] initWithRequest: myURLRequest delegate: self];
    connect = nil;
    
    
    
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


#pragma mark NSURLConnection Delegate Methods
- (void) connection:(NSURLConnection* )connection didReceiveResponse:(NSURLResponse *)response {
    responseData = [NSMutableData data];
    [responseData setLength:0];
}

- (void)connection: (NSURLConnection *)connection didReceiveData:(NSData *) data {
    //this handler, gets hit SEVERAL TIMES
    //Append new data to the instance variable everytime new data comes in
    [responseData appendData:data];
    
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    //Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //this handler, gets hit ONCE
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now or do whatever you want
    
    NSLog(@"connection finished");
    NSLog(@"Succeeded! Received %lu bytes of data",(unsigned long)[responseData length]);
    
    //Convert your responseData object
    NSError *myError = nil;
    NSDictionary *responseDataInNSDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    //Log it
    NSLog(@"%@", responseDataInNSDictionary);
    
    NSDictionary *cloudsDict = responseDataInNSDictionary[@"clouds"];
    NSNumber *clouds = cloudsDict[@"all"];
    NSLog(@"clouds - %@", clouds);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    NSLog(@"%@", [error localizedDescription]);
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
