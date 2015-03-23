//
//  WebviewManager.m
//  FitzpatrickSkinTypeDetector
//
//  Created by Terry Bu on 3/23/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

#import "WebviewManager.h"
#import "Constants.h"

@implementation WebviewManager


-(id) init {
    self = [super init];
    self.webView = [[UIWebView alloc]init];
    
    [self loadUp];
    
    return self;
}

- (void) loadUp {
    [self.webView loadRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:kFormPageURL]]];
    self.webView.delegate = self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    if ([webView.request.URL.absoluteString isEqualToString:kFormPageURL]){
        [self webViewSetFitzgeraldSkinType: self.fitzType.typeNumber];
        [self webViewClickSubmitButton];
    }
    
    if ([webView.request.URL.absoluteString isEqualToString:kResultPageURL]) {
        //        NSLog(@"found the result page");
        NSString *resultPageHTML = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
        NSArray *components = [resultPageHTML componentsSeparatedByString:@"<br>"];
        NSString *sanitizedMinRecoString = [components[4] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
//        NSLog(@"min recommended time: %@, count: %lu", sanitizedMinRecoString, sanitizedMinRecoString.length);
        //gets minimum recommended exposure time
        //        NSLog(@"%@", components);
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kSunlightRecoTime object:nil userInfo:@{ kSunlightRecoTime : sanitizedMinRecoString }];
        
        NSString *sanitizedUVExposureTimeToObtainSunburn = [components[components.count-1] stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
        sanitizedUVExposureTimeToObtainSunburn = [sanitizedUVExposureTimeToObtainSunburn stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kSunburnTime object:nil userInfo:@{ kSunburnTime : sanitizedUVExposureTimeToObtainSunburn }];

//        NSLog(@"UV Exposure Time to Obtain Sunburn: %@, count: %lu", sanitizedUVExposureTimeToObtainSunburn, sanitizedUVExposureTimeToObtainSunburn.length);
        
    }
}

#pragma mark Custom JavaScript Methods

- (void) webViewSetFitzgeraldSkinType: (FitzpatrickTypeNum) typeNum {
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByName(\"skin_index\")[%d].checked = true", typeNum]]; //i was confused about indexing here but TypeNum correctly corresponds to the right index on the web side too, leave it 
}

- (void) webViewClickSubmitButton {
    [self.webView stringByEvaluatingJavaScriptFromString:@"var inputs = document.getElementsByTagName('input'); for(var i = 0; i < inputs.length; i++) {if(inputs[i].type.toLowerCase() == 'submit') {inputs[i].click();}}"];
}




@end
