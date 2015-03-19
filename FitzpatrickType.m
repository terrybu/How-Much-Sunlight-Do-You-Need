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

+ (FitzpatrickType *) comparePickedColorToFitzpatrickTypes: (UIColor *) pickedColor {
    CGFloat r1, g1, b1, a1, r2, g2, b2, a2;
    [pickedColor getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    //I'm going to get the CGFLoat RGB values (0 being black and 1 being white) of the picked Color
    
    //this is a float to count the differences between the pickedColor and a Fitzpatrick Type.
    //if the score is the smallest, that type is the one we will say the MOST SIMILAR to the picked Color
    float disparityScore = 0;
    
    //Instantiate FitzpatrickType objects
    FitzpatrickType *type1 = [[FitzpatrickType alloc]initWithType:Type1];
    FitzpatrickType *type2 = [[FitzpatrickType alloc]initWithType:Type2];
    FitzpatrickType *type3 = [[FitzpatrickType alloc]initWithType:Type3];
    FitzpatrickType *type4 = [[FitzpatrickType alloc]initWithType:Type4];
    FitzpatrickType *type5 = [[FitzpatrickType alloc]initWithType:Type5];
    FitzpatrickType *type6 = [[FitzpatrickType alloc]initWithType:Type6];
    
    //Get all the types into an array
    NSArray *fitzpatrickArray = @[  type1, type2, type3, type4, type5, type6 ];
    NSMutableArray *scoresArray = [[NSMutableArray alloc]init];
    
    //we are going to get sum of the abs value difference between pickedColor and FitzpatrickTypes.
    for (int i=0; i < fitzpatrickArray.count; i++) {
        FitzpatrickType *fitz = fitzpatrickArray[i];
        UIColor *colorToCheck = fitz.uiColor;
        [colorToCheck getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
        if (disparityScore == 0) {
            disparityScore = fabs(r1-r2) + fabs(g1-g2) + fabs(b1-b2);
            [scoresArray addObject:[NSNumber numberWithFloat:disparityScore]];
        }
        else {
            float temp = fabs(r1-r2) + fabs(g1-g2) + fabs(b1-b2);
            disparityScore = fminf(disparityScore, temp);
            [scoresArray addObject:[NSNumber numberWithFloat:temp]];
        }
    }
    
    //The scoresArray is to keep track of WHICH TYPE had the lowest disparity score.
    NSNumber *disparityScoreWrapped = [NSNumber numberWithFloat:disparityScore];
    NSUInteger indexOfDisparity = [scoresArray indexOfObject:disparityScoreWrapped];
    return fitzpatrickArray[indexOfDisparity];
}



@end
