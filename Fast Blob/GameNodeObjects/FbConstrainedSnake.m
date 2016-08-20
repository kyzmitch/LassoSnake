//
//  FbConstrainedSnake.m
//  Fast Blob
//
//  Created by Andrey Ermoshin on 02.12.15.
//  Copyright © 2015 Speed Run. All rights reserved.
//

#import "FbConstrainedSnake.h"
#import "FBUtils.h"
#import "FbLine.h"

@interface FbConstrainedSnake ()

- (void)drawTargetAreaWithPath:(SKShapeNode *)found
               andContactPoint:(CGPoint)p
                 andFoundIndex:(NSInteger)ix;

@property (nonatomic, strong) NSMutableArray *dynamicEmmitters;

@end

@implementation FbConstrainedSnake

- (id)initWithPosition:(CGPoint)scenePosition{
    self = [super initWithPosition:scenePosition];
    if (self == nil){
        return nil;
    }
    self.headSnake.physicsBody.mass = 1.0;
    self.dynamicEmmitters = [NSMutableArray new];
    
    return self;
}

- (void)moveToPoint:(CGPoint)positionInScene fromPoint:(CGPoint)previousPosition{
    if (self.parentScene == nil){
        return;
    }
    
    CGPoint newPosition = [FBUtils border:self.headSnake.parent.frame limitedPoint:positionInScene];
    self.headSnake.position = newPosition;
}

- (void)addToScene:(SKScene *)sceen{
    [super addToScene:sceen];
    
    // http://stefansdevplayground.blogspot.ru/2014/09/howto-implement-targeting-or-follow.html
    
    // * (mark point)
    //  \
    //   \
    //     * (screen center)
    //      \
    //       \
    //        * (head position)
    CGPoint leftTopPnt = CGPointMake(CGRectGetMinX(self.parentScene.frame), CGRectGetMaxY(self.parentScene.frame));
    CGPoint center = CGPointMake(CGRectGetMidX(self.parentScene.frame), CGRectGetMidY(self.parentScene.frame));
    CGFloat distance = [FBUtils distanceBetweenPointsFirstPoint:leftTopPnt secondPoint:center];
    
    self.markPoint = [FBUtils calculatePointForLineNearPoint:leftTopPnt
                                              andSecondPoint:center
                                                    distance:distance/2.0];

    while (self.snakeEmitters.count < self.snakeNodesMax) {
        SKShapeNode *part = [SKShapeNode shapeNodeWithCircleOfRadius:kFBSnakePartRadius];
        part.name = [NSString stringWithFormat:@"SnakePart%lu", (unsigned long)self.snakeEmitters.count];
        part.fillColor = FB_SNAKE_HEAD_COLOR;
        part.strokeColor = FB_SNAKE_HEAD_BORDER_COLOR;
        part.zPosition = kFbGameObjectsZPos;
        
        part.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:kFBSnakePartRadius];
        part.physicsBody.categoryBitMask = kFBSnakePartCategory;
        part.physicsBody.contactTestBitMask = kFBSnakePartCategory | kFBHeadCategory;
        part.physicsBody.mass = 0.1;
        part.physicsBody.affectedByGravity = NO;
        part.physicsBody.usesPreciseCollisionDetection = YES;
        part.physicsBody.dynamic = YES;
        
        SKConstraint *distanceConstraint;
        SKConstraint *orientConstraint;
        
        SKRange *rangeForOrientation = [SKRange rangeWithLowerLimit:(M_2_PI*7) upperLimit:(M_2_PI*7)];
        if (self.snakeEmitters.count == 0){
            // mark point will be 0, 0
            CGPoint nearPnt = [FBUtils calculatePointForLineNearPoint:self.markPoint
                                                              andSecondPoint:self.headSnake.position
                                                                    distance:kFBHeadRadius + kFBSnakePartRadius];
            part.position = nearPnt;
            [self.parentScene addChild:part];
            SKRange *range = [SKRange rangeWithConstantValue:kFBHeadRadius + kFBSnakePartRadius];
            distanceConstraint = [SKConstraint distance:range toNode:self.headSnake];
            orientConstraint = [SKConstraint orientToNode:self.headSnake offset:rangeForOrientation];
        }
        else{
            SKShapeNode *lastPart = [self.snakeEmitters lastObject];
            CGPoint nearPnt = [FBUtils calculatePointForLineNearPoint:self.markPoint
                                                              andSecondPoint:lastPart.position
                                                                    distance:kFBSnakePartRadius * 2];
            part.position = nearPnt;
            [self.parentScene addChild:part];
            SKRange *range = [SKRange rangeWithConstantValue:kFBSnakePartRadius * 2];
            distanceConstraint = [SKConstraint distance:range toNode:lastPart];
            orientConstraint = [SKConstraint orientToNode:lastPart offset:rangeForOrientation];
        }
        NSString *smokePath = [[NSBundle mainBundle] pathForResource:@"MiddleSnakeParticle" ofType:@"sks"];
        static SKEmitterNode *emtr = nil;
        if (emtr == nil){
            emtr = [NSKeyedUnarchiver unarchiveObjectWithFile:smokePath];
        }
        SKEmitterNode *partEmtr = [emtr copy];
        [self.dynamicEmmitters addObject:partEmtr];
        // to get emmitters birth rate from 20 to 14
        CGFloat divisionCoeff = 1 + 0.2 * self.snakeEmitters.count/self.snakeNodesMax;
        partEmtr.particleBirthRate = kFbParticleStartBirthRate / divisionCoeff;
        
        partEmtr.zPosition = kFbSnakeEmittersZPos;
        [part addChild:partEmtr];
        [part setConstraints:[NSArray arrayWithObjects:distanceConstraint, orientConstraint, nil]];
        [self.snakeEmitters addObject:part];
    }
}

-(void)removeSnakeFromCurrentScene{
    self.parentScene = nil;
    [self.headSnake removeFromParent];
    for (SKEmitterNode *emtr in self.dynamicEmmitters){
        [emtr removeFromParent];
    }
    for (SKShapeNode * part in self.snakeEmitters)
    {
        part.constraints = nil;
        [part removeFromParent];
    }
    [self.snakeEmitters removeAllObjects];
    [self.segments removeAllObjects];
    [self.dynamicEmmitters removeAllObjects];
    
}

- (void)checkCollisionWithLine:(SKNode *)l andContactPoint:(CGPoint)p{
    if (self.allowLossoLogic == NO){
        return;
    }
    NSUInteger minNum = 10;
    if (self.snakeEmitters.count <= minNum){
        return;
    }
    
    if (self.snakeEmitters.count > 1){
        SKShapeNode *firstPart = [self.snakeEmitters objectAtIndex:0];
        if ([l isEqual:firstPart]){
            return;
        }
    }
    
    [self.segmentsLock lock];
    
    SKShapeNode *found = nil;
    NSInteger ix = -1;
    for (ix = minNum; ix < self.snakeEmitters.count; ix++){
        SKShapeNode *currentNode = [self.snakeEmitters objectAtIndex:ix];
        if ([currentNode isEqual:l]){
            found = currentNode;
            break;
        }
    }
    
    if (found == nil){
        [self.segmentsLock unlock];
        return;
    }
    
    if (self.canStartNewArea == YES){
        self.canStartNewArea = NO;
    }
    else{
        [self.segmentsLock unlock];
        return;
    }
    
    [self drawTargetAreaWithPath:found andContactPoint:p andFoundIndex:ix];
}

- (void)drawTargetAreaWithPath:(SKShapeNode *)found
               andContactPoint:(CGPoint)p
                 andFoundIndex:(NSInteger)ix{
    
    NSMutableArray *points = [[NSMutableArray alloc] init];
    UIBezierPath *figurePath = [[UIBezierPath alloc] init];
    [figurePath moveToPoint:p];
    [figurePath addLineToPoint:found.position];
    [points addObject:[NSValue valueWithCGPoint:p]];
    [points addObject:[NSValue valueWithCGPoint:found.position]];
    
    for (NSInteger nx = ix - 1; nx > 0; nx--){
        SKShapeNode *partNode = [self.snakeEmitters objectAtIndex:nx];
        [figurePath addLineToPoint:partNode.position];
        [points addObject:[NSValue valueWithCGPoint:partNode.position]];
    }
    [self.segmentsLock unlock];
    [figurePath addLineToPoint:p]; // close path
    [points addObject:[NSValue valueWithCGPoint:p]];
    
    SKShapeNode *targetArea = [SKShapeNode shapeNodeWithPath:figurePath.CGPath];
    
    
    targetArea.fillColor = FB_CONTROLLED_AREA_CLR;
    targetArea.strokeColor = FB_CONTROLLED_AREA_BORDER_CLR;
    // increase the lineWidth of the SKShapeNode so it fills up the gap.
    targetArea.lineWidth = 4;
    targetArea.zPosition = kFbGameObjectsZPos;
    [self.parentScene addChild:targetArea];
    
    // @TODO: points not used actually
    [self.delegate didSnake:self createdAreaWithLinesPoints:points andNode:targetArea];
    
    SKAction *fadeIn = [SKAction fadeInWithDuration:0.5];
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.5];
    [targetArea runAction:fadeIn completion:^{
        [targetArea runAction:fadeOut completion:^{
            [targetArea removeFromParent];
            self.canStartNewArea = YES;
        }];
    }];
}

@end
