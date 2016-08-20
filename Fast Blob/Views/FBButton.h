//
//  FBButton.h
//  Fast Blob
//
//  Created by Andrey Ermoshin on 02.08.15.
//  Copyright (c) 2015 Speed Run. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKSpriteNode;

@interface FBButton : NSObject

- (id)initWithText:(NSString *)text
          andFrame:(CGRect)frame
      andBackColor:(UIColor *)clr
      andTextColor:(UIColor *)txtClr;

- (SKSpriteNode *)node;
- (void)setPosition:(CGPoint)pos;

@end
