//
//  FitzpatrickType.m
//  ColorDetector
//
//  Created by Terry Bu on 3/16/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

#import "FitzpatrickType.h"
#import "ColorConstants.h"

@implementation FitzpatrickType

- (id) initWithType: (FitzpatrickTypeNum) typeNumber {
    if (self = [super init]) {
        self.typeNumber = typeNumber;
        switch (self.typeNumber) {
            case Type1:
                self.uiColor = [ColorConstants getType1];
                self.typeName = @"Type 1";
                break;
            case Type2:
                self.uiColor = [ColorConstants getType2];
                self.typeName = @"Type 2";
                break;
            case Type3:
                self.uiColor = [ColorConstants getType3];
                self.typeName = @"Type 3";
                break;
            case Type4:
                self.uiColor = [ColorConstants getType4];
                self.typeName = @"Type 4";
                break;
            case Type5:
                self.uiColor = [ColorConstants getType5];
                self.typeName = @"Type 5";
                break;
            case Type6:
                self.uiColor = [ColorConstants getType6];
                self.typeName = @"Type 6";
                break;
            default:
                break;
        }
    }
    return self;
}

@end
