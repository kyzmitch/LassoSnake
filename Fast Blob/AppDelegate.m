//
//  AppDelegate.m
//  Fast Blob
//
//  Created by Igor on 29.06.15.
//  Copyright (c) 2015 Speed Run. All rights reserved.
//

#import "AppDelegate.h"
#import "MainMenuViewController.h"
#import <GameKit/GameKit.h>
#import "Flurry.h"
#import <iRate.h>

@interface AppDelegate () <GKGameCenterControllerDelegate>
{
@private
    __strong MainMenuViewController *_rootCtrl;
}

- (void)authenticateWithCallback:(GameCenterAuthCompleteCallback)callback;
- (void)backgroundHandler:(NSNotification *)notification;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Flurry setCrashReportingEnabled:YES];
    [Flurry setShowErrorInLogEnabled:YES];
    [Flurry setDebugLogEnabled:NO];
    [Flurry startSession:__FB_FLURRY_SESSION_ID];
    
    [iRate sharedInstance].daysUntilPrompt = 1;
    [iRate sharedInstance].usesUntilPrompt = 3;
    // need users only who
    // play our game several times, to filter haters
    [iRate sharedInstance].useUIAlertControllerIfAvailable = YES;
    [iRate sharedInstance].promptAtLaunch = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(backgroundHandler:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [UIBarButtonItem configureFlatButtonsWithColor:[UIColor peterRiverColor]
                                  highlightedColor:[UIColor belizeHoleColor]
                                      cornerRadius:3];
    
    _rootCtrl = (MainMenuViewController *)self.window.rootViewController;
    [self authenticateWithCallback:nil];
    return YES;
}

-(void)authenticateWithCallback:(GameCenterAuthCompleteCallback)callback{
    [GKLocalPlayer localPlayer].authenticateHandler = ^(UIViewController *viewController, NSError *error){
        BOOL loggedInGameCenter = NO;
        NSNumber *callbackRc = nil;
        if (error){
            _rootCtrl.leaderboardBtn.enabled = NO;
        }
        else{
            if (viewController != nil){
                [_rootCtrl presentViewController:viewController animated:YES completion:nil];
            }
            else{
                if ([GKLocalPlayer localPlayer].authenticated){
                    loggedInGameCenter = YES;
                    _rootCtrl.leaderboardBtn.enabled = YES;
                    callbackRc = [NSNumber numberWithBool:YES];
                }
                else{
                    _rootCtrl.leaderboardBtn.enabled = NO;
                }
            }
        }
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:loggedInGameCenter] forKey:kFbGameCenterLoggedIn];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (callback){
            callback(callbackRc);
        }
    };
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController*)gameCenterViewController{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)backgroundHandler:(NSNotification *)notification{
    [GKLocalPlayer localPlayer].authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if ([GKLocalPlayer localPlayer].authenticated){
            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:kFbGameCenterLoggedIn];
        }
        else{
            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:kFbGameCenterLoggedIn];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    };
}

@end
