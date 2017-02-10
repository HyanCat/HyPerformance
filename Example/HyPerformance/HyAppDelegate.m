//
//  HyAppDelegate.m
//  HyPerformance
//
//  Created by HyanCat on 02/10/2017.
//  Copyright (c) 2017 HyanCat. All rights reserved.
//

#import "HyAppDelegate.h"
#import <HyPerformance/HyPerformanceView.h>

@implementation HyAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    [HyPerformanceView show];
    return YES;
}

@end
