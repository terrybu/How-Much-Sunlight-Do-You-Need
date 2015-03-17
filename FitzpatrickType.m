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
                self.typeName = @"Type I";
                self.resultMessage = @"White, Always burns, never tans";
                break;
            case Type2:
                self.uiColor = [ColorConstants getType2];
                self.typeName = @"Type II";
                self.resultMessage = @"Beige, Usually burns, tans with difficulty";
                break;
            case Type3:
                self.uiColor = [ColorConstants getType3];
                self.typeName = @"Type III";
                self.resultMessage = @"Light Brown, Sometimes burns, slow tanning";
                break;
            case Type4:
                self.uiColor = [ColorConstants getType4];
                self.typeName = @"Type IV";
                self.resultMessage = @"Medium Brown, Rarely burns, fast tanning";
                break;
            case Type5:
                self.uiColor = [ColorConstants getType5];
                self.typeName = @"Type V";
                self.resultMessage = @"Dark Brown, Rarely burns, fast & easy tanning";
                break;
            case Type6:
                self.uiColor = [ColorConstants getType6];
                self.typeName = @"Type VI";
                self.resultMessage = @"Black, Almost never burns, fast & dark tanning";
                break;
            default:
                break;
        }
    }
    return self;
}

@end
