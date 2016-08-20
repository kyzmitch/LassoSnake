//
//  FbSquare.h
//  Fast Blob
//
//  Created by Igor on 14.07.15.
//  Copyright (c) 2015 Speed Run. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface FbSquare : SKShapeNode 
+(FbSquare*)createSquareInSceneTypeSquare:(BOOL)enemy;
-(void)redrawOnScene:(SKScene *)scene withLocation:(CGPoint)location;
@end
