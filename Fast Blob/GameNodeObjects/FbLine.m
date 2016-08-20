//
//  FbLine.m
//  Fast Blob
//
//  Created by Andrey Ermoshin on 12.07.15.
//  Copyright (c) 2015 Speed Run. All rights reserved.
//

#import "FbLine.h"

@interface FbLine ()
{
@private
    CGPoint _p1;
    CGPoint _p2;
}

@property (strong, nonatomic) SKShapeNode *lineNode;

@end

@implementation FbLine

@synthesize lineNode;


- (id)initWithP1:(CGPoint)p1 andP2:(CGPoint)p2{
    return [self initLineWithP1:p1
                              andP2:p2
                          withColor:[UIColor redColor]
                    categoryBitMask:kFBLineCategory
                 contactTestBitMask:kFBHeadCategory | kFBLineCategory];
}

- (id)initWithP1:(CGPoint)p1 andP2:(CGPoint)p2 withColor:(UIColor *)color{
    return [self initLineWithP1:p1
                              andP2:p2
                          withColor:color
                    categoryBitMask:kFBLineCategory
                 contactTestBitMask:kFBHeadCategory | kFBLineCategory];
}


- (id)initLineWithP1:(CGPoint)p1
                   andP2:(CGPoint)p2
               withColor:(UIColor *)color
         categoryBitMask:(uint32_t)category
      contactTestBitMask:(uint32_t)contactTestBitMask
{
    self = [super init];
    if (self == nil){
        return nil;
    }
    
    _p1 = p1;
    _p2 = p2;
    
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:_p1];
    [linePath addLineToPoint:_p2];
    self.lineNode = [SKShapeNode shapeNodeWithPath:linePath.CGPath];
#if __FB_COLLISION_SNAKE_LINES_VISIBLE
    self.lineNode.strokeColor = color;
#else
    self.lineNode.strokeColor = [UIColor clearColor];
#endif
    self.lineNode.lineWidth = 1;
    
    self.lineNode.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:_p1 toPoint:_p2];
    self.lineNode.physicsBody.categoryBitMask = category;
    self.lineNode.physicsBody.collisionBitMask = 0;
    self.lineNode.physicsBody.contactTestBitMask = contactTestBitMask;
    self.lineNode.zPosition = kFbGameObjectsZPos;
    
    return self;
}



- (void)dealloc{
    [self.lineNode removeFromParent];
}


- (void)addToScene:(SKScene *)scene{
    if (self.lineNode == nil){
        return;
    }
    [self.lineNode removeFromParent];
    [scene addChild:self.lineNode];
}

- (void)removeFromScene{
    [self.lineNode removeFromParent];
}

- (void)addToNode:(SKShapeNode *)node
{
    if (self.lineNode == nil){
        return;
    }
    [self.lineNode removeFromParent];
    [node addChild:self.lineNode];
}

- (BOOL)calculatedWithPoint:(CGPoint)p{
    if (CGPointEqualToPoint(p, _p1)){
        return YES;
    }
    if (CGPointEqualToPoint(p, _p2)){
        return YES;
    }
    
    return NO;
}

- (CGPoint)getP1{
    return _p1;
}
- (CGPoint)getP2{
    return _p2;
}

- (BOOL)isItOwnShapeNode:(SKNode *)n{
    if ([n isEqual:self.lineNode]){
        return YES;
    }
    return NO;
}

- (void)lightUpShape{
    SKAction *outAct = [SKAction fadeOutWithDuration:1];
    SKAction *inAct = [SKAction fadeInWithDuration:1];
    [self.lineNode removeAllActions];
    [self.lineNode runAction:outAct completion:^{
        [self.lineNode runAction:inAct completion:^{
            
        }];
    }];
}

@end
