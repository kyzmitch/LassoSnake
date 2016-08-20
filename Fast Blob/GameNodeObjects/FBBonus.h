//
//  FBBonus.h
//  Fast Blob
//
//  Created by Igor on 13.08.15.
//  Copyright (c) 2015 Speed Run. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface FBBonus : SKShapeNode
-(void)redrawOnScene:(SKScene *)scene withLocation:(CGPoint)location;
+(FBBonus*)createBonusWithСoefficient:(NSUInteger)coefficient;
-(void)runAnimationTimeToLife:(NSUInteger)timeToLife nearRightNode:(SKNode *)nearNode;
@end
