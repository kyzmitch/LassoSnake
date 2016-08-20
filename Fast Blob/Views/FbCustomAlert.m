//
//  FbCustomAlert.m
//  Fast Blob
//
//  Created by Andrey Ermoshin on 31.07.15.
//  Copyright (c) 2015 Speed Run. All rights reserved.
//

#import "FbCustomAlert.h"
#import <SpriteKit/SpriteKit.h>
#import "FBButton.h"

#define kFbCornerRadius 6
#define kFbBtnsLeadingShift 10
#define kFbBtnHeight 60
#define kFbBtnVerticalShift 6
#define kFbBtnTopBorderShift 4
#define kFbAlertWidth 260

@interface FbCustomAlert ()
{
@private
    __strong SKShapeNode *_mainNode;
    __strong NSMutableArray *_btnNodes;
}


@end

@implementation FbCustomAlert

- (id)initWithNames:(NSArray *)buttonNames
             colors:(NSArray *)buttonColors
    backgroundColor:(UIColor *)backColor{
    self = [super init];
    
    if (self == nil){
        return nil;
    }
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGFloat w = kFbAlertWidth;
    CGFloat buttonWidth = w - 2 * kFbBtnsLeadingShift;
    CGFloat h = buttonNames.count * kFbBtnHeight + kFbBtnVerticalShift * (buttonNames.count - 1) + kFbBtnTopBorderShift;
    CGRect buttonFrame = CGRectMake(kFbBtnsLeadingShift, kFbBtnTopBorderShift, buttonWidth, kFbBtnHeight);
    CGPoint cntr = CGPointMake(CGRectGetMidX(screenRect), CGRectGetMidY(screenRect));
    CGRect alRect = CGRectMake(cntr.x - w/2, cntr.y - h/2, w, h);
    _mainNode = [SKShapeNode shapeNodeWithRect:alRect cornerRadius:kFbCornerRadius];
    _mainNode.fillColor = backColor;
    _mainNode.strokeColor = backColor;
    
    _btnNodes = [NSMutableArray new];
    
    for (NSString *btnName in buttonNames){
        NSUInteger ix = [buttonNames indexOfObject:btnName];
        UIColor *btnClr = [buttonColors objectAtIndex:ix];
        FBButton *btn = [[FBButton alloc] initWithText:btnName andFrame:buttonFrame
                                          andBackColor:btnClr
                                          andTextColor:[UIColor whiteColor]];

        [_btnNodes addObject:btn];
    }
    
    for (FBButton *btn in _btnNodes){
        NSUInteger iy = [_btnNodes indexOfObject:btn];
        if (iy == 0){
            // top btn
            
            SKRange *centerXRange = [SKRange rangeWithConstantValue:CGRectGetMidX(screenRect)];
            SKRange *distanceFromTopBorderRange = [SKRange rangeWithConstantValue:kFbBtnTopBorderShift + kFbBtnHeight];
            SKConstraint *btnHorizontal = [SKConstraint positionX:centerXRange];
            SKConstraint *btnTop = [SKConstraint distance:distanceFromTopBorderRange toPoint:CGPointMake(CGRectGetMidX(alRect), CGRectGetMaxY(alRect))];
            btn.node.constraints = [NSArray arrayWithObjects:btnHorizontal, btnTop, nil];
        }
        else{
            SKRange *centerXRange = [SKRange rangeWithConstantValue:CGRectGetMidX(screenRect)];
            SKRange *nearestBtnRange = [SKRange rangeWithConstantValue:kFbBtnVerticalShift + kFbBtnHeight];
            SKConstraint *btnHorizontal = [SKConstraint positionX:centerXRange];
            FBButton *prevBtn = [_btnNodes objectAtIndex:iy - 1];
            SKSpriteNode *prevBtnNode = prevBtn.node;
            SKConstraint *btnTop = [SKConstraint distance:nearestBtnRange toPoint:CGPointMake(CGRectGetMidX(alRect), CGRectGetMinY(prevBtnNode.frame))];
            btn.node.constraints = [NSArray arrayWithObjects:btnHorizontal, btnTop, nil];
        }
        [_mainNode addChild:btn.node];
    }
    
    
    return self;
}

- (void)showOnScene:(SKScene *)sceen{
    [_mainNode removeFromParent];
    [sceen addChild:_mainNode];
}

@end
