//
//  Stopwatch.h
//  Fast Blob
//
//  Created by Igor on 21.07.15.
//  Copyright (c) 2015 Speed Run. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Stopwatch : SKShapeNode
+(Stopwatch*)createStopwatch;
-(void)redrawOnScene:(SKScene *)scene withLocation:(CGPoint)location;
-(void)runAnimationExplosionWithScores;

@end
