//
//  FitzpatrickType.h
//  ColorDetector
//
//  Created by Terry Bu on 3/16/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    Type1,
    Type2,
    Type3,
    Type4,
    Type5,
    Type6
} FitzpatrickTypeNum;

@interface FitzpatrickType : NSObject

@property FitzpatrickTypeNum typeNumber;
@property (strong, nonatomic) NSString* typeName;
@property (strong, nonatomic) NSString* resultMessage;
@property (strong, nonatomic) UIColor *uiColor;


- (id) initWithType: (FitzpatrickTypeNum) typeNumber;
+ (FitzpatrickType *) comparePickedColorToFitzpatrickTypes:(UIColor *) color;


@end
