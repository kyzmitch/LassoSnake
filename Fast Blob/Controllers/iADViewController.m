//
//  iADViewController.m
//  Fast Blob
//
//  Created by Igor on 08/10/15.
//  Copyright © 2015 Speed Run. All rights reserved.
//

#import "iADViewController.h"
#import <iAd/iAd.h>
#import "GameViewController.h"


@interface iADViewController ()
{
@private
    BOOL _requestingAd;
}

@end

@implementation iADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
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
        _requestingAd = YES;
    }
}

-(void)closeAd:(id)sender {
    
    _requestingAd = NO;
    
    GameViewController *gameViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"kFbMainGameSceneController"];
            [self presentViewController:gameViewController
                               animated:NO
                             completion:nil];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

@end
