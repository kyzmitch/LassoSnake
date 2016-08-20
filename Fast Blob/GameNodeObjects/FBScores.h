//
//  FBScores.h
//  Fast Blob
//
//  Created by Igor on 11.07.15.
//  Copyright (c) 2015 Speed Run. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>


@interface FBScores : SKLabelNode

@property (readonly,nonatomic) NSInteger totalScore;
+ (FBScores*)createScoresInLocation:(CGPoint)location;
- (void)addToScene:(SKScene *)scene;
- (void)updateScoreNewScore:(NSUInteger)playerScore;
- (void)temporaryScore:(NSInteger)temporaryScore aboutSnake:(SKShapeNode*)snake;


@end
