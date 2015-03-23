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
        [self webViewSetCorrectDate];
        [self webViewSetFitzgeraldSkinType: self.fitzType.typeNumber];
        [self webViewClickSubmitButton];
    }
    
    if ([webView.request.URL.absoluteString isEqualToString:kResultPageURL]) {
        NSString *resultPageHTML = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
        NSArray *components = [resultPageHTML componentsSeparatedByString:@"<br>"];
        NSString *sanitizedMinRecoString = [components[4] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *resultMinRecoString = [self stringParseIntoHoursMins:sanitizedMinRecoString];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kSunlightRecoTime object:nil userInfo:@{ kSunlightRecoTime : resultMinRecoString }];
        
        NSString *sanitizedUVExposureTimeToObtainSunburn = [components[components.count-1] stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
        sanitizedUVExposureTimeToObtainSunburn = [sanitizedUVExposureTimeToObtainSunburn stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *resultSunburnString = [self stringParseIntoHoursMins:sanitizedUVExposureTimeToObtainSunburn];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kSunburnTime object:nil userInfo:@{ kSunburnTime : resultSunburnString }];
    }
}

#pragma mark Custom JavaScript to Inject Correct Info to Form

- (void) webViewSetCorrectDate {
    NSDate *today = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:today];
    
    
    //setting month
    NSLog(@"month num: %ld", [components month]);
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByName(\"month\")[0].options[%ld].selected = true", [components month]-1]]; //because the 0th index is january and 11th index is dec
    
    //setting day
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByName(\"mday\")[0].options[%ld].selected = true", [components day]-1]]; //because the 0th index is january and 11th index is dec
}

- (void) webViewSetFitzgeraldSkinType: (FitzpatrickTypeNum) typeNum {
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByName(\"skin_index\")[%d].checked = true", typeNum]]; //i was confused about indexing here but TypeNum correctly corresponds to the right index on the web side too, leave it
}

- (void) webViewClickSubmitButton {
    [self.webView stringByEvaluatingJavaScriptFromString:@"var inputs = document.getElementsByTagName('input'); for(var i = 0; i < inputs.length; i++) {if(inputs[i].type.toLowerCase() == 'submit') {inputs[i].click();}}"];
}

#pragma mark Post-form methods (dealing with response time data)

- (NSString *) stringParseIntoHoursMins: (NSString *) unformattedTimeString{
    NSArray *components = [unformattedTimeString componentsSeparatedByString:@":"];
    NSInteger hourDigits = [components[0] integerValue];
    NSInteger minuteDigits = [components[1] integerValue];
    NSString *resultString;
    
    if (hourDigits == 0)
        resultString = [NSString stringWithFormat:@"%ld Minutes", minuteDigits];
    else if (hourDigits == 1)
        resultString = [NSString stringWithFormat:@"1 Hour %ld Minutes", minuteDigits];
    else
        resultString = [NSString stringWithFormat:@"%ld Hours %ld Minutes", hourDigits, minuteDigits];
    
    return resultString;
}



@end
