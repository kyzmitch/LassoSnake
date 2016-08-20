//
//  FbLevelEndAlertNode.h
//  Fast Blob
//
//  Created by Andrey Ermoshin on 30.07.15.
//  Copyright (c) 2015 Speed Run. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FbLevelEndAlertNode;

@protocol FBLevelAlertDelegate <NSObject>
@required
- (void)didAlertNode:(FbLevelEndAlertNode *)alertNode pressedContinue:(BOOL)nextLevel;
- (void)didAlertNode:(FbLevelEndAlertNode *)alertNode pressedRestart:(BOOL)restart;
- (void)didAlertNode:(FbLevelEndAlertNode *)alertNode pressedToMainMenu:(BOOL)backToMainMenu;

@end

@class SKScene;

@interface FbLevelEndAlertNode : NSObject

- (id)initWithFrame:(CGRect)frame;
- (void)showOnScene:(SKScene *)sceen;
- (void)removeFromScene:(SKScene *)scene;
- (BOOL)mainNodeContainsPoint:(CGPoint)p;
- (void)handleTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

@property (weak, nonatomic) id<FBLevelAlertDelegate> delegate;

@end
