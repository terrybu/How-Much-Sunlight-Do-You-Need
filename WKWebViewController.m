//
//  WKWebViewController.m
//  FitzpatrickSkinTypeDetector
//
//  Created by Terry Bu on 3/19/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

#import "WKWebViewController.h"

@interface WKWebViewController ()

@end

@implementation WKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webView = [[WKWebView alloc]initWithFrame:self.containerViewForWeb.frame];
    [self.webView loadRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:@"http://nadir.nilu.no/~olaeng/fastrt/VitD-ez_quartMEDandMED_v2.html"]]];
    
    [self.containerViewForWeb addSubview:self.webView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
