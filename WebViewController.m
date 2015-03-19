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

static NSString* const kFormPageURL = @"http://nadir.nilu.no/cgi-bin/olaeng/VitD-ez_quartMEDandMED_v2.cgi";
static NSString* const kResultPageURL = @"http://nadir.nilu.no/cgi-bin/olaeng/VitD-ez_quartMEDandMED_v2.cgi";

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.webView loadRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:kFormPageURL]]];
    self.webView.delegate = self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    if ([webView.request.URL.absoluteString isEqualToString:kFormPageURL]){
        [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName(\"skin_index\")[1].checked = true"];
        [self.webView stringByEvaluatingJavaScriptFromString:@"var inputs = document.getElementsByTagName('input'); for(var i = 0; i < inputs.length; i++) {if(inputs[i].type.toLowerCase() == 'submit') {inputs[i].click();}}"];
    }
    
    if ([webView.request.URL.absoluteString isEqualToString:kResultPageURL]) {
        NSLog(@"found the result page");
        NSError *error;
        NSString *resultPageHTML = [NSString stringWithContentsOfURL:[NSURL URLWithString:kResultPageURL]
                                                            encoding:NSASCIIStringEncoding
                                                               error:&error];
        if (!error)
            NSLog(resultPageHTML);
        else
            NSLog(error.description);
    }

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
