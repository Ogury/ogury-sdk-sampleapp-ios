//
//  AppDelegate.m
//  InterstitialExample
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

#import "AppDelegate.h"
#import <OguryChoiceManager/OguryChoiceManager.h>
#import <MoPub/MoPub.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [OguryChoiceManager.sharedManager setupWithAssetKey:@"OGY-5575CC173955"];
    
    MPMoPubConfiguration * sdkConfig = [[MPMoPubConfiguration alloc]initWithAdUnitIdForAppInitialization:@"de5cb2a3b2bc4d5cb6c97a89be556a6f"];
    sdkConfig.loggingLevel = MPBLogLevelDebug;
    [[MoPub sharedInstance]initializeSdkWithConfiguration:sdkConfig completion:^{
        NSLog(@"MoPub initialized");
    }];
    return YES;
}

@end
