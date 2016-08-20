//
//  FbPhysicalSnake.m
//  Fast Blob
//
//  Created by Andrey Ermoshin on 28.11.15.
//  Copyright © 2015 Speed Run. All rights reserved.
//

#import "FbPhysicalSnake.h"
#import "FBUtils.h"

@interface FbPhysicalSnake ()

@end

@implementation FbPhysicalSnake

- (id)initWithPosition:(CGPoint)scenePosition{
    self = [super initWithPosition:scenePosition];
    if (self == nil){
        return nil;
    }
    self.headSnake.physicsBody.mass = 1.0;
    
    return self;
}

- (void)moveToPoint:(CGPoint)positionInScene fromPoint:(CGPoint)previousPosition{
    if (self.parentScene == nil){
        return;
    }
    
    BOOL addPart = NO;
    if (self.firstMarkTriggered == NO){
        self.markPoint = self.headSnake.position;
        self.firstMarkTriggered = YES;
    }
    else{
        CGFloat currentDistance = [FBUtils distanceBetweenPointsFirstPoint:self.markPoint
                                                               secondPoint:self.headSnake.position];
        if (currentDistance >= kFBSnakePartRadius){
            addPart = YES;
            CGPoint nearPnt = [FBUtils calculatePointForLineNearPoint:self.markPoint
                                                       andSecondPoint:self.headSnake.position
                                                             distance:kSSEmittersShift];
            self.markPoint = nearPnt;
        }
    }
    // http://uios.ru/?p=372
    
    CGPoint newPosition = [FBUtils border:self.headSnake.parent.frame limitedPoint:positionInScene];
    self.headSnake.position = newPosition;
    
    if (self.snakeEmitters.count < self.snakeNodesMax && addPart){
        SKShapeNode *part = [SKShapeNode shapeNodeWithCircleOfRadius:kFBSnakePartRadius];
        part.name = [NSString stringWithFormat:@"SnakePart%lu", (unsigned long)self.snakeEmitters.count];
        part.fillColor = FB_SNAKE_HEAD_COLOR;
        part.strokeColor = FB_SNAKE_HEAD_BORDER_COLOR;
        
        part.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:kFBSnakePartRadius];
        part.physicsBody.categoryBitMask = kFBSnakePartCategory;
        part.physicsBody.contactTestBitMask = kFBSnakePartCategory | kFBHeadCategory;
        part.physicsBody.mass = 0.1;
        part.physicsBody.affectedByGravity = NO;
        part.physicsBody.usesPreciseCollisionDetection = YES;
        part.physicsBody.dynamic = YES;
        
        SKPhysicsJointLimit *joint;
        if (self.snakeEmitters.count == 0){
            // mar point will be 0, 0
            CGPoint nearPnt = [FBUtils calculatePointForLineNearPoint:self.markPoint
                                                       andSecondPoint:self.headSnake.position
                                                             distance:kFBHeadRadius + kFBSnakePartRadius];
            part.position = nearPnt;
            part.zPosition = kFbGameObjectsZPos;
            [self.parentScene addChild:part];
            CGPoint a = CGPointMake(CGRectGetMidX(self.headSnake.frame), CGRectGetMidY(self.headSnake.frame));
            CGPoint b = CGPointMake(CGRectGetMidX(part.frame), CGRectGetMidY(part.frame));
            joint = [SKPhysicsJointLimit jointWithBodyA:self.headSnake.physicsBody
                                                bodyB:part.physicsBody
                                               anchorA:a
                                                anchorB:b];
            joint.maxLength = kFBHeadRadius + kFBSnakePartRadius;
        }
        else{
            SKShapeNode *lastPart = [self.snakeEmitters lastObject];
            CGPoint somePoint = CGPointMake(CGRectGetMidX(self.parentScene.frame), CGRectGetMidY(self.parentScene.frame));
            CGPoint nearPnt = [FBUtils calculatePointForLineNearPoint:somePoint
                                                              andSecondPoint:lastPart.position
                                                             distance:kFBSnakePartRadius * 2];
            part.position = nearPnt;
            part.zPosition = kFbGameObjectsZPos;
            [self.parentScene addChild:part];
            CGPoint a = CGPointMake(CGRectGetMidX(lastPart.frame), CGRectGetMidY(lastPart.frame));
            CGPoint b = CGPointMake(CGRectGetMidX(part.frame), CGRectGetMidY(part.frame));
            joint = [SKPhysicsJointLimit jointWithBodyA:lastPart.physicsBody
                                                bodyB:part.physicsBody
                                               anchorA:a
                                                anchorB:b];
            joint.maxLength = kFBSnakePartRadius * 2;
        }
        
        [self.parentScene.physicsWorld addJoint:joint];
        [self.snakeEmitters addObject:part];
    }
}

// @WARNING: some methods of FbSnake should be re-implemented
// like removeSnakeFromCurrentScene 

@end
