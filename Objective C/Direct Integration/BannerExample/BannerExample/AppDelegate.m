//
//  AppDelegate.m
//  BannerExample
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

#import "AppDelegate.h"
#import <OguryChoiceManager/OguryChoiceManager.h>
#import <OguryAds/OguryAds.h>

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [OguryChoiceManager.sharedManager setupWithAssetKey:@"OGY-5575CC173955"];
    [OguryAds.shared setupWithAssetKey:@"OGY-5575CC173955"];
    return YES;
}


@end
