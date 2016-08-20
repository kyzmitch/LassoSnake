//
//  Timer.m
//  Fast Blob
//
//  Created by Igor on 13.07.15.
//  Copyright (c) 2015 Speed Run. All rights reserved.
//

#import "Timer.h"

@interface Timer ()

@property (nonatomic, readwrite) CGPoint attachmentPoint;

@end

@implementation Timer

+ (Timer*)createTimerInLocation:(CGPoint)location
{
    return [[Timer alloc]initWithLocation:location];
}

-(instancetype)initWithLocation:(CGPoint)location
{
    self = [Timer labelNodeWithFontNamed:FB_GAME_TIME_FONTNAME];
    if(self)
    {
        self.attachmentPoint = location;
        self.name = kFbLevelTimeLableNodeName;
        self.fontColor = FB_GAME_TIME_COLOR;
        self.zPosition = kFbInterfaceZPos;
    }
    return self;
}
//-------------------------------------------------------------------------

- (void)addToScene:(SKScene *)scene{
    if (scene == nil){
        return;
    }
    [self removeFromParent];
    self.constraints = nil;
    [scene addChild:self];
    
    SKRange *range = [SKRange rangeWithConstantValue:kFbTimerTopShift];
    SKConstraint *distanceConstraint = [SKConstraint distance:range toPoint:self.attachmentPoint];
    self.constraints = [NSArray arrayWithObjects:distanceConstraint, nil];
}

//-------------------------------------------------------------------------
-(NSString* )timeToString:(NSUInteger)totalTime
{
    int seconds = totalTime % 60;
    int minutes = (totalTime / 60) % 60;
    return [NSString stringWithFormat:@"%2d:%02d", minutes, seconds];
}

//-------------------------------------------------------------------------

-(void)setLabelTextWithSeconds:(NSUInteger)totaltime
{
    self.text = [NSString stringWithString:[self timeToString:totaltime]];
}
@end
