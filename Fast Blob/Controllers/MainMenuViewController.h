//
//  MainMenuViewController.h
//  Fast Blob
//
//  Created by Igor on 29/09/15.
//  Copyright © 2015 Speed Run. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FlatUIKit.h>

@interface MainMenuViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btnMute;
@property (weak, nonatomic) IBOutlet FUIButton *playBtn;
@property (weak, nonatomic) IBOutlet FUIButton *leaderboardBtn;
@property (weak, nonatomic) IBOutlet FUIButton *aboutBtn;
@property (nonatomic,assign,readonly) BOOL mute;

- (IBAction)play:(id)sender;
- (IBAction)showLeaderboards:(id)sender;
- (IBAction)mute:(id)sender;
- (IBAction)questionPressed:(id)sender;



@end
