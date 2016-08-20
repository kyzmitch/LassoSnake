//
//  GameScene.h
//  Fast Blob
//

//  Copyright (c) 2015 Speed Run. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "AppDelegate.h"
#import <iAd/iAd.h>

@protocol FbGameSceneDelegate <NSObject>

- (void)didReturnToMainmenuPressed;

@end

@interface GameScene : SKScene

@property (nonatomic, weak) id<FbGameSceneDelegate> sceneController;

@end

