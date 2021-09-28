//
//  AppDelegate.m
//  InterstitialExample
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

#import "AppDelegate.h"
#import <OguryChoiceManager/OguryChoiceManager.h>
#import <MoPubSDK/MoPub.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [OguryChoiceManager.sharedManager setupWithAssetKey:@"asset_key"];

    // Declare your Ogury asset key
    NSMutableDictionary *oguryConfigs = [NSMutableDictionary new];
    [oguryConfigs setObject:@"YOUR_OGURY_ASSET_KEY" forKey:@"asset_key"];

    MPMoPubConfiguration * sdkConfig = [[MPMoPubConfiguration alloc]initWithAdUnitIdForAppInitialization:@"mopub_adunit"];
    sdkConfig.loggingLevel = MPBLogLevelDebug;
    sdkConfig.mediatedNetworkConfigurations = [@{@"OguryAdapterConfiguration":oguryConfigs} mutableCopy];

    [[MoPub sharedInstance]initializeSdkWithConfiguration:sdkConfig completion:^{
        NSLog(@"MoPub initialized");
    }];
    return YES;
}

@end
