//
//  AppDelegate.m
//  OptInVideoExample
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

#import "AppDelegate.h"
#import <OguryChoiceManager/OguryChoiceManager.h>
#import <MoPubSDK/MoPub.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [OguryChoiceManager.sharedManager setupWithAssetKey:@"OGY-5575CC173955"];

    // Declare your Ogury asset key
    NSMutableDictionary *oguryConfigs = [NSMutableDictionary new];
    [oguryConfigs setObject:@"YOUR_OGURY_ASSET_KEY" forKey:@"OGY-5575CC173955"];

    MPMoPubConfiguration * sdkConfig = [[MPMoPubConfiguration alloc]initWithAdUnitIdForAppInitialization:@"ebfc19b6252649ef9f77520a5ac85531"];
    sdkConfig.loggingLevel = MPBLogLevelDebug;
    sdkConfig.mediatedNetworkConfigurations = [@{@"OguryAdapterConfiguration":oguryConfigs} mutableCopy];

    [[MoPub sharedInstance]initializeSdkWithConfiguration:sdkConfig completion:^{
        NSLog(@"MoPub initialized");
    }];
    return YES;
}

@end
