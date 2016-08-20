//
//  FbAboutPopoverViewController.m
//  Fast Blob
//
//  Created by Andrey Ermoshin on 05.11.15.
//  Copyright © 2015 Speed Run. All rights reserved.
//

#import "FbAboutPopoverViewController.h"
#import <FlatUIKit.h>

@interface FbAboutPopoverViewController ()

@property (nonatomic, weak) IBOutlet UITextView *textView;

@end

@implementation FbAboutPopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"ttl_about", nil);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                          target:self
                                                                                          action:@selector(backPressed:)];
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor turquoiseColor]];
    [self.navigationItem.leftBarButtonItem configureFlatButtonWithColor:[UIColor whiteColor] highlightedColor:[UIColor turquoiseColor] cornerRadius:3.0];
    
    NSString* acknowledgementsPath = [[NSBundle mainBundle] pathForResource:@"Pods-acknowledgements" ofType:@"markdown"];
    NSString *additionalText = [NSString stringWithContentsOfFile:acknowledgementsPath encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableString *text = [NSMutableString new];
    [text appendString:@"Created by: Igor Nikolaev, Andrey Ermoshin\n\n"];
    NSString *musicLicense = @"Music:\n\"Cool Theme\" \n by Vladimir -Coel- Obuhov \n https://vk.com/wladimir/ \n Sound Effect:\n \"Spell 1\"Author: Bart Kelsey \n \"Spell 4 (fire)\"Author:  Bart Kelsey \n \"Teleport\" Author: fins \n http://freesound.org/people/fins/sounds/172206/ \n\n";
    [text appendString:musicLicense];
    [text appendString:additionalText];
    self.textView.text = text;
    self.textView.textAlignment = NSTextAlignmentCenter;
    self.textView.textColor = [UIColor whiteColor];
    self.textView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
}

- (void)backPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
