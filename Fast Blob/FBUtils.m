//
//  FBUtils.m
//  Fast Blob
//
//  Created by Andrey Ermoshin on 09.07.15.
//  Copyright (c) 2015 Speed Run. All rights reserved.
//

#import "FBUtils.h"
#import <UIKit/UIKit.h>

@implementation FBUtils

+ (CGPoint)calculatePanForTranslationPoint:(CGPoint)translation
                                   onFrame:(CGRect)sceneRect
                    andCurrentNodePosition:(CGPoint)position{
    
    CGPoint newPosition = CGPointMake(position.x + translation.x, position.y + translation.y);
    if (newPosition.x < 0){
        newPosition.x = 0;
    }
    else if (newPosition.x > sceneRect.size.width){
        newPosition.x = sceneRect.size.width;
    }
    if (newPosition.y < 0){
        newPosition.y = 0;
    }
    else if (newPosition.y > sceneRect.size.height){
        newPosition.y = sceneRect.size.height;
    }
    return newPosition;
}

+ (CGFloat)calculateAngleWithLineFirstPoint:(CGPoint)p1
                             andSecondPoint:(CGPoint)p2{
    CGFloat deltaY = p2.y - p1.y;
    CGFloat deltaX = p2.x - p1.x;
    
    CGFloat angle = atan2(deltaY, deltaX);
    // Important: The angle that atan2f() gives you is not the inner angle
    // inside the triangle, but the angle that the hypotenuse makes with that 0-degree line
#ifdef __DEBUG_ANGLE_OUTPUT
    CGFloat degrees = [FBUtils convertToDegreesFromRadians:angle];
    NSLog(@"Utils: angle for p1 %@ p2 %@ = %f", NSStringFromCGPoint(p1), NSStringFromCGPoint(p2), degrees);
#endif
    
    // * (p1)
    //  \
    //   \
    //    \
    //     \
    //      \
    //       * (p2) - angle will be with y - 0 line it is 140 degree
    return angle;
}

+ (CGFloat)distanceBetweenPointsFirstPoint:(CGPoint)firstPoint secondPoint:(CGPoint)secondPoint{
    CGFloat dx = secondPoint.x - firstPoint.x;
    CGFloat dy = secondPoint.y - firstPoint.y;
    return sqrt(dx*dx + dy*dy);
}

+ (CGPoint)calculatePointForLineNearPoint:(CGPoint)first
                           andSecondPoint:(CGPoint)second
                                        distance:(CGFloat)correctDistance{
    // exist two points which can represent a line
    // need to calculate middle point which will be exactly
    // on specific distance with point second,
    // and at the same time on that line
    
    // The 2nd condition is that calculated point
    // will be near first point and not near 2nd
    
    CGFloat distanceTotal = [FBUtils distanceBetweenPointsFirstPoint:first secondPoint:second];
    const CGFloat neededDistance = correctDistance;
    if (distanceTotal == neededDistance){
        return first;
    }
    
    CGPoint result;
    CGFloat angle = [FBUtils calculateAngleWithLineFirstPoint:first andSecondPoint:second];
    result.y = second.y-neededDistance * sin(angle);
    result.x = second.x-neededDistance * cos(angle);
    
    return result;
}

+ (CGPoint)border:(CGRect)sceneRect limitedPoint:(CGPoint)newPosition{
    if (newPosition.x < 0){
        newPosition.x = 0;
    }
    else if (newPosition.x > sceneRect.size.width){
        newPosition.x = sceneRect.size.width;
    }
    if (newPosition.y < 0){
        newPosition.y = 0;
    }
    else if (newPosition.y > sceneRect.size.height){
        newPosition.y = sceneRect.size.height;
    }
    return newPosition;
}

+ (CGFloat)convertToDegreesFromRadians:(CGFloat)radians{
    return radians * (180 / M_PI);
}

+ (BOOL)isLeftWithVectorAPoint:(CGPoint)a
               andVectorBPoint:(CGPoint)b
              andActuallyPoint:(CGPoint)c{
    // Where a = line point 1; b = line point 2; c = point to check against.
    return ((b.x - a.x)*(c.y - a.y) - (b.y - a.y)*(c.x - a.x)) > 0;
}

+ (BOOL)isPoint:(CGPoint)p isInsidePathShape:(NSArray *)path{
    
    for (NSUInteger ix = 0; ix < path.count - 1; ix++){
        NSValue *av = [path objectAtIndex:ix];
        CGPoint a = av.CGPointValue;
        NSValue *bv = [path objectAtIndex:ix + 1];
        CGPoint b = bv.CGPointValue;
        
        if ([FBUtils isLeftWithVectorAPoint:a andVectorBPoint:b andActuallyPoint:p] == YES){
            return NO;
        }
    }
    return YES;
}

@end
