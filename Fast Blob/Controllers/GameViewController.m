//
//  GameViewController.m
//  Fast Blob
//
//  Created by Igor on 29.06.15.
//  Copyright (c) 2015 Speed Run. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import <GameKit/GameKit.h>


@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@interface GameViewController () <FbGameSceneDelegate>

@property (nonatomic, strong) GameScene *gameScene;

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SKView * skView = (SKView *)self.view;
    
    if (!skView.scene){
        self.gameScene = [[GameScene alloc] initWithSize:self.view.frame.size];
        self.gameScene.sceneController = self;
        SKTransition * doors = [SKTransition crossFadeWithDuration:0.5];
        [skView presentScene:self.gameScene transition:doors];
        skView.showsFPS = NO;
        skView.showsDrawCount = NO;
    }
}

- (void)didReceiveMemoryWarning{
    // http://stackoverflow.com/a/15200855/483101
    // http://battleofbrothers.com/sirryan/memory-usage-in-sprite-kit
    [super didReceiveMemoryWarning];
    
    NSLog(@"Game Controller: didReceiveMemoryWarning");
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskLandscape;
    }
    else{
        return UIInterfaceOrientationMaskLandscape;
    }
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)didReturnToMainmenuPressed{
    SKView * skView = (SKView *)self.view;
    [skView presentScene:nil];
    [self.gameScene removeFromParent];
    
    if (self.presentingViewController.presentingViewController){
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    }
    else{
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

@end
