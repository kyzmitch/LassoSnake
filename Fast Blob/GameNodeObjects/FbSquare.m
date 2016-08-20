//
//  FbSquare.m
//  Fast Blob
//
//  Created by Igor on 14.07.15.
//  Copyright (c) 2015 Speed Run. All rights reserved.
//

#import "FbSquare.h"
@interface FbSquare ()

@end

@implementation FbSquare

+(FbSquare*)createSquareInSceneTypeSquare:(BOOL)enemy
{
    return [[FbSquare alloc] initTypeSquareEnemy:enemy];
}
//-------------------------------------------------------------------------
-(instancetype)initTypeSquareEnemy:(BOOL)enemy
{

    self = [FbSquare shapeNodeWithRectOfSize:CGSizeMake(20, 20)];
    if(self)
    {

        if (enemy)
        {
            self.name = kFbEnemySquareNodeName;
            self.fillColor  = FB_ENEMY_COLOR;
            self.strokeColor = FB_ENEMY_BORDER_COLOR;
            self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
            self.physicsBody.categoryBitMask  = kFBEnemyFoodCategory;
            self.physicsBody.contactTestBitMask = kFBHeadCategory;
            self.physicsBody.dynamic = NO;
        }
        else
        {
            self.name = kFbFoodSquareNodeName;
            self.fillColor = FB_FRIENDLY_COLOR;
            self.strokeColor = FB_FRIENDLY_BORDER_COLOR;
            self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
            self.physicsBody.categoryBitMask  = kFBFoodCategory;
            self.physicsBody.dynamic = NO;
        }
        self.physicsBody.usesPreciseCollisionDetection = YES;
    }
    self.zPosition = kFbGameObjectsZPos;
    return self;
}

//-------------------------------------------------------------------------

-(void)redrawOnScene:(SKScene *)scene withLocation:(CGPoint)location
{
    [self removeFromParent];
    self.position = location;
    [scene addChild:self];
    [self runAnimation];
}

//-------------------------------------------------------------------------
-(void)runAnimation
{
    NSTimeInterval time;
    
    if (![self.name isEqualToString:kFbEnemySquareNodeName])
    {
        time = kFbFriendlySquareWaitTime;
    }
    else
    {
        time = kFbEnemySquareWaitTime;
    }
    
    SKAction * scaleUp = [SKAction scaleTo:2.0 duration:kFbSquaresScaleTime];
    SKAction * wait = [SKAction waitForDuration:time];
    SKAction * sequence = [SKAction sequence:@[scaleUp,wait]];
    [self runAction:sequence completion:^{
        [self removeAllActions];
        if (self)
        {
            [self removeFromParent];
        }
    }];
}
@end
