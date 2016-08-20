//
//  FbAdMobViewController.m
//  Fast Blob
//
//  Created by Andrey Ermoshin on 15.12.15.
//  Copyright © 2015 Speed Run. All rights reserved.
//

#import "FbAdMobViewController.h"
#import "GameViewController.h"
@import GoogleMobileAds;

@interface FbAdMobViewController ()

@property (nonatomic, weak) IBOutlet GADBannerView *bannerView;

@end

@implementation FbAdMobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"AdMob Ctrl: Google Mobile Ads SDK version: %@", [GADRequest sdkVersion]);
}

- (void)closeButtonPressed:(id)sender{
    GameViewController *gameViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"kFbMainGameSceneController"];
    [self presentViewController:gameViewController
                       animated:NO
                     completion:nil];
}

@end
