//
//  FBUtils.h
//  Fast Blob
//
//  Created by Andrey Ermoshin on 09.07.15.
//  Copyright (c) 2015 Speed Run. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface FBUtils : NSObject

+ (CGPoint)calculatePanForTranslationPoint:(CGPoint)translation
                                   onFrame:(CGRect)sceneRect
                    andCurrentNodePosition:(CGPoint)position;

+ (CGPoint)border:(CGRect)sceneRect limitedPoint:(CGPoint)newPosition;

+ (CGFloat)calculateAngleWithLineFirstPoint:(CGPoint)p1
                             andSecondPoint:(CGPoint)p2;

+ (CGFloat)distanceBetweenPointsFirstPoint:(CGPoint)firstPoint
                               secondPoint:(CGPoint)secondPoint;

+ (CGPoint)calculatePointForLineNearPoint:(CGPoint)first
                           andSecondPoint:(CGPoint)second
                                 distance:(CGFloat)correctDistance;

+ (BOOL)isLeftWithVectorAPoint:(CGPoint)a
               andVectorBPoint:(CGPoint)b
              andActuallyPoint:(CGPoint)c;

+ (BOOL)isPoint:(CGPoint)p isInsidePathShape:(NSArray *)path;

@end
