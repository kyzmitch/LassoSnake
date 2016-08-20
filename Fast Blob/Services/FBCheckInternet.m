//
//  FBCheckInternet.m
//  Fast Blob
//
//  Created by Igor on 09/10/15.
//  Copyright © 2015 Speed Run. All rights reserved.
//

#import "FBCheckInternet.h"
#import "Reachability.h"



@implementation FBCheckInternet

+ (BOOL)isInternetConnectionToiAdsAvailable
{
    // http://stackoverflow.com/a/6266311
    Reachability *internet = [Reachability reachabilityWithHostName: @"iadsdk.apple.com"];
    NetworkStatus netStatus = [internet currentReachabilityStatus];
    BOOL netConnection = NO;
    switch (netStatus)
    {
        case NotReachable:
        {
            NSLog(@"Internet access is Not Available");
            break;
        }
        case ReachableViaWWAN:
        {
            netConnection = YES;
            break;
        }
        case ReachableViaWiFi:
        {
            netConnection = YES;
            break;
        }
    }
    return netConnection;
}

+ (BOOL)isInternetConnectionToGoogleAdMobAvailable
{
    Reachability *internet = [Reachability reachabilityWithHostName: @"google.com"];
    NetworkStatus netStatus = [internet currentReachabilityStatus];
    BOOL netConnection = NO;
    switch (netStatus)
    {
        case NotReachable:
        {
            NSLog(@"Internet access is Not Available");
            break;
        }
        case ReachableViaWWAN:
        {
            netConnection = YES;
            break;
        }
        case ReachableViaWiFi:
        {
            netConnection = YES;
            break;
        }
    }
    return netConnection;
}

@end
