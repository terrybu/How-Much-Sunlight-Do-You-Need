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

static NSString* const kFormPageURL = @"http://nadir.nilu.no/~olaeng/fastrt/VitD-ez_quartMEDandMED_v2.html";
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
        [self webViewSetFitzgeraldSkinType];
        [self webViewClickSubmitButton];
    }
    
    if ([webView.request.URL.absoluteString isEqualToString:kResultPageURL]) {
        NSLog(@"found the result page");
        NSString *resultPageHTML = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
        NSArray *components = [resultPageHTML componentsSeparatedByString:@"<br>"];
        NSString *sanitizedMinRecoString = [components[4] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSLog(@"min recommended time: %@, count: %lu", sanitizedMinRecoString, sanitizedMinRecoString.length); //gets minimum recommended exposure time
        
        NSLog(@"%@", components);
        NSString *sanitizedUVExposureTimeToObtainSunburn = [components[components.count-1] stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
        sanitizedUVExposureTimeToObtainSunburn = [sanitizedUVExposureTimeToObtainSunburn stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSLog(@"UV Exposure Time to Obtain Sunburn: %@, count: %lu", sanitizedUVExposureTimeToObtainSunburn, sanitizedUVExposureTimeToObtainSunburn.length);
        
        
        
        
    }
}

#pragma mark Custom JavaScript Methods

- (void) webViewSetFitzgeraldSkinType {
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName(\"skin_index\")[1].checked = true"];
}

- (void) webViewClickSubmitButton {
    [self.webView stringByEvaluatingJavaScriptFromString:@"var inputs = document.getElementsByTagName('input'); for(var i = 0; i < inputs.length; i++) {if(inputs[i].type.toLowerCase() == 'submit') {inputs[i].click();}}"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
