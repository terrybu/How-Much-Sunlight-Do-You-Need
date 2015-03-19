//
//  WKWebViewController.m
//  FitzpatrickSkinTypeDetector
//
//  Created by Terry Bu on 3/19/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.webView loadRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:@"http://nadir.nilu.no/~olaeng/fastrt/VitD-ez_quartMEDandMED_v2.html"]]];
    self.webView.delegate = self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    if ([webView.request.URL.absoluteString isEqualToString:@"http://nadir.nilu.no/~olaeng/fastrt/VitD-ez_quartMEDandMED_v2.html"]){
        [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName(\"skin_index\")[1].checked = true"];
        [self.webView stringByEvaluatingJavaScriptFromString:@"var inputs = document.getElementsByTagName('input'); for(var i = 0; i < inputs.length; i++) {if(inputs[i].type.toLowerCase() == 'submit') {inputs[i].click();}}"];
    }
    
    if ([webView.request.URL.absoluteString isEqualToString:@"http://nadir.nilu.no/cgi-bin/olaeng/VitD-ez_quartMEDandMED_v2.cgi"])
        NSLog(@"found the submit result page");

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
