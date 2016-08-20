//
//  FbLine.h
//  Fast Blob
//
//  Created by Andrey Ermoshin on 12.07.15.
//  Copyright (c) 2015 Speed Run. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <SpriteKit/SpriteKit.h>

@interface FbLine : NSObject

- (id)initWithP1:(CGPoint)p1 andP2:(CGPoint)p2;

- (id)initLineWithP1:(CGPoint)p1
                   andP2:(CGPoint)p2
               withColor:(UIColor *)color
         categoryBitMask:(uint32_t)category
        contactTestBitMask:(uint32_t)contactTestBitMask;

- (void)addToScene:(SKScene *)scene;
- (BOOL)calculatedWithPoint:(CGPoint)p;
- (void)addToNode:(SKNode *)node;
- (id)initWithP1:(CGPoint)p1 andP2:(CGPoint)p2 withColor:(UIColor *)color;
- (CGPoint)getP1;
- (CGPoint)getP2;
- (BOOL)isItOwnShapeNode:(SKNode *)n;
- (void)lightUpShape;
- (void)removeFromScene;

@end
