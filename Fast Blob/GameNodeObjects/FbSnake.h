//
//  FbSnake.h
//  Fast Blob
//
//  Created by Andrey Ermoshin on 10.07.15.
//  Copyright (c) 2015 Speed Run. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class FbSnake;

@protocol FbSnakeDelegate <NSObject>
@optional
- (void)didSnake:(FbSnake *)snake createdAreaWithLinesPoints:(NSArray *)points andNode:(SKShapeNode *)node;

@end

@class FbLine;

@interface FbSnake : NSObject

@property (readonly, strong, nonatomic) SKShapeNode * headSnake;
@property (weak, nonatomic) id<FbSnakeDelegate> delegate;
@property (nonatomic, assign) BOOL allowLossoLogic;
@property (weak, nonatomic) SKScene *parentScene;
@property (strong, nonatomic) NSMutableArray *snakeEmitters;
@property (strong, nonatomic) NSMutableArray *segments;
@property (readwrite, nonatomic) BOOL canStartNewArea;
@property (readwrite, nonatomic) CGPoint markPoint;
@property (readwrite, nonatomic) BOOL firstMarkTriggered;
@property (strong, nonatomic) NSLock *segmentsLock;
@property (nonatomic, readwrite) NSUInteger snakeNodesMax;

- (id)initWithPosition:(CGPoint)scenePosition;
- (void)addToScene:(SKScene *)sceen;
- (void)moveToPoint:(CGPoint)positionInScene fromPoint:(CGPoint)previousPosition;
- (void)removeSnakeFromCurrentScene;
- (void)checkCollisionWithLine:(SKNode *)l andContactPoint:(CGPoint)p;
- (void)highlightHead:(BOOL)start;

@end
