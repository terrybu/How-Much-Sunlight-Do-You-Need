//
//  WeatherManager.h
//  FitzpatrickSkinTypeDetector
//
//  Created by Terry Bu on 3/25/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WeatherManagerDelegate;

@interface WeatherManager : NSObject

@property long cloudsLevel;
@property (nonatomic, strong) NSString *weatherDescriptionString;
@property (nonatomic, weak) id <WeatherManagerDelegate> delegate;



- (void) makeWeatherCallToOpenWeatherMapAPI: (NSString *) latitude longitude: (NSString *) longitude;
+ (WeatherManager*) sharedWeatherManager;


@end







@protocol WeatherManagerDelegate

- (void) didFinishGettingWeatherCloudsInfo;

@end