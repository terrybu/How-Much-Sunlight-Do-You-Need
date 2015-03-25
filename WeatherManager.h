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

@property (nonatomic, strong) NSNumber *clouds;
- (void) makeWeatherCallToOpenWeatherMapAPI: (NSString *) latitude longitude: (NSString *) longitude;

@property (nonatomic, weak) id <WeatherManagerDelegate> delegate;

+ (WeatherManager*) sharedWeatherManager;


@end







@protocol WeatherManagerDelegate

- (void) didFinishGettingWeatherCloudsInfo;

@end