//
//  FBButton.m
//  Fast Blob
//
//  Created by Andrey Ermoshin on 02.08.15.
//  Copyright (c) 2015 Speed Run. All rights reserved.
//

#import "FBButton.h"
#import <SpriteKit/SpriteKit.h>

@interface FBButton ()

@property (nonatomic, strong) SKSpriteNode *btn;
@property (nonatomic, strong) SKLabelNode *lbl;

@end

@implementation FBButton

- (id)initWithText:(NSString *)text
          andFrame:(CGRect)frame
      andBackColor:(UIColor *)clr
      andTextColor:(UIColor *)txtClr{
    self = [super init];
    
    self.btn = [SKSpriteNode spriteNodeWithColor:clr size:frame.size];
    self.lbl = [SKLabelNode labelNodeWithText:text];
    self.lbl.fontSize = 18;
    self.lbl.fontColor = txtClr;
    
    CGPoint topP = CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame));
    SKRange *range = [SKRange rangeWithConstantValue:0];
    SKConstraint *topC = [SKConstraint distance:range toPoint:topP];
    CGPoint bottomP = CGPointMake(CGRectGetMidX(frame), 0);
    SKConstraint *bottomC = [SKConstraint distance:range toPoint:bottomP];
    CGPoint leftP = CGPointMake(0, CGRectGetMidY(frame));
    SKConstraint *leftC = [SKConstraint distance:range toPoint:leftP];
    CGPoint rightP = CGPointMake(CGRectGetMaxX(frame), CGRectGetMidY(frame));
    SKConstraint *rightC = [SKConstraint distance:range toPoint:rightP];
    
    [self.lbl setConstraints:[NSArray arrayWithObjects:topC, bottomC, leftC, rightC, nil]];
    [self.btn addChild:self.lbl];
    
    return self;
}

- (SKSpriteNode *)node{
    return self.btn;
}

- (void)setPosition:(CGPoint)pos{
    self.btn.position = pos;
}

@end
