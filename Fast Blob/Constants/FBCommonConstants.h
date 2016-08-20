//
//  FBCommonConstants.h
//  Fast Blob
//
//  Created by Andrey Ermoshin on 09.07.15.
//  Copyright (c) 2015 Speed Run. All rights reserved.
//

#import <Foundation/Foundation.h>

static const uint32_t kFBLineCategory  = 0x1 << 0;
static const uint32_t kFBHeadCategory =  0x1 << 1;
static const uint32_t kFBLedgeCategory = 0x1 << 2;
static const uint32_t kFBFoodCategory = 0x1 << 3;
static const uint32_t kFBEnemyFoodCategory = 0x1 << 4;
static const uint32_t kFBStopwatch = 0x1 << 5;
static const uint32_t kFBBonusCategory = 0x1 << 6;
static const uint32_t kFBSnakePartCategory = 0x1 << 7;


static const float kSpeedMove = 0.1;
static const NSUInteger kFbFirstLevelTime = 40;
static const float kFBRadius = 15;
static const NSUInteger kFbTimeBonus = 10;

#define FB_SNAKE_HEAD_COLOR [SKColor whiteColor]
#define FB_SNAKE_HEAD_BORDER_COLOR [SKColor whiteColor]
#define FB_CONTROLLED_AREA_CLR [SKColor colorWithWhite:1 alpha:0.6]
#define FB_CONTROLLED_AREA_BORDER_CLR [SKColor colorWithWhite:1 alpha:1]

#define FB_GAME_LEVEL_1_BACK_COLOR [SKColor colorWithRed:124/255.0 green:124/255.0 blue:124/255.0 alpha:1]
#define FB_TIME_RESOURCE_COLOR [SKColor colorWithRed:232/255.0 green:186/255.0 blue:46/255.0 alpha:1]
#define FB_TIME_RESOURCE_TEXT_COLOR FB_TIME_RESOURCE_COLOR
#define FB_BONUS_COLOR [SKColor colorWithRed:255/255.0 green:224/255.0 blue:73/255.0 alpha:1]
#define FB_BONUS_BORDER_COLOR [SKColor colorWithRed:255/255.0 green:123/255.0 blue:17/255.0 alpha:1]
#define FB_BONUS_TEXT_COLOR [SKColor colorWithRed:31/255.0 green:31/255.0 blue:31/255.0 alpha:1]
#define FB_ENEMY_COLOR [SKColor colorWithRed:255/255.0 green:111/255.0 blue:105/255.0 alpha:1]
#define FB_ENEMY_BORDER_COLOR [SKColor colorWithRed:255/255.0 green:25/255.0 blue:0/255.0 alpha:1]
#define FB_FRIENDLY_COLOR [SKColor colorWithRed:63/255.0 green:232/255.0 blue:115/255.0 alpha:1]
#define FB_FRIENDLY_BORDER_COLOR [SKColor colorWithRed:53/255.0 green:138/255.0 blue:51/255.0 alpha:1]

#define FB_MENU_BUTTON_COLOR [SKColor colorWithRed:1 green:0 blue:128/255.0f alpha:1]
#define FB_GAME_TIME_COLOR [SKColor colorWithRed:232/255.0 green:186/255.0 blue:46/255.0 alpha:1]
#define FB_GAME_SCORE_COLOR FB_ENEMY_COLOR
#define FB_GAME_POSITIVE_SCORE_COLOR FB_FRIENDLY_COLOR

#define kFbTimerTopShift 50.0
#define kFbScoreTopShift 50

#define FB_GAME_TIME_FONTNAME @"Futura-CondensedExtraBold"
#define FB_GAME_SCORE_FONTNAME @"Futura-CondensedExtraBold"
#define FB_BONUS_FONTNAME @"Futura-CondensedExtraBold"
#define FB_TIME_RESOURCE_FONTNAME @"Futura-CondensedExtraBold"

extern NSString * const kFbLevelTimeLableNodeName;
extern NSString * const kFbGrayBoxStopwatchNodeName;
extern NSString * const kFbEnemySquareNodeName;
extern NSString * const kFbFoodSquareNodeName;
extern NSString * const kFBBonusSecondName;
extern NSString * const kFBBonusThreeName;
extern NSString * const kFBBonusFourName;
extern NSString * const kFBBonusFiveName;
extern NSString * const kLSIDLeaderBoards;
extern NSString * const kFbGameCenterTitle;
extern NSString * const kFbGameCenterLoggedIn;

#define kSSEmittersShift 15.0f // head has 15 radius it is 30 diameter and emitters have
#define kFbRealMoveDistance 50.0

#define kFBHeadRadius 15
#define kFBSnakePartRadius 5
#define kMFNumberOfSnakeNodesiPad 60.0
#define kMFNumberOfSnakeNodesiPhone 26.0
#define kFbPlayerRadius 20
#define kMFMaximumLevelNum 3
#define kFbParticleStartBirthRate 20.0
#define kFbSquaresScaleTime 3.0
#define kFbEnemySquareWaitTime 30.0
#define kFbFriendlySquareWaitTime 3.0

#define kFbMainNodeZPos -2.0
#define kFbBackgroundNodesZPos -1.0
#define kFbGameObjectsZPos 0.0
#define kFbSnakeEmittersZPos -0.8
#define kFbInterfaceZPos 1.0

#define __FB_COLLISION_SNAKE_LINES_VISIBLE 0
#define __FB_MOVE_SNAKE 0
#define __FB_DRAW_CONTACT_POINT_DEBUG 0
#define __FB_STAY_ON_CURRENT_LEVEL_FOREVER 0

#define __FB_MAKE_GATE_MOVABLE 1
#define __FB_SKIP_FULLSCREEN_AD 1
#define __FB_CREATE_BONUSES_MORE_FREQ 0
#define __FB_DIAGONAL_BACKGROUND 0
#define __FB_REPLACE_BACK_NODES_WITH_ONE_TEXTURE 0

#define __FB_INCLUDE_PRIVATE_RESOURCES 0

#define __FB_FLURRY_SESSION_ID @""

// WARNING: Be sure to use the test ad unit ID provided below or designate a test
// device when first integrating your app with AdMob. Testing on live ads may result
// in a policy violation leading to a suspension of your account.
#define __FB_ADMOB_DEBUG_ID 1


#if __FB_ADMOB_DEBUG_ID
// debug id
#define kFbAdMobInterstitialId     @"ca-app-pub-3940256099942544/4411468910"
#else
// real id
#define kFbAdMobInterstitialId     @"ca-app-pub-"
#endif

typedef void (^GameCenterAuthCompleteCallback) (id rc);
