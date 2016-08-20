//
//  FBCheckInternet.h
//  Fast Blob
//
//  Created by Igor on 09/10/15.
//  Copyright © 2015 Speed Run. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FBCheckInternet : NSObject

+ (BOOL)isInternetConnectionToiAdsAvailable;
+ (BOOL)isInternetConnectionToGoogleAdMobAvailable;

@end
