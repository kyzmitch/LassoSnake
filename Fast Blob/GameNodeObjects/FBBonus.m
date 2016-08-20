//
//  FBBonus.m
//  Fast Blob
//
//  Created by Igor on 13.08.15.
//  Copyright (c) 2015 Speed Run. All rights reserved.
//

#import "FBBonus.h"

@implementation FBBonus

+(FBBonus*)createBonusWithСoefficient:(NSUInteger)coefficient
{
    return [[FBBonus alloc] initBonusWithCoefficient:coefficient];
}

//-------------------------------------------------------------------------

-(instancetype)initBonusWithCoefficient:(NSUInteger)coefficient
{
    self = [FBBonus shapeNodeWithCircleOfRadius:kFBRadius];
    if(self)
    {
        self.name = [NSString stringWithFormat:@"Bonusx%lu",(unsigned long)coefficient] ;
        self.fillColor = FB_BONUS_COLOR;
        self.strokeColor = FB_BONUS_BORDER_COLOR;
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:kFBRadius];
        self.physicsBody.dynamic = NO;
        self.physicsBody.categoryBitMask = kFBBonusCategory;
        self.physicsBody.usesPreciseCollisionDetection = YES;
        self.zPosition = kFbGameObjectsZPos;
        
        SKLabelNode * labelCoefficient = [SKLabelNode labelNodeWithFontNamed:FB_BONUS_FONTNAME];
        labelCoefficient.text = [NSString stringWithFormat:@"x%lu",(unsigned long)coefficient];
        labelCoefficient.position = CGPointMake(CGRectGetMidX(self.frame), -kFBRadius/3);
        labelCoefficient.fontSize = 16;
        labelCoefficient.fontColor = FB_BONUS_TEXT_COLOR;
        [self addChild:labelCoefficient];
        
    }
    return self;
}
//-------------------------------------------------------------------------
-(void)runAnimationTimeToLife:(NSUInteger)timeToLife nearRightNode:(SKNode *)nearNode
{
    CGPoint cornerPosition = CGPointMake(nearNode.position.x - 100, nearNode.position.y + 10);
    SKAction *hide = [SKAction fadeOutWithDuration:0.1];
    SKAction *move = [SKAction moveTo:cornerPosition duration:0.1];
    SKAction *show = [SKAction fadeInWithDuration:0.1];
    CGFloat upTime = 0.2;
    CGFloat downTime = 0.2;
    SKAction *scaleUp = [SKAction scaleTo:1.2 duration:upTime];
    SKAction *scaleDown = [SKAction scaleTo:1.0 duration:downTime];
    SKAction *waitScale = [SKAction sequence:@[scaleUp, scaleDown]];
    NSUInteger times = timeToLife / (upTime + downTime);
    SKAction *repeateScale = [SKAction repeatAction:waitScale count:times];
    SKAction *wait = [SKAction waitForDuration:timeToLife];
    SKAction *waitGroup = [SKAction group:@[wait, repeateScale]];
    SKAction *sequnce =[SKAction sequence:@[hide, move, show, waitGroup]];
    [self runAction:sequnce completion:^{
        [self runAction:scaleDown completion:^{
            [self removeFromParent];
        }];
    }];
    
}
//-------------------------------------------------------------------------

-(void)redrawOnScene:(SKScene *)scene withLocation:(CGPoint)location
{
    [self removeFromParent];
    self.position = location;
    [scene addChild:self];
}

//-------------------------------------------------------------------------


@end
