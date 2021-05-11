//
//  AppDelegate.m
//  BannerExample
//
//  Copyright © 2021 Ogury Co. All rights reserved.
//

#import "AppDelegate.h"
#import <OguryChoiceManager/OguryChoiceManager.h>
#import <MoPubSDK/MoPub.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [OguryChoiceManager.sharedManager setupWithAssetKey:@"OGY-5575CC173955"];
    
    MPMoPubConfiguration * sdkConfig = [[MPMoPubConfiguration alloc]initWithAdUnitIdForAppInitialization:@"7e2bf143b2c0470fab647c0868571370"];
    sdkConfig.loggingLevel = MPBLogLevelDebug;
    [[MoPub sharedInstance]initializeSdkWithConfiguration:sdkConfig completion:^{
        NSLog(@"MoPub initialized");
    }];
    
    return YES;
}

@end
