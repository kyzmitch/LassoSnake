//
//  FBScores.m
//  Fast Blob
//
//  Created by Igor on 11.07.15.
//  Copyright (c) 2015 Speed Run. All rights reserved.
//

#import "FBScores.h"
#import "UIColor+FBExtension.h"

#define kFbRightShift 60.0

@interface FBScores()
{
@private
    __weak SKScene *_scene;
    NSInteger _totalScore;
}
@property (nonatomic, readwrite) CGPoint attachmentPoint;

@end



@implementation FBScores
@synthesize totalScore = _totalScore;

+ (FBScores*)createScoresInLocation:(CGPoint)location
{
    return[[FBScores alloc]initWithLocation:location];
}

//-------------------------------------------------------------------------

-(instancetype)initWithLocation:(CGPoint)location
{
    self = [FBScores labelNodeWithFontNamed:FB_GAME_SCORE_FONTNAME];
    if(self)
    {
        self.attachmentPoint = location;
        self.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
        self.text = @"0";
        self.name = @"Scores";
        self.fontColor = FB_GAME_POSITIVE_SCORE_COLOR;
        _totalScore = 0;
        self.zPosition = kFbInterfaceZPos;
    }
    return self;
}
//-------------------------------------------------------------------------
- (void)addToScene:(SKScene *)scene{
    if (scene)
    {
        [self removeFromParent];
        self.constraints = nil;
        [scene addChild:self];
        _scene = scene;
        
        SKRange *rangeTop = [SKRange rangeWithConstantValue:kFbScoreTopShift];
        SKRange *rangeRight = [SKRange rangeWithConstantValue:0];
        
        SKConstraint *distanceRightConstraint = [SKConstraint distance:rangeRight
                                                               toPoint:CGPointMake(self.attachmentPoint.x,
                                                                                   self.attachmentPoint.y - kFbRightShift)];
        SKConstraint *distanceTopConstraint = [SKConstraint distance:rangeTop
                                                             toPoint:CGPointMake(self.attachmentPoint.x - kFbScoreTopShift, self.attachmentPoint.y)];
        self.constraints = [NSArray arrayWithObjects:distanceRightConstraint, distanceTopConstraint, nil];
    }
}
//-------------------------------------------------------------------------
- (void)updateScoreNewScore:(NSUInteger)playerScore
{
    // Player score
    _totalScore += playerScore;
    if (self.totalScore < 0){
        self.fontColor = FB_GAME_SCORE_COLOR;
    }
    else{
        self.fontColor  = FB_GAME_POSITIVE_SCORE_COLOR;
    }
    self.text = [NSString stringWithFormat:@"%ld",(unsigned long)_totalScore];
    SKAction *scaleMainScore = [SKAction scaleTo:3/2.0 duration:0.3];
    [self removeAllActions];
    [self runAction:scaleMainScore completion:^{
        SKAction *scaleToDefaults = [SKAction scaleTo:1 duration:0.1];
        [self runAction:scaleToDefaults];
    }];
}
//-------------------------------------------------------------------------
-(void)temporaryScore:(NSInteger)temporaryScore aboutSnake:(SKShapeNode*)box
{
    SKLabelNode * timeScore = [SKLabelNode labelNodeWithFontNamed:FB_GAME_SCORE_FONTNAME];
    timeScore.fontSize = 22;
    timeScore.name = @"TimeScore";
    timeScore.text = [NSString stringWithFormat:@"%ld",(long)temporaryScore];
    if (temporaryScore < 0){
        timeScore.fontColor = FB_GAME_SCORE_COLOR;
    }
    else{
        timeScore.fontColor = FB_GAME_POSITIVE_SCORE_COLOR;
    }

    timeScore.position = CGPointMake(box.position.x + 30, box.position.y + 30);
    [_scene addChild:timeScore];
    SKAction * duration = [SKAction customActionWithDuration:0.5
                                                 actionBlock:^(SKNode * _Nonnull node, CGFloat elapsedTime){}];
    SKAction * move = [SKAction moveTo:self.position duration:0.5];
    SKAction * group = [SKAction group:@[duration, move]];
    [timeScore runAction:group completion:^{
        [timeScore removeFromParent];
        [self updateScoreNewScore:temporaryScore];
        
    }];

}
//-------------------------------------------------------------------------
@end
