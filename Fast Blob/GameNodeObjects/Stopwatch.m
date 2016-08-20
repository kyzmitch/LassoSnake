//
//  Stopwatch.m
//  Fast Blob
//
//  Created by Igor on 21.07.15.
//  Copyright (c) 2015 Speed Run. All rights reserved.
//

#import "Stopwatch.h"

@interface Stopwatch ()
{
    @private SKScene * _scene;
}
@end

@implementation Stopwatch

+(Stopwatch*)createStopwatch
{
    return [[Stopwatch alloc]initStopwatch];
}
//-------------------------------------------------------------------------
-(instancetype)initStopwatch
{
    
    self = [Stopwatch shapeNodeWithRectOfSize:CGSizeMake(20, 20)];
    if(self)
    {
        self.name = kFbGrayBoxStopwatchNodeName;
        self.fillColor = FB_TIME_RESOURCE_COLOR;
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
        self.physicsBody.dynamic = NO;
        self.physicsBody.categoryBitMask = kFBStopwatch;
        self.physicsBody.contactTestBitMask = kFBHeadCategory;
        self.zPosition = kFbGameObjectsZPos;
        
    }
    return self;
}

//-------------------------------------------------------------------------
-(void)redrawOnScene:(SKScene *)scene withLocation:(CGPoint)location
{
    _scene = scene;
    [self removeFromParent];
    self.position = location;
    [scene addChild:self];
    [self runAnimation];
}
//-------------------------------------------------------------------------

-(void)runAnimation
{
    SKAction * scaleUp = [SKAction scaleTo:2.0 duration:0.5];
    SKAction * scaleDown = [SKAction scaleTo:1.0 duration:0.5];
    SKAction * fade  = [SKAction fadeOutWithDuration:1];
    SKAction * fadeCancel = [fade reversedAction];
    SKAction * sequence = [SKAction sequence:@[scaleUp,scaleDown,scaleUp,scaleDown,fade,fadeCancel]];
    [self runAction:sequence completion:^{[self removeFromParent];}];
    
}
//-------------------------------------------------------------------------
-(void)runAnimationExplosionWithScores
{
   
    SKAction * wait = [SKAction waitForDuration:1];
    
    SKLabelNode * label = [SKLabelNode  labelNodeWithFontNamed:FB_TIME_RESOURCE_FONTNAME];
    label.position = self.position;
    
    label.name = @"LabelStopwatch";
    label.text = [NSString stringWithFormat:@"+%lu", (unsigned long)kFbTimeBonus];
    label.fontColor = FB_TIME_RESOURCE_TEXT_COLOR;
    label.fontSize = 20;
    SKAction * scale = [SKAction scaleBy:2.0 duration:2];
    [label runAction:scale];
    [_scene addChild:label];
    [label  runAction:wait completion:^{[label removeFromParent];}];
}

@end
