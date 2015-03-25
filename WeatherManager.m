//
//  WeatherManager.m
//  FitzpatrickSkinTypeDetector
//
//  Created by Terry Bu on 3/25/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

#import "WeatherManager.h"

@implementation WeatherManager {
    NSMutableData *responseData;
}

+ (WeatherManager*)sharedWeatherManager
{
    // 1
    static WeatherManager *_sharedInstance = nil;
    // 2
    static dispatch_once_t oncePredicate;
    
    // 3
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[WeatherManager alloc] init];
    });
    return _sharedInstance;
}


- (void) makeWeatherCallToOpenWeatherMapAPI: (NSString *) latitude longitude: (NSString *) longitude {
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
    self.clouds = cloudsDict[@"all"];
    [self.delegate didFinishGettingWeatherCloudsInfo];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    NSLog(@"%@", [error localizedDescription]);
}


@end
