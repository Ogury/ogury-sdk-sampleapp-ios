//
//  AppDelegate.m
//  OptInVideoExample
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

#import "AppDelegate.h"
#import <OguryChoiceManager/OguryChoiceManager.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [OguryChoiceManager.sharedManager setupWithAssetKey:@"OGY-5575CC173955"];
    return YES;
}

@end
