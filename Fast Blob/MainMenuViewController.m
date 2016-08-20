//
//  MainMenuViewController.m
//  Fast Blob
//
//  Created by Igor on 29/09/15.
//  Copyright © 2015 Speed Run. All rights reserved.
//

#import "MainMenuViewController.h"
#import "iADViewController.h"
@interface MainMenuViewController()

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
        GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
        localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
            if (viewController != nil) {
                
                [self presentViewController:viewController animated:YES completion:nil];
            }
            else{
                if ([GKLocalPlayer localPlayer].authenticated) {
                    // _gameCenterEnabled = YES;
                    
                    // Get the default leaderboard identifier.
                    [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                        
                        if (error != nil) {
                            NSLog(@"%@", [error localizedDescription]);
                        }
//                        else{
//                             _leaderboardIdentifier = leaderboardIdentifier;
//                        }
                    }];
                }
                
                else{
                    //_gameCenterEnabled = NO;
                }
            }
        };
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskLandscape;
    } else {
        return UIInterfaceOrientationMaskLandscape;
    }
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (IBAction)play:(id)sender {
   
    iADViewController *ad  = [[iADViewController alloc]init];
    [self presentViewController:ad animated:YES completion:nil];
    [ad showFullScreenAd];
    
}


- (IBAction)showLeaderboards:(id)sender {
    
    
    GKGameCenterViewController *leaderboardController = [[GKGameCenterViewController alloc] init];
    
    if (leaderboardController != nil)
    {
        leaderboardController.viewState = GKGameCenterViewControllerStateLeaderboards;
        leaderboardController.gameCenterDelegate = self;
        
        [self presentViewController: leaderboardController animated: YES completion:nil];
    }
    
}
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
//    _adBanner = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 50)];
//    _adBanner.delegate = self;
//}
//- (void)bannerViewDidLoadAd:(ADBannerView *)banner
//{
//    if (!_bannerIsVisible)
//    {
//        // If banner isn't part of view hierarchy, add it
//        if (_adBanner.superview == nil)
//        {
//            [self.view addSubview:_adBanner];
//        }
//        
//        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
//        
//        // Assumes the banner view is just off the bottom of the screen.
//        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
//        
//        [UIView commitAnimations];
//        
//        _bannerIsVisible = YES;
//    }
//}
//
//- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
//{
//    NSLog(@"Failed to retrieve ad");
//    
//    if (_bannerIsVisible)
//    {
//        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
//        
//        // Assumes the banner view is placed at the bottom of the screen.
//        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
//        
//        [UIView commitAnimations];
//        
//        _bannerIsVisible = NO;
//    }
//}
//
- (void) gameCenterViewControllerDidFinish:(GKGameCenterViewController*) gameCenterViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
