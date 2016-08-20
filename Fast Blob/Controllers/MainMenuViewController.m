//
//  MainMenuViewController.m
//  Fast Blob
//
//  Created by Igor on 29/09/15.
//  Copyright © 2015 Speed Run. All rights reserved.
//

#import "MainMenuViewController.h"
#import "FbAdMobViewController.h"
#import "GameViewController.h"
#import "FBCheckInternet.h"
#import <iAd/iAd.h>
#import <GameKit/GameKit.h>
#import "SCLAlertView.h"
#import <FlatUIKit.h>
#import "UIPopoverController+FlatUI.h"
#import "FbAboutPopoverViewController.h"
@import GoogleMobileAds;

@interface MainMenuViewController() <GKGameCenterControllerDelegate, UIPopoverControllerDelegate, GADInterstitialDelegate>

@property (nonatomic, strong) UIView *splashAfterIntro;
@property (nonatomic, strong) GADInterstitial *interstitial;
@property (nonatomic, readwrite) BOOL needToShowAd;

@end

@implementation MainMenuViewController
@synthesize btnMute, mute =_mute;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Menu Ctrl: Google Mobile Ads SDK version: %@", [GADRequest sdkVersion]);
    
    [self.playBtn setTitle:NSLocalizedString(@"btn_ttl_play", nil) forState:UIControlStateNormal];
    self.playBtn.buttonColor = [UIColor turquoiseColor];
    self.playBtn.shadowColor = [UIColor greenSeaColor];
    self.playBtn.shadowHeight = 3.0f;
    self.playBtn.cornerRadius = 6.0f;
    self.playBtn.titleLabel.font = [UIFont boldFlatFontOfSize:30];
    [self.playBtn setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.playBtn setTitleColor:[UIColor nephritisColor] forState:UIControlStateHighlighted];
    
    [self.leaderboardBtn setTitle:NSLocalizedString(@"btn_ttl_leaderboard", nil) forState:UIControlStateNormal];
    self.leaderboardBtn.buttonColor = [UIColor tangerineColor];
    self.leaderboardBtn.shadowColor = [UIColor wetAsphaltColor];
    self.leaderboardBtn.shadowHeight = 3.0f;
    self.leaderboardBtn.cornerRadius = 6.0f;
    self.leaderboardBtn.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.leaderboardBtn setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.leaderboardBtn setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    self.aboutBtn.buttonColor = [UIColor turquoiseColor];
    self.aboutBtn.shadowColor = [UIColor greenSeaColor];
    self.aboutBtn.shadowHeight = 3.0f;
    self.aboutBtn.cornerRadius = 6.0f;
    self.aboutBtn.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.aboutBtn setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.aboutBtn setTitleColor:[UIColor nephritisColor] forState:UIControlStateHighlighted];
    
    _mute = [[NSUserDefaults standardUserDefaults] boolForKey:@"Mute"];
    
    if(_mute == NO){
        [btnMute setImage:[UIImage imageNamed:@"mute"] forState:UIControlStateNormal];
    }
    else{
        [btnMute setImage:[UIImage imageNamed:@"unmute"] forState:UIControlStateNormal];
    }
    
    self.splashAfterIntro = [[UIView alloc] initWithFrame:self.view.frame];
    self.splashAfterIntro.backgroundColor = [UIColor colorWithWhite:211/255.0 alpha:1.0];
    [self.view addSubview:self.splashAfterIntro];
    [self.view bringSubviewToFront:self.splashAfterIntro];
    self.needToShowAd = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:1 animations:^{
        self.splashAfterIntro.alpha = 0;
    } completion:^(BOOL finished){
        if (finished){
            [self.splashAfterIntro removeFromSuperview];
            if (self.needToShowAd){
                self.interstitial = [self createAndLoadInterstitial];
            }
        }
    }];
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        return UIInterfaceOrientationMaskPortrait;
    }
    else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        return UIInterfaceOrientationMaskLandscape;
    }
    else{
        return UIInterfaceOrientationMaskAll;
    }
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (IBAction)play:(id)sender
{
    GameCenterAuthCompleteCallback authBeforePlay = ^(id result){
        if (result != nil){
            BOOL internetConnectionAvailableForAd = [FBCheckInternet isInternetConnectionToGoogleAdMobAvailable];
#if __FB_SKIP_FULLSCREEN_AD
            internetConnectionAvailableForAd = NO;
#endif
            
            self.needToShowAd = YES;
            if(internetConnectionAvailableForAd)
            {
                FbAdMobViewController * adMobCtrl = [self.storyboard instantiateViewControllerWithIdentifier:@"kFbAdMobViewController"];
                [self presentViewController:adMobCtrl animated:NO completion:nil];
            }
            else
            {
                GameViewController *gameViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"kFbMainGameSceneController"];
                [self presentViewController:gameViewController animated:NO
                                 completion:Nil];
            }
        }
    };
    
    authBeforePlay([NSNumber numberWithBool:YES]);
}

- (IBAction)showLeaderboards:(id)sender {
    
    GameCenterAuthCompleteCallback authBeforeLeaderboard = ^(id result){
        if (result != nil){
            GKGameCenterViewController *leaderboardController = [[GKGameCenterViewController alloc] init];
            
            if (leaderboardController != nil){
                leaderboardController.viewState = GKGameCenterViewControllerStateLeaderboards;
                leaderboardController.gameCenterDelegate = self;
                
                [self presentViewController: leaderboardController animated: YES completion:nil];
            }
        }
    };
    
    if ([GKLocalPlayer localPlayer].authenticated == YES){
        authBeforeLeaderboard([NSNumber numberWithBool:YES]);
    }
}

- (IBAction)mute:(id)sender
{
    _mute  = !_mute;
    if (_mute == YES)
    {
        [btnMute setImage:[UIImage imageNamed:@"unmute"] forState:UIControlStateNormal];
    }
    else
    {
        [btnMute setImage:[UIImage imageNamed:@"mute"] forState:UIControlStateNormal];
    }
    [[NSUserDefaults standardUserDefaults] setBool:self.mute forKey:@"Mute"];
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController*)gameCenterViewController{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)questionPressed:(id)sender{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        FbAboutPopoverViewController *aboutCtrl = [self.storyboard instantiateViewControllerWithIdentifier:@"kFbAboutViewCtrlId"];
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:aboutCtrl];
        [popover configureFlatPopoverWithBackgroundColor:[UIColor midnightBlueColor] cornerRadius:3];
        popover.delegate = self;
        [popover presentPopoverFromRect:self.aboutBtn.frame
                                 inView:self.view
               permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        UINavigationController *navCtrl = [self.storyboard instantiateViewControllerWithIdentifier:@"kFbPopUpNavigationCtrlId"];
        FbAboutPopoverViewController *aboutCtrl = [self.storyboard instantiateViewControllerWithIdentifier:@"kFbAboutViewCtrlId"];
        [navCtrl setViewControllers:@[aboutCtrl]];
        [self presentViewController:navCtrl animated:YES completion:nil];
    }
    else{
        NSLog(@"Menu Ctrl: unsupported platform");
    }
}

- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:kFbAdMobInterstitialId];
    interstitial.delegate = self;
    [interstitial loadRequest:[GADRequest request]];
    return interstitial;
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    [self.interstitial presentFromRootViewController:self];
    self.needToShowAd = NO;
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"Menu Ctrl: failed to load admob %@", [error description]);
}

@end
