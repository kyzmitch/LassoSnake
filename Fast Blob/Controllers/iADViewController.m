//
//  iADViewController.m
//  Fast Blob
//
//  Created by Igor on 08/10/15.
//  Copyright © 2015 Speed Run. All rights reserved.
//

#import "iADViewController.h"
#import <iAd/iAd.h>
#import "Flurry.h"
#import <PQFCustomLoaders/PQFCustomLoaders.h>
#import "GameViewController.h"


@interface iADViewController () <ADInterstitialAdDelegate>
{
@private
    ADInterstitialAd* _interstitial;
    BOOL _requestingAd;
}

@property (nonatomic, strong) PQFBallDrop *adLoaderView;

@end

@implementation iADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.adLoaderView = [PQFBallDrop createModalLoader];
    _requestingAd = NO;
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self showFullScreenAd];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@"iAd: viewWillAppear");
}

//---------------------------------iAd-------------------------------

-(void)showFullScreenAd {
    if (_requestingAd == NO){
        [self.adLoaderView showLoader];
        _interstitial = [[ADInterstitialAd alloc] init];
        _interstitial.delegate = self;
        _requestingAd = YES;
    }
}

-(void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
    _requestingAd = NO;
    _interstitial = nil;
    NSLog(@"iAd: didFailWithError %@", [error description]);
    
    [Flurry logError:@"iAd"
             message:[NSString stringWithFormat:@"interstitialAd %@",
                                     [error description]]
               error:error];
    
    [self.adLoaderView removeLoader];
    _interstitial.delegate = nil;
    
    GameViewController *gameViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"kFbMainGameSceneController"];
    [self presentViewController:gameViewController animated:NO
                     completion:Nil];
}

-(void)interstitialAdDidLoad:(ADInterstitialAd *)interstitialAd {
    NSLog(@"iAd: didLoad");
   if (interstitialAd != nil && interstitialAd.loaded && _requestingAd == YES)
   {
        CGRect interstitialFrame = self.view.bounds;
        interstitialFrame.origin = CGPointMake(0, 0);
       
       [self.adLoaderView removeLoader];
        [_interstitial presentInView:self.view];
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(closeAd:) forControlEvents:UIControlEventTouchDown];
        button.backgroundColor = [UIColor clearColor];
        [button setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        button.frame = CGRectMake(20, 20, 30, 30);
        [self.view addSubview:button];
    }
    else
    {
        NSString *msg = [NSString stringWithFormat:@"interstitialAdDidLoad not loaded: requestingAd %@, loaded %@", _requestingAd ? @"YES" : @"NO", interstitialAd.loaded ? @"YES" : @"NO"];
        [Flurry logError:@"iAd"
                 message:msg
                   error:nil];
         
        [self.adLoaderView removeLoader];
        _interstitial.delegate = nil;
        
        GameViewController *gameViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"kFbMainGameSceneController"];
        [self presentViewController:gameViewController
                           animated:NO
                         completion:nil];
    }
}

-(void)interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd {
    NSLog(@"iAd: didUnload");
    _requestingAd = NO;
}

-(void)interstitialAdActionDidFinish:(ADInterstitialAd *)interstitialAd {
    NSLog(@"iAd: didFinish");
}

-(void)closeAd:(id)sender {
    
    _requestingAd = NO;
    _interstitial.delegate = nil;
    
    GameViewController *gameViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"kFbMainGameSceneController"];
            [self presentViewController:gameViewController
                               animated:NO
                             completion:nil];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

@end
