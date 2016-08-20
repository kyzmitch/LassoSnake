//
//  FbCustomAlert.h
//  Fast Blob
//
//  Created by Andrey Ermoshin on 31.07.15.
//  Copyright (c) 2015 Speed Run. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKScene;

@interface FbCustomAlert : NSObject

- (id)initWithNames:(NSArray *)buttonNames
             colors:(NSArray *)buttonColors
    backgroundColor:(UIColor *)backColor;
- (void)showOnScene:(SKScene *)sceen;

@end
