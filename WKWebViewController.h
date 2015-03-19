//
//  WKWebViewController.h
//  FitzpatrickSkinTypeDetector
//
//  Created by Terry Bu on 3/19/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>


@interface WKWebViewController : UIViewController <WKNavigationDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerViewForWeb;
@property (strong, nonatomic) WKWebView* webView;


@end
