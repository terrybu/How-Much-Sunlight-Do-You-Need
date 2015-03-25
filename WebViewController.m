//
//  WKWebViewController.m
//  FitzpatrickSkinTypeDetector
//
//  Created by Terry Bu on 3/19/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

#import "WebViewController.h"
#import "Constants.h"

@interface WebViewController ()

@end



@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.webView loadRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:kFormPageURL]]];
    self.webView.delegate = self;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
