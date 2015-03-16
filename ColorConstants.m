//
//  ColorConstants.m
//  ColorDetector
//
//  Created by Terry Bu on 3/16/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

#import "ColorConstants.h"

@implementation ColorConstants

const int alpha = 255;

+ (UIColor *) getType1 {
    int red = 245;
    int green = 226;
    int blue = 222;
    UIColor *color = [UIColor colorWithRed:red/255.0
                                     green:green/255.0
                                      blue:blue/255.0
                                     alpha:alpha/255.0];
    return color;
}
+ (UIColor *) getType2 {
    int red = 243;
    int green = 208;
    int blue = 178;
    UIColor *color = [UIColor colorWithRed:red/255.0
                                     green:green/255.0
                                      blue:blue/255.0
                                     alpha:alpha/255.0];
    return color;
}

+ (UIColor *) getType3 {
    int red = 231;
    int green = 181;
    int blue = 144;
    UIColor *color = [UIColor colorWithRed:red/255.0
                                     green:green/255.0
                                      blue:blue/255.0
                                     alpha:alpha/255.0];
    return color;
}

+ (UIColor *) getType4 {
    int red = 200;
    int green = 119;
    int blue = 82;
    UIColor *color = [UIColor colorWithRed:red/255.0
                                     green:green/255.0
                                      blue:blue/255.0
                                     alpha:alpha/255.0];
    return color;
}


+ (UIColor *) getType5 {
    int red = 165;
    int green = 91;
    int blue = 44;
    UIColor *color = [UIColor colorWithRed:red/255.0
                                     green:green/255.0
                                      blue:blue/255.0
                                     alpha:alpha/255.0];
    return color;
}

+ (UIColor *) getType6 {
    int red = 61; 
    int green = 31;
    int blue = 29;
    UIColor *color = [UIColor colorWithRed:red/255.0
                                     green:green/255.0
                                      blue:blue/255.0
                                     alpha:alpha/255.0];
    return color;
}

@end
