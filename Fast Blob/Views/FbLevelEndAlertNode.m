//
//  FbLevelEndAlertNode.m
//  Fast Blob
//
//  Created by Andrey Ermoshin on 30.07.15.
//  Copyright (c) 2015 Speed Run. All rights reserved.
//

#import "FbLevelEndAlertNode.h"
#import <SpriteKit/SpriteKit.h>

#define kFbTopShift 10.0
#define kFbCornerRadius 5
#define kFbProgressNodeShift 2
#define kFbBottomShift 10.0
#define kFbButtonsShift 6

@interface FbLevelEndAlertNode ()
{
@private
    __strong SKShapeNode *_mainNode;
    __strong SKShapeNode *_progressNode;
    __strong SKSpriteNode *_nextLevel;
    __strong SKSpriteNode *_repeateLevel;
    __strong SKSpriteNode *_returnToMainMenu;
}
@end

@implementation FbLevelEndAlertNode

- (id)initWithFrame:(CGRect)frame{
    self = [super init];
    
    _mainNode = [SKShapeNode shapeNodeWithRect:frame cornerRadius:kFbCornerRadius];
    _mainNode.fillColor = [SKColor grayColor];
    _mainNode.strokeColor = [SKColor grayColor];
    
    CGRect progressRect = CGRectMake(0, 0, frame.size.width * 0.8, frame.size.height * 0.3);
    _progressNode = [SKShapeNode shapeNodeWithRectOfSize:progressRect.size cornerRadius:kFbCornerRadius];
    _progressNode.fillColor = FB_MENU_BUTTON_COLOR;
    _progressNode.strokeColor = FB_MENU_BUTTON_COLOR;
    CGPoint progPos = CGPointMake(frame.origin.x + (progressRect.size.width + frame.size.width * 0.2) / 2.0f,
                                  frame.origin.y + frame.size.height - progressRect.size.height / 2.0 - kFbTopShift);
    _progressNode.position = progPos;
    [_mainNode addChild:_progressNode];
    
    CGFloat buttonSpaceH = frame.size.height - kFbTopShift - progressRect.size.height - kFbProgressNodeShift - kFbBottomShift - kFbButtonsShift * 2;
    CGFloat btnH = buttonSpaceH / 4;
    CGSize btnsSize = CGSizeMake(progressRect.size.width, btnH);
    _nextLevel = [SKSpriteNode spriteNodeWithColor:[SKColor purpleColor] size:btnsSize];
    _repeateLevel = [SKSpriteNode spriteNodeWithColor:[SKColor orangeColor] size:btnsSize];
    _returnToMainMenu = [SKSpriteNode spriteNodeWithColor:[SKColor blackColor] size:btnsSize];
    _nextLevel.position = CGPointMake(progPos.x, progPos.y - progressRect.size.height + kFbProgressNodeShift); // bug in calculation...
    [_mainNode addChild:_nextLevel];
    _repeateLevel.position = CGPointMake(progPos.x, _nextLevel.position.y - btnsSize.height - kFbButtonsShift);
    [_mainNode addChild:_repeateLevel];
    _returnToMainMenu.position = CGPointMake(progPos.x, _repeateLevel.position.y - btnsSize.height - kFbButtonsShift);
    [_mainNode addChild:_returnToMainMenu];
    
    

    SKLabelNode *continueBtnLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue Bold"];
    continueBtnLabel.fontSize = 18;
    continueBtnLabel.text = NSLocalizedString(@"Continue", nil);
    continueBtnLabel.name = @"kFbAlertContinueLabelNode";
    continueBtnLabel.fontColor = [SKColor whiteColor];
    CGFloat lable1Y = _nextLevel.position.y - continueBtnLabel.frame.size.height / 2.0;
    continueBtnLabel.position = CGPointMake(progPos.x, lable1Y);
    [_mainNode addChild:continueBtnLabel];
    
    SKLabelNode *repeateBtnLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue Bold"];
    repeateBtnLabel.fontSize = 18;
    repeateBtnLabel.text = NSLocalizedString(@"Restart level", nil);
    repeateBtnLabel.name = @"kFbAlertRepeateLabelNode";
    repeateBtnLabel.fontColor = [SKColor whiteColor];
    repeateBtnLabel.position = CGPointMake(progPos.x, _repeateLevel.position.y - repeateBtnLabel.frame.size.height / 2.0);
    [_mainNode addChild:repeateBtnLabel];
    
    SKLabelNode *backToMenuBtnLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue Bold"];
    backToMenuBtnLabel.fontSize = 18;
    backToMenuBtnLabel.text = NSLocalizedString(@"Main Menu", nil);
    backToMenuBtnLabel.name = @"kFbAlertRepeateLabelNode";
    backToMenuBtnLabel.fontColor = [SKColor whiteColor];
    backToMenuBtnLabel.position = CGPointMake(progPos.x, _returnToMainMenu.position.y - backToMenuBtnLabel.frame.size.height / 2.0);
    [_mainNode addChild:backToMenuBtnLabel];
    
    return self;
}

- (void)showOnScene:(SKScene *)sceen{
    [_mainNode removeFromParent];
    [sceen addChild:_mainNode];
}

- (void)removeFromScene:(SKScene *)scene{
    [_mainNode removeFromParent];
}

- (BOOL)mainNodeContainsPoint:(CGPoint)p{
    BOOL rc = [_mainNode containsPoint:p];
    if (rc == YES){
        return YES;
    }
    return NO;
}

- (void)handleTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint positionInMainNode = [touch locationInNode:_mainNode];
    if ([_nextLevel containsPoint:positionInMainNode]){
        
        SKAction *btnAnim = [SKAction colorizeWithColor:[SKColor whiteColor]
                                       colorBlendFactor:1
                                               duration:0.2];
        [_nextLevel runAction:btnAnim completion:^{
            SKAction *returnAction = [SKAction colorizeWithColor:[SKColor cyanColor]
                                                colorBlendFactor:1
                                                        duration:0.1];
            [_nextLevel runAction:returnAction completion:^{
                [self.delegate didAlertNode:self pressedContinue:YES];
            }];
        }];
    }
    else if ([_repeateLevel containsPoint:positionInMainNode]){
        SKAction *btnAnim = [SKAction colorizeWithColor:[SKColor yellowColor]
                                       colorBlendFactor:1
                                               duration:0.2];
        [_repeateLevel runAction:btnAnim completion:^{
            SKAction *returnAction = [SKAction colorizeWithColor:[SKColor orangeColor]
                                                colorBlendFactor:1
                                                        duration:0.1];
            [_repeateLevel runAction:returnAction completion:^{
                [self.delegate didAlertNode:self pressedRestart:YES];
            }];
        }];
    }
    else if ([_returnToMainMenu containsPoint:positionInMainNode]){
        SKAction *btnAnim = [SKAction colorizeWithColor:[SKColor purpleColor]
                                       colorBlendFactor:1
                                               duration:0.2];
        [_returnToMainMenu runAction:btnAnim completion:^{
            SKAction *returnAction = [SKAction colorizeWithColor:[SKColor blackColor]
                                                colorBlendFactor:1
                                                        duration:0.1];
            [_returnToMainMenu runAction:returnAction completion:^{
                [self.delegate didAlertNode:self pressedToMainMenu:YES];
            }];
        }];
    }
}

@end
