//
//  Timer.h
//  Fast Blob
//
//  Created by Igor on 13.07.15.
//  Copyright (c) 2015 Speed Run. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Timer : SKLabelNode

+ (Timer*)createTimerInLocation:(CGPoint)location;
- (void)addToScene:(SKScene *)scene;
- (void)setLabelTextWithSeconds:(NSUInteger)totaltime;
@end
