//
//  WebviewManager.h
//  FitzpatrickSkinTypeDetector
//
//  Created by Terry Bu on 3/23/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FitzpatrickType.h"
#import <CoreLocation/CoreLocation.h>

@interface WebviewManager : NSObject  <UIWebViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property FitzpatrickType* fitzType;

- (void) loadUp;

@end
