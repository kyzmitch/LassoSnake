//
//  GameScene.m
//  Fast Blob
//
//  Created by Igor on 29.06.15.
//  Copyright (c) 2015 Speed Run. All rights reserved.
//

#import "GameScene.h"
#import "FbSnake.h"
#import "FbPhysicalSnake.h"
#import "FbConstrainedSnake.h"
#import "FBScores.h"
#import "Timer.h"
#import "FbSquare.h"
#import "Stopwatch.h"
#import "FBUtils.h"
#import "SCLAlertView.h"
#import "FBBonus.h"
#import <GameKit/GameKit.h>
#import "GameViewController.h"
#import <AVFoundation/AVFoundation.h>



#define __ORIGINAL_SOLUTION_LOSSO_BOXES 1
#define MUTE [[NSUserDefaults standardUserDefaults]boolForKey:@"Mute"]

static const CGFloat kFbSEdgeRectInsideScene = 60;
static const CGFloat kFbSEdgeRectMatchPoint = 100;


@interface GameScene ()     <SKPhysicsContactDelegate,
                            FbSnakeDelegate>
{
@private
    BOOL _triggerStarting;

    NSUInteger _totalTime;
    NSUInteger _indexPointNewShape;
    CGPoint _location;
    NSUInteger _bonus;
    NSUInteger _timeToLifeBonus;
    NSMutableArray * _arraySquare;
    NSMutableArray * _arraySquareEnemy;
    NSMutableArray * _arrayStopwatch;
    NSMutableArray * _arrayGenerateRandomPoints;
}

@property (nonatomic, strong) FbConstrainedSnake *playerSnake;
@property (nonatomic, strong) FBScores *levelScoreLabelNode;
@property (nonatomic, strong) Timer * levelTimeLabelNode;
@property (nonatomic, strong) FBBonus *currentActiveBonus;
@property (nonatomic, strong) NSTimer *levelRefreshTimer;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;


-(void)restartLevelRefreshingTimerWithNewTotalTime:(NSUInteger)totalTime;
-(CGPoint)generatePointOutsideAllShapes:(NSUInteger)radiusCoverageArea;
-(CGPoint)takePointFromGenerateArray;
-(CGPoint)generateRandomPointWithIndentBorderScreen :(CGFloat)borderScreenIndent;
-(NSMutableArray *)getAllBoxesNodesInScene;
-(void)playSoundEffectName:(NSString * )soundEffect;
-(void)clearLevelAtTheEnd;
-(void)returnToMainMenu:(id)sender;
-(void)createBackgroundDiagonalLines;

@end

@implementation GameScene

@synthesize playerSnake, levelScoreLabelNode, levelTimeLabelNode, levelRefreshTimer, currentActiveBonus;

-(id)initWithSize:(CGSize)size{
    
    NSLog(@"Game Scene: Init");
    if(self = [super initWithSize:size])
    {
        self.backgroundColor = [SKColor blackColor];
        self.physicsWorld.contactDelegate = self;

    }
    
    return  self;
}

- (void)createBackgroundDiagonalLines{
    
    UIBezierPath *ln1Path = [UIBezierPath bezierPath];
#if __FB_DIAGONAL_BACKGROUND
    CGPoint p1 = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame));
    CGPoint p2 = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame));
    CGPoint p3 = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMidY(self.frame));
#else
    CGPoint p1 = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame));
    CGPoint p2 = CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame));
    CGPoint p3 = CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMidY(self.frame)*1.5);
    CGPoint p4 = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMidY(self.frame)*1.5);
#endif
    [ln1Path moveToPoint:p1];
    [ln1Path addLineToPoint:p2];
    [ln1Path addLineToPoint:p3];
#if __FB_DIAGONAL_BACKGROUND
    [ln1Path addLineToPoint:p1];
#else
    [ln1Path addLineToPoint:p4];
#endif
    
    SKShapeNode *topLeftArea = [SKShapeNode shapeNodeWithPath:ln1Path.CGPath];
    topLeftArea.fillColor = FB_GAME_LEVEL_1_BACK_COLOR;
    topLeftArea.strokeColor = FB_GAME_LEVEL_1_BACK_COLOR;
    topLeftArea.lineWidth = 1;
    topLeftArea.zPosition = kFbBackgroundNodesZPos;
    topLeftArea.physicsBody = nil;
    [self addChild:topLeftArea];
    
    UIBezierPath *ln2Path = [UIBezierPath bezierPath];
#if __FB_DIAGONAL_BACKGROUND
    CGPoint p21 = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame));
    CGPoint p22 = CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame));
    CGPoint p23 = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame));
    CGPoint p24 = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMidY(self.frame));
#else
    CGPoint p21 = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMidY(self.frame)*1.5);
    CGPoint p22 = CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMidY(self.frame)*1.5);
    CGPoint p23 = CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMidY(self.frame));
    CGPoint p24 = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMidY(self.frame));
#endif
    [ln2Path moveToPoint:p21];
    [ln2Path addLineToPoint:p22];
    [ln2Path addLineToPoint:p23];
    [ln2Path addLineToPoint:p24];
    
    SKShapeNode *topMidArea = [SKShapeNode shapeNodeWithPath:ln2Path.CGPath];
    topMidArea.fillColor = [SKColor cyanColor];
    topMidArea.strokeColor = [SKColor cyanColor];
    topMidArea.lineWidth = 1;
    topMidArea.zPosition = kFbBackgroundNodesZPos;
    topMidArea.physicsBody = nil;
    [self addChild:topMidArea];
    
    UIBezierPath *ln3Path = [UIBezierPath bezierPath];
#if __FB_DIAGONAL_BACKGROUND
    CGPoint p31 = CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame));
    CGPoint p32 = CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMidY(self.frame));
    CGPoint p33 = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame));
    CGPoint p34 = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame));
#else
    CGPoint p31 = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMidY(self.frame));
    CGPoint p32 = CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMidY(self.frame));
    CGPoint p33 = CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMidY(self.frame)/2.0);
    CGPoint p34 = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMidY(self.frame)/2.0);
#endif
    [ln3Path moveToPoint:p31];
    [ln3Path addLineToPoint:p32];
    [ln3Path addLineToPoint:p33];
    [ln3Path addLineToPoint:p34];
    
    SKShapeNode *bottomMidArea = [SKShapeNode shapeNodeWithPath:ln3Path.CGPath];
    bottomMidArea.fillColor = [SKColor orangeColor];
    bottomMidArea.strokeColor = [SKColor orangeColor];
    bottomMidArea.lineWidth = 1;
    bottomMidArea.zPosition = kFbBackgroundNodesZPos;
    bottomMidArea.physicsBody = nil;
    [self addChild:bottomMidArea];

#if !__FB_DIAGONAL_BACKGROUND
    UIBezierPath *ln4Path = [UIBezierPath bezierPath];
    
    CGPoint p41 = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMidY(self.frame)/2.0);
    CGPoint p42 = CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMidY(self.frame)/2.0);
    CGPoint p43 = CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMinY(self.frame));
    CGPoint p44 = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame));
    
    [ln3Path moveToPoint:p41];
    [ln3Path addLineToPoint:p42];
    [ln3Path addLineToPoint:p43];
    [ln3Path addLineToPoint:p44];
    
    SKShapeNode *bottomRightArea = [SKShapeNode shapeNodeWithPath:ln4Path.CGPath];
    bottomRightArea.fillColor = [SKColor blackColor];
    bottomRightArea.strokeColor = [SKColor blackColor];
    bottomRightArea.lineWidth = 1;
    bottomRightArea.zPosition = kFbBackgroundNodesZPos;
    bottomRightArea.physicsBody = nil;
    [self addChild:bottomRightArea];
#endif
    
#if __FB_REPLACE_BACK_NODES_WITH_ONE_TEXTURE
    SKTexture *resultedTexture = [self.view textureFromNode:self];
    
    [topLeftArea removeFromParent];
    [topMidArea removeFromParent];
    [bottomMidArea removeFromParent];
#if !__FB_DIAGONAL_BACKGROUND
    [bottomRightArea removeFromParent];
#endif
    
    CGSize screenSize = self.frame.size;
    SKSpriteNode *textureNode = [SKSpriteNode spriteNodeWithTexture:resultedTexture size:screenSize];
    textureNode.zPosition = kFbMainNodeZPos;
    textureNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:textureNode];
#endif
}

- (void)createSceneContents
{
    _triggerStarting = NO;
    
    _arraySquare = [NSMutableArray array];
    _arraySquareEnemy = [NSMutableArray array];
    _arrayGenerateRandomPoints = [NSMutableArray array];
    _arrayStopwatch = [NSMutableArray array];
    _indexPointNewShape = 0;
    _bonus = 1;
    
    
    //------------------------------------------------Main Sound-----------------------------------
    
    
    if(MUTE == NO)
    {
#if __FB_INCLUDE_PRIVATE_RESOURCES
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Vladimir_Coel_Obuhov_Cool_Theme.mp3", [[NSBundle mainBundle] resourcePath]]];
        NSError *error;
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        self.audioPlayer.numberOfLoops = -1;
        
        if (!self.audioPlayer)
            NSLog(@"%@",[error localizedDescription]);
        else
            [self.audioPlayer play];
#endif
    }
    //------------------------------------------------Main Sound-----------------------------------
    CGPoint sceneCenter = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    CGPoint sceneBottomRight = CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMinY(self.frame));
    CGFloat distance = [FBUtils distanceBetweenPointsFirstPoint:sceneCenter
                                                    secondPoint:sceneBottomRight];
    CGPoint snakeInitPoint = [FBUtils calculatePointForLineNearPoint:sceneCenter
                                                      andSecondPoint:sceneBottomRight
                                                            distance:distance/2.0f];
    
    self.playerSnake = [[FbConstrainedSnake alloc] initWithPosition:snakeInitPoint];
    self.playerSnake.delegate = self;
    
    CGPoint timerLocation = CGPointMake(CGRectGetMidX(self.frame),
                                        CGRectGetMaxY(self.frame));
    self.levelTimeLabelNode = [Timer createTimerInLocation:timerLocation];
    
    CGPoint globalScoreLocation = CGPointMake(CGRectGetMaxX(self.frame),
                                              CGRectGetMaxY(self.frame));
    self.levelScoreLabelNode = [FBScores createScoresInLocation:globalScoreLocation];
    
    
    self.playerSnake.allowLossoLogic = YES;
    
    [self.levelTimeLabelNode addToScene:self];
    [self.levelScoreLabelNode addToScene:self];
    [self.playerSnake addToScene:self];
    [self.playerSnake highlightHead:YES];
    
    // Timer should restart only after initializations above
    [self restartLevelRefreshingTimerWithNewTotalTime:kFbFirstLevelTime];
    [self.levelScoreLabelNode addToScene:self];
    
}
//-------------------------------------------------------------touches--------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (_triggerStarting)
    {
        return;
    }
    
    [self.playerSnake highlightHead:NO];
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    CGPoint previousPosition = [touch previousLocationInNode:self];
    _location = positionInScene;
    [self.playerSnake moveToPoint:positionInScene fromPoint:previousPosition];
}

//-----------------------------------------------------------------------
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    if (![self.playerSnake.headSnake containsPoint:positionInScene])
    {
        _triggerStarting = YES;
    }}
//-----------------------------------------------------------------------

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _triggerStarting = NO;
}

//----------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------touches--------------------------------------------------

-(void)didMoveToView:(SKView *)view
{
    NSLog(@"Game Scene: didMoveToView");

    [self createSceneContents];
}

- (void)willMoveFromView:(SKView *)view{
    NSLog(@"Game Scene: willMoveFromView");
}

//---------------------------------------------------------------
-(void)clearLevelAtTheEnd

{
    CGPoint snakeInitPoint = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    self.playerSnake.headSnake.position = snakeInitPoint;
    [self.playerSnake removeSnakeFromCurrentScene];
    [self.audioPlayer stop];
    [self removeAllChildren];

}

//---------------------------------------------------------------
-(void)generateRamdomShapeOnStage
{
#if __FB_CREATE_BONUSES_MORE_FREQ
    u_int32_t rc = 2;
#else
    u_int32_t rc = arc4random_uniform(4)%4;
#endif
    
    
    switch(rc) {
        case 0:
            [[self sqaureItHasNoAnimationTypeSqaure:NO] redrawOnScene:self withLocation:[self takePointFromGenerateArray]];
            
            break;
        case 1:
            if(arc4random_uniform(10)%10  == 0)
            {
                [[self stopwatchItHasNoAnimation] redrawOnScene:self withLocation:[self takePointFromGenerateArray]];
            }
            else
            {
                [[self sqaureItHasNoAnimationTypeSqaure:YES] redrawOnScene:self withLocation:[self takePointFromGenerateArray]];
            }
            break;
        case 2:{
#if __FB_CREATE_BONUSES_MORE_FREQ
            u_int32_t subRc = 0;
#else
            u_int32_t subRc = arc4random_uniform(10)%10;
#endif
            
            if(subRc == 0)
            {
                NSUInteger bonusNumber;
                do
                {
                    bonusNumber = arc4random_uniform(6);
                }
                while (bonusNumber == 1 || bonusNumber == 0);
                
                if (self.currentActiveBonus){
                    // allow only one bonus at the same time
                    [self.currentActiveBonus removeFromParent];
                }
                self.currentActiveBonus = [FBBonus createBonusWithСoefficient:bonusNumber];
                [self.currentActiveBonus redrawOnScene:self
                                          withLocation:[self takePointFromGenerateArray]];
                
            }
            else
            {
                [[self sqaureItHasNoAnimationTypeSqaure:YES] redrawOnScene:self
                                                              withLocation:[self takePointFromGenerateArray]];
            }
            break;
        }
        default:
            [[self sqaureItHasNoAnimationTypeSqaure:YES] redrawOnScene:self
                                                          withLocation:[self takePointFromGenerateArray]];
            break;
    }
}
//--------------------------------------------------------------

-(void)generateArrayRandomPoints:(NSUInteger)numberPoints
{
    if([_arrayGenerateRandomPoints count] == 0)
    {
       
        [_arrayGenerateRandomPoints addObject:[NSValue valueWithCGPoint:[self generateRandomPointWithIndentBorderScreen:kFbSEdgeRectInsideScene]]];
    }
    
    while([_arrayGenerateRandomPoints count] < numberPoints)
    {
        CGPoint tempPoint = [self generateRandomPointWithIndentBorderScreen:kFbSEdgeRectInsideScene];
        [_arrayGenerateRandomPoints addObject:[NSValue valueWithCGPoint:tempPoint]];
    }
}
//---------------------------------------------------------------
-(FbSquare*)sqaureItHasNoAnimationTypeSqaure:(BOOL)enemy
{
    NSMutableArray * totalArray;
    if(enemy)
    {
        totalArray = _arraySquareEnemy;
    }
    else
    {
        totalArray = _arraySquare;
    }
        if([totalArray count] == 0 )
        {
            FbSquare * fbSquareTemp = [FbSquare createSquareInSceneTypeSquare:enemy];
            [totalArray addObject:fbSquareTemp];
            return fbSquareTemp;
        }
    
    if (enemy)
    {
        FbSquare * fbSquareTemp = [FbSquare createSquareInSceneTypeSquare:enemy];
        [totalArray addObject:fbSquareTemp];
        return fbSquareTemp;
    }
    else
    {

        for (FbSquare* fbSquare in totalArray)
        {
                if(![fbSquare hasActions])
                {
                    return fbSquare;
                                    
                }
                if([[totalArray lastObject]isEqual:fbSquare])
                {
                    FbSquare * fbSquareTemp = [FbSquare createSquareInSceneTypeSquare:enemy];
                    [totalArray addObject:fbSquareTemp];
                    return fbSquareTemp;
                }
        }

    }
    
    return nil;
}
//-------------------------------------------------------------------
-(Stopwatch*)stopwatchItHasNoAnimation
{
    
    if([_arrayStopwatch count] == 0 )
    {
        Stopwatch * stopwatch = [Stopwatch createStopwatch];
        [_arrayStopwatch addObject:stopwatch];
        return stopwatch;
    }
    
    for (Stopwatch* stopw in _arrayStopwatch)
    {
        if(![stopw hasActions])
        {
            return stopw;
            
        }
        if([[_arrayStopwatch lastObject]isEqual:stopw])
        {
            Stopwatch * stopwatchTemp = [Stopwatch createStopwatch];
            [_arrayStopwatch addObject:stopwatchTemp];
            return stopwatchTemp;
        }
    }
    
    return nil;
}

//-------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------Contact----------------------------------------------

#pragma mark - SKPhysicsContactDelegate


-(void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody,*secondBody;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    // line < head < ledge < food < enemy food < watch < gates
    if (((firstBody.categoryBitMask & kFBHeadCategory)!= 0) && ((secondBody.categoryBitMask & kFBStopwatch)!=0))
    {
#if __FB_INCLUDE_PRIVATE_RESOURCES
        [self playSoundEffectName:@"Add_Points.wav"];
#endif
        [self updateTotalTimeWithTemporaryTime:kFbTimeBonus];
        [self.levelTimeLabelNode setLabelTextWithSeconds:_totalTime];
        
        Stopwatch * contactSquare = (Stopwatch*) secondBody.node;
        [contactSquare runAnimationExplosionWithScores];
        [contactSquare removeFromParent];
    }
    
    if (firstBody.categoryBitMask & kFBLineCategory){
        if (secondBody.categoryBitMask & kFBHeadCategory){
            if (secondBody.contactTestBitMask & kFBLineCategory){
                [self.playerSnake checkCollisionWithLine:firstBody.node andContactPoint:contact.contactPoint];
            }
        }
    }
    else if (firstBody.categoryBitMask & kFBHeadCategory){
        if (secondBody.categoryBitMask & kFBLineCategory){
            if ((secondBody.contactTestBitMask & kFBLineCategory) != 0){
                [self.playerSnake checkCollisionWithLine:secondBody.node andContactPoint:contact.contactPoint];
            }
        }
        else if (secondBody.categoryBitMask & kFBSnakePartCategory){
            if (secondBody.contactTestBitMask & kFBHeadCategory){
                [self.playerSnake checkCollisionWithLine:secondBody.node
                                         andContactPoint:contact.contactPoint];
            }
        }
    }
    else if (firstBody.categoryBitMask & kFBSnakePartCategory){
        if (secondBody.categoryBitMask & kFBHeadCategory){
            if (firstBody.contactTestBitMask & kFBHeadCategory) {
                [self.playerSnake checkCollisionWithLine:firstBody.node
                                         andContactPoint:contact.contactPoint];
            }
        }
    }
    //-----------------------------------------------------------------
    
    if (((firstBody.categoryBitMask & kFBHeadCategory)!= 0) && ((secondBody.categoryBitMask & kFBEnemyFoodCategory)!=0))
    {
        [self.levelScoreLabelNode temporaryScore:-30 aboutSnake:self.playerSnake.headSnake];
#if __FB_INCLUDE_PRIVATE_RESOURCES
        [self playSoundEffectName:@"Minus_Points.wav"];
#endif
        [secondBody.node removeFromParent];
    }
    
    //-----------------------------------------------------------------
    
    if (((firstBody.categoryBitMask & kFBHeadCategory)!= 0) && ((secondBody.categoryBitMask & kFBFoodCategory)!=0))
    {
#if __FB_INCLUDE_PRIVATE_RESOURCES
        [self playSoundEffectName:@"Add_Points.wav"];
#endif
        [self.levelScoreLabelNode temporaryScore:30*_bonus aboutSnake:self.playerSnake.headSnake];
        [secondBody.node removeFromParent];
    }
    
    
    if (((firstBody.categoryBitMask & kFBHeadCategory)!= 0) && ((secondBody.categoryBitMask & kFBBonusCategory)!=0))
    {
        FBBonus* boxNode = (FBBonus *) secondBody.node;
#if __FB_INCLUDE_PRIVATE_RESOURCES
        [self playSoundEffectName:@"Bonus.wav"];
#endif
        boxNode.physicsBody = nil;
        NSString * str = [boxNode.name substringFromIndex:6];
        NSUInteger number = [str integerValue];
        _timeToLifeBonus = 5;
        
        [boxNode runAnimationTimeToLife:_timeToLifeBonus nearRightNode:self.levelScoreLabelNode];
        _bonus  = number;
    }
}

//--------------------------------------------------------Contact----------------------------------------------
//-------------------------------------------------------------------------------------------------------------

-(CGPoint)generateRandomPointWithIndentBorderScreen :(CGFloat)borderScreenIndent

{
    CGRect insideRect = CGRectMake(CGRectGetMinX(self.frame) + borderScreenIndent,
                                   CGRectGetMinY(self.frame) + borderScreenIndent,
                                   self.frame.size.width - borderScreenIndent*2,
                                   self.frame.size.height - borderScreenIndent*2);
    CGPoint randomPoint;
    
    while (true)
    {
        randomPoint.x = (float)arc4random_uniform(insideRect.size.width);
        randomPoint.y = (float)arc4random_uniform(insideRect.size.height);
        
        if(CGRectContainsPoint(insideRect, randomPoint))
        {
            return randomPoint;
        }
    }
}
             
//-------------------------------------------------------------------------
-(CGPoint)generatePointOutsideAllShapes:(NSUInteger)radiusCoverageArea
{

    CGPoint tempPoint;
    BOOL pointOutsideRect;
    do
    {
        pointOutsideRect = YES;
        tempPoint = [self generateRandomPointWithIndentBorderScreen:kFbSEdgeRectInsideScene];
        for (SKShapeNode *node in [self getAllBoxesNodesInScene])
        {
            CGRect rectMatchPoint = CGRectMake(node.frame.origin.x - radiusCoverageArea, node.frame.origin.y -radiusCoverageArea, radiusCoverageArea * 2, radiusCoverageArea *2);
                    if(CGRectContainsPoint(rectMatchPoint, tempPoint))
                    {
                            pointOutsideRect = NO;
                            break;
                    }
        }
    }
    while(!pointOutsideRect);
    
    return tempPoint;
}

//-------------------------------------------------------------------------
-(CGPoint)takePointFromGenerateArray
{
    
    CGPoint pointInGenerateArray = [self generatePointOutsideAllShapes:kFbSEdgeRectMatchPoint];
    _indexPointNewShape++;
    return pointInGenerateArray;
    
}
//-------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------Timer------------------------------------------------
-(void)countdown
{
    _totalTime -= 1;
    if (_timeToLifeBonus > 0)
    {
        _timeToLifeBonus-=1;
    }
    else if(_timeToLifeBonus == 0)
    {
        _bonus = 1;
    }
    [self.levelTimeLabelNode setLabelTextWithSeconds:_totalTime];
  
    if(_totalTime == 0)
    {

        [self reportHighScore:self.levelScoreLabelNode.totalScore forLeaderboardId:kLSIDLeaderBoards];
        [self gameOver];

    }
    else
    {
        [self generateRamdomShapeOnStage];
       
    }
}

//--------------------------------------------------------------------------

-(void)gameOver
{
    [levelRefreshTimer invalidate];
    [self clearLevelAtTheEnd];    
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert removeTopCircle];
    [alert setButtonsTextFontFamily:@"MuseoSansCyrl" withSize:16];
    [alert setTitleFontFamily:@"MuseoSansCyrl-Bold" withSize:40];
    [alert setBodyTextFontFamily:@"MuseoSansCyrl" withSize:16];
    [alert addButton:NSLocalizedString(@"Main menu", nil) target:self selector:@selector(returnToMainMenu:)];
    
    [alert showCustom:nil color:FB_MENU_BUTTON_COLOR
                title:NSLocalizedString(@"Game end", nil)
             subTitle:[NSString stringWithFormat:@"%ld", (long)self.levelScoreLabelNode.totalScore]
     closeButtonTitle:nil
             duration:0.0f];
}

//--------------------------------------------------------------
-(void)restartLevelRefreshingTimerWithNewTotalTime:(NSUInteger)totalTime{
    _totalTime = totalTime;
    [self.levelRefreshTimer invalidate];
    self.levelRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                              target:self
                                                            selector:@selector(countdown)
                                                            userInfo:nil
                                                             repeats:YES];
    [self.levelTimeLabelNode setLabelTextWithSeconds:_totalTime];
}
//--------------------------------------------------------------
- (void)updateTotalTimeWithTemporaryTime:(NSUInteger)temporaryTime
{
    _totalTime += temporaryTime;
    
}


//--------------------------------------------------------Timer------------------------------------------------
//-------------------------------------------------------------------------------------------------------------

-(NSMutableArray *)getAllBoxesNodesInScene
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (SKShapeNode  *node in self.children)
    {
            if (
                [node.name isEqualToString:kFbFoodSquareNodeName] ||
                [node.name isEqualToString:kFbEnemySquareNodeName] ||
                [node.name isEqualToString:kFbGrayBoxStopwatchNodeName] ||
                [node.name isEqualToString:kFBBonusFourName] ||
                [node.name isEqualToString:kFBBonusSecondName] ||
                [node.name isEqualToString:kFBBonusThreeName] ||
                [node.name isEqualToString:kFBBonusFiveName]
                )

            {
                [result addObject:node];
            }
    }
    return result;
}

//-----------------------------------------------------------------------
#pragma - mark FbSnakeDelegate

- (void)didSnake:(FbSnake *)snake createdAreaWithLinesPoints:(NSArray *)points andNode:(SKShapeNode *)node{
    
    NSMutableArray *boxesPositions = [self getAllBoxesNodesInScene];
    for (NSUInteger posIx = 0; posIx < boxesPositions.count; posIx++){
         SKShapeNode *boxNode = [boxesPositions objectAtIndex:posIx];
        
        if ([node containsPoint:boxNode.position]){
            
#if __ORIGINAL_SOLUTION_LOSSO_BOXES
            if(boxNode.physicsBody.categoryBitMask & kFBEnemyFoodCategory)
            {
#if __FB_INCLUDE_PRIVATE_RESOURCES
                [self playSoundEffectName:@"Add_Points.wav"];
#endif
                [self.levelScoreLabelNode temporaryScore:5*_bonus aboutSnake:boxNode];
                [boxNode removeFromParent];
            }
            
#else
            if ([boxNode.name isEqualToString:kFbFoodSquareNodeName])
            {
                [self.levelScoreLabelNode temporaryScore:10 aboutSnake:self.playerSnake.headSnake];
                [boxNode removeFromParent];
            }
            
            else if ([boxNode.name isEqualToString:kFbGrayBoxStopwatchNodeName]){
                [self.levelTimeLabelNode setLabelTextWithSeconds:10];
                [boxNode removeFromParent];
            }
#endif
        }
    }
    
    
}

- (void) reportHighScore:(NSInteger) highScore forLeaderboardId:(NSString*) leaderboardId
{
    if ([GKLocalPlayer localPlayer].isAuthenticated) {
        GKScore* score = [[GKScore alloc] initWithLeaderboardIdentifier:leaderboardId];
        score.value = highScore;
        [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"error: %@", error);
            }
            
        }];
    }
}

-(void)returnToMainMenu:(id)sender
{
    NSLog(@"Game Scene: return to main menu pressed");
    [self.sceneController didReturnToMainmenuPressed];
}

-(void)playSoundEffectName:(NSString * )soundEffect
{
    if (MUTE == NO)
    {
        SKAction * SoundEffect  = [SKAction playSoundFileNamed:soundEffect waitForCompletion:NO];
        [self runAction:SoundEffect];
    }
}

@end
