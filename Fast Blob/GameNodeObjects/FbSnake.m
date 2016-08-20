//
//  FbSnake.m
//  Fast Blob
//
//  Created by Andrey Ermoshin on 10.07.15.
//  Copyright (c) 2015 Speed Run. All rights reserved.
//

#import "FbSnake.h"
#import "FBUtils.h"
#import "FbLine.h"

#define kFbHighlighHeadAction @"kFbHighlighHeadAction"

@interface FbSnake ()
{
@private
    __strong SKEmitterNode *_headSmokeEmitter;
    BOOL _firstMarkTriggered;
    CGPoint _markPoint;
    __weak SKScene *_parentScene;
    __strong NSLock *_segmentsLock;
    BOOL _canStartNewArea;
}

@property (readwrite, strong, nonatomic) SKShapeNode * headSnake;

- (SKEmitterNode *)headSmokeEmitter;
- (void)addContactLineBetweenEmittersWithP1:(CGPoint)p1 andP2:(CGPoint)p2;
- (void)continueSegmentLinesToPoint:(CGPoint)p;
- (void)drawTargetAreaWithPath:(FbLine *)found
               andContactPoint:(CGPoint)p
                 andFoundIndex:(NSInteger)ix;

@end

@implementation FbSnake

@synthesize headSnake, segments, snakeEmitters, parentScene = _parentScene, firstMarkTriggered = _firstMarkTriggered;
@synthesize delegate, allowLossoLogic, canStartNewArea = _canStartNewArea, markPoint = _markPoint, segmentsLock = _segmentsLock;

- (id)initWithPosition:(CGPoint)scenePosition{
    self = [super init];
    if (self == nil){
        return nil;
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        self.snakeNodesMax = kMFNumberOfSnakeNodesiPhone;
    }
    else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        self.snakeNodesMax = kMFNumberOfSnakeNodesiPad;
    }
    else{
        self.snakeNodesMax = kMFNumberOfSnakeNodesiPhone;
    }
    
    self.headSnake = [SKShapeNode shapeNodeWithCircleOfRadius:kFBHeadRadius];
    self.headSnake.name = @"Head";
    self.headSnake.fillColor = FB_SNAKE_HEAD_COLOR;
    self.headSnake.strokeColor = FB_SNAKE_HEAD_BORDER_COLOR;
    
    self.headSnake.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:kFBHeadRadius];
    self.headSnake.physicsBody.categoryBitMask = kFBHeadCategory;
    self.headSnake.physicsBody.contactTestBitMask = kFBLineCategory | kFBSnakePartCategory | kFBEnemyFoodCategory | kFBFoodCategory| kFBBonusCategory;
    self.headSnake.physicsBody.affectedByGravity = NO;
    self.headSnake.physicsBody.usesPreciseCollisionDetection = YES;
    self.headSnake.physicsBody.dynamic = YES;
    
 
    self.segments = [[NSMutableArray alloc] init];
    self.snakeEmitters = [[NSMutableArray alloc] init];
    
    _segmentsLock = [[NSLock alloc] init];
    
    self.canStartNewArea = YES;
    self.markPoint = CGPointMake(0, 0);
    self.firstMarkTriggered = NO;
    self.allowLossoLogic = NO;
    self.headSnake.position = scenePosition;
    self.headSnake.zPosition = kFbGameObjectsZPos;
    
    return self;
}

- (void)addToScene:(SKScene *)sceen{
    if (self.headSnake){
        [self.headSnake removeFromParent];
        [sceen addChild:self.headSnake];
        _parentScene = sceen;
    }
}

- (SKEmitterNode *)headSmokeEmitter{
    if (_headSmokeEmitter == nil) {
        NSString *smokePath = [[NSBundle mainBundle] pathForResource:@"HeadFireParticle" ofType:@"sks"];
        _headSmokeEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:smokePath];
    }
    
    return _headSmokeEmitter;
}

- (void)moveToPoint:(CGPoint)positionInScene fromPoint:(CGPoint)previousPosition{
    if (_parentScene == nil){
        return;
    }
    
    BOOL recalculateEmitters = NO;
    
    if (_firstMarkTriggered == NO){
        _markPoint = self.headSnake.position;
        _firstMarkTriggered = YES;
        NSLog(@"First mark point %@", NSStringFromCGPoint(_markPoint));
    }
    else{
        CGFloat currentDistance = [FBUtils distanceBetweenPointsFirstPoint:_markPoint
                                                            secondPoint:self.headSnake.position];
        if (currentDistance >= kSSEmittersShift){
            recalculateEmitters = YES;
            CGPoint nearPnt = [FBUtils calculatePointForLineNearPoint:_markPoint
                                                       andSecondPoint:self.headSnake.position
                                                             distance:kSSEmittersShift];
            _markPoint = nearPnt;
#ifdef __DEBUG_TRACE_DISTANCE
            NSLog(@"Current position %@, current distance %f", NSStringFromCGPoint(positionInScene), currentDistance);
#endif
        }
    }
    
    CGPoint newPosition = [FBUtils border:self.headSnake.parent.frame limitedPoint:positionInScene];
    self.headSnake.position = newPosition;

    if (recalculateEmitters){
        if (self.snakeEmitters.count < self.snakeNodesMax){
            
            // create emitter
            if (self.snakeEmitters.count == 0){
                // first Emitter in array
                self.headSmokeEmitter.position = _markPoint;
                self.headSmokeEmitter.targetNode = _parentScene;
                self.headSmokeEmitter.zPosition = kFbGameObjectsZPos;
                [self.snakeEmitters addObject:self.headSmokeEmitter];
                [_parentScene addChild:self.headSmokeEmitter];
                
                self.headSmokeEmitter.emissionAngle = [FBUtils calculateAngleWithLineFirstPoint:positionInScene
                                                                              andSecondPoint:_markPoint];
            }
            else{
                NSString *smokePath = [[NSBundle mainBundle] pathForResource:@"MiddleSnakeParticle" ofType:@"sks"];
                SKEmitterNode *emtr = [NSKeyedUnarchiver unarchiveObjectWithFile:smokePath];

                
                emtr.position = _markPoint;
                emtr.targetNode = _parentScene;
                emtr.zPosition = kFbGameObjectsZPos;
                SKEmitterNode *prevNode = [self.snakeEmitters objectAtIndex:self.snakeEmitters.count - 1];
                [self.snakeEmitters addObject:emtr];
                [_parentScene addChild:emtr];
                
                emtr.emissionAngle = [FBUtils calculateAngleWithLineFirstPoint:_markPoint
                                                             andSecondPoint:prevNode.position];
                
                //  @NOTE: Skip line after head and after that line (2nd line)
                //  because minimum polygon will be triangle and
                //  Head can contact minimum with a 3rd line and next lines
                //  but not with a 1st and 2nd lines.
                //          \
                //           . (emitter 3)
                //            \
                //             \
                //              \
                //         _     \
                //         /\     \
                //        *(head)  \
                //       /          \
                //      /            \
                //     /              \
                //    /                \
                //   .-(emitter 1)------. (emitter 2)
                
                if (self.allowLossoLogic) {
                    if (self.segments.count == 0){
                        [self addContactLineBetweenEmittersWithP1:_markPoint andP2:newPosition];
                    }
                    else{
                        NSUInteger ix = self.segments.count - 1;
                        [_segmentsLock lock];
                        FbLine *prevLine = [self.segments objectAtIndex:ix];
                        CGPoint firstP = [prevLine getP2];
                        [_segmentsLock unlock];
                        [self addContactLineBetweenEmittersWithP1:firstP andP2:newPosition];
                    }
                    
                    // all lines are created now
                }
            }
        }
        else{
            if (self.allowLossoLogic){
                [self continueSegmentLinesToPoint:_markPoint];
            }
            
            CGPoint prevPosition;
            CGPoint middlePrevPosition;
            for (NSInteger ie = self.snakeEmitters.count - 1; ie >= 0 ; ie--){
                SKEmitterNode *emtr = [self.snakeEmitters objectAtIndex:ie];
                if (ie == self.snakeEmitters.count - 1){
                    
                    middlePrevPosition = [FBUtils calculatePointForLineNearPoint:emtr.position
                                                                  andSecondPoint:_markPoint
                                                                        distance:kSSEmittersShift];
#if __FB_MOVE_SNAKE
                    SKAction *moveAction = [SKAction moveTo:_markPoint duration:0.1];
                    [emtr runAction:moveAction completion:^{
#endif
                        emtr.position = _markPoint;
#if __FB_MOVE_SNAKE
                    }];
#endif
                    
                    emtr.emissionAngle = [FBUtils calculateAngleWithLineFirstPoint:_markPoint
                                                                 andSecondPoint:middlePrevPosition];
                    
                    
                    
                }
                else{
                    prevPosition = [FBUtils calculatePointForLineNearPoint:emtr.position
                                                          andSecondPoint:middlePrevPosition
                                                                  distance:kSSEmittersShift];
#if __FB_MOVE_SNAKE
                    SKAction *moveAction = [SKAction moveTo:middlePrevPosition duration:0.1];
                    [emtr runAction:moveAction completion:^{
#endif
                        emtr.position = middlePrevPosition;
#if __FB_MOVE_SNAKE
                    }];
#endif
                    
                    emtr.emissionAngle = [FBUtils calculateAngleWithLineFirstPoint:middlePrevPosition
                                                                 andSecondPoint:prevPosition];
                    middlePrevPosition = prevPosition;
                }
            }
        }
    }
}

- (void)addContactLineBetweenEmittersWithP1:(CGPoint)p1 andP2:(CGPoint)p2{
    FbLine *line = [[FbLine alloc] initWithP1:p1 andP2:p2 withColor:[UIColor redColor]];
    [_segmentsLock lock];
    [self.segments addObject:line];
    [_segmentsLock unlock];
    [line addToScene:_parentScene];
}

- (void)continueSegmentLinesToPoint:(CGPoint)p{
    // will add new line and remove the last line
    [_segmentsLock lock];
    NSUInteger lastIx = self.segments.count - 1;
    FbLine *nearHeadLine = [self.segments objectAtIndex:lastIx];
    FbLine *newHeadLine = [[FbLine alloc] initWithP1:[nearHeadLine getP2] andP2:p withColor:[UIColor redColor]];
    [self.segments addObject:newHeadLine];
    [self.segments removeObjectAtIndex:0];
    [_segmentsLock unlock];
    [newHeadLine addToScene:_parentScene];
}

- (void)addCorrectLineBetweenEmittersWithP1:(CGPoint)p1 andP2:(CGPoint)p2{
    FbLine *line = [[FbLine alloc] initWithP1:p1 andP2:p2 withColor:[UIColor greenColor]];
    [line addToScene:_parentScene];
}

-(void)removeSnakeFromCurrentScene{
    _parentScene = nil;
    [self.headSnake removeFromParent];
    for (SKEmitterNode * emit in self.snakeEmitters)
    {
        [emit removeFromParent];
    }
    [self.snakeEmitters removeAllObjects];
    for (FbLine *ln in self.segments){
        [ln removeFromScene];
    }
    [self.segments removeAllObjects];
}

- (void)checkCollisionWithLine:(SKNode *)l andContactPoint:(CGPoint)p{
    
    if (self.allowLossoLogic == NO){
        return;
    }
    
    [_segmentsLock lock];
    if (self.segments.count < 3){
        [_segmentsLock unlock];
        return;
    }
    FbLine *first = [self.segments objectAtIndex:self.segments.count - 1];
    FbLine *second = [self.segments objectAtIndex:self.segments.count - 2];
    if ([l isEqual:first]){
        [_segmentsLock unlock];
        return;
    }
    if ([l isEqual:second]){
        [_segmentsLock unlock];
        return;
    }
    
    FbLine *found = nil;
    NSInteger ix = -1;
    for (ix = self.segments.count - 3; ix >= 0; ix--){
        FbLine *current = [self.segments objectAtIndex:ix];
        if ([current isItOwnShapeNode:l]){
            found = current;
            break;
        }
    }
    
    if (found == nil){
        [_segmentsLock unlock];
        return;
    }
    
    if (ix > self.segments.count - 4){
        // to make minimum triangle
        [_segmentsLock unlock];
        return;
    }
    
    if (_canStartNewArea == YES){
        _canStartNewArea = NO;
    }
    else{
        [_segmentsLock unlock];
        return;
    }
    
    // NSLog(@"Snake: found a head to line contact: %@ - %@", NSStringFromCGPoint([found getP1]), NSStringFromCGPoint([found getP2]));
    
    
    [found lightUpShape];
    
    // need to find out point of lines contact
#if __FB_DRAW_CONTACT_POINT_DEBUG
    SKShapeNode *pL = [SKShapeNode shapeNodeWithCircleOfRadius:4];
    pL.fillColor = [UIColor orangeColor];
    pL.position = p;
    pL.zPosition = kFbGameObjectsZPos;
    [_parentScene addChild:pL];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [pL removeFromParent];
    });
#endif
    
    [self drawTargetAreaWithPath:found andContactPoint:p andFoundIndex:ix];
}

- (void)drawTargetAreaWithPath:(FbLine *)found
               andContactPoint:(CGPoint)p
                 andFoundIndex:(NSInteger)ix{
    
    NSMutableArray *points = [[NSMutableArray alloc] init];
    UIBezierPath *figurePath = [[UIBezierPath alloc] init];
    [figurePath moveToPoint:p];
    [figurePath addLineToPoint:[found getP2]];
    [points addObject:[NSValue valueWithCGPoint:p]];
    [points addObject:[NSValue valueWithCGPoint:[found getP2]]];
    
    for (NSInteger nx = ix + 1; nx < self.segments.count - 1; nx++){
        FbLine *nLine = [self.segments objectAtIndex:nx];
        [figurePath addLineToPoint:[nLine getP2]];
        [points addObject:[NSValue valueWithCGPoint:[nLine getP2]]];
    }
    [_segmentsLock unlock];
    [figurePath addLineToPoint:p]; // close path
    [points addObject:[NSValue valueWithCGPoint:p]];
    
    SKShapeNode *targetArea = [SKShapeNode shapeNodeWithPath:figurePath.CGPath];


    targetArea.fillColor = FB_CONTROLLED_AREA_CLR;
    targetArea.strokeColor = FB_CONTROLLED_AREA_BORDER_CLR;
    // increase the lineWidth of the SKShapeNode so it fills up the gap.
    targetArea.lineWidth = 4;
    targetArea.zPosition = kFbGameObjectsZPos;
    [_parentScene addChild:targetArea];
    
    // @TODO: points not used actually
    [self.delegate didSnake:self createdAreaWithLinesPoints:points andNode:targetArea];
    
    SKAction *fadeIn = [SKAction fadeInWithDuration:0.5];
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.5];
    [targetArea runAction:fadeIn completion:^{
        [targetArea runAction:fadeOut completion:^{
            [targetArea removeFromParent];
            _canStartNewArea = YES;
        }];
    }];
}

- (void)highlightHead:(BOOL)start{
    if (start) {
        SKAction *outAct = [SKAction fadeOutWithDuration:0.5];
        SKAction *inAct = [SKAction fadeInWithDuration:0.5];
        SKAction *mainAct = [SKAction sequence:[NSArray arrayWithObjects:outAct, inAct, nil]];
        SKAction *repeated = [SKAction repeatActionForever:mainAct];

        self.headSnake.alpha = 0;
        [self.headSnake runAction:repeated withKey:kFbHighlighHeadAction];
    }
    else{
        [self.headSnake removeActionForKey:kFbHighlighHeadAction];
        self.headSnake.alpha = 1;
    }
}

@end
