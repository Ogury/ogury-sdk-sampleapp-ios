//
//  OguryRewardedVideoCustomEvents.m
//
//  Copyright © 2019 Ogury Co. All rights reserved.
//

#import "OguryRewardedVideoCustomEvents.h"
#import <OguryAds/OguryAds.h>
#import "OguryCustomEventsShared.h"

@interface OguryRewardedVideoCustomEvents()<GADMediationRewardedAd, OguryAdsOptinVideoDelegate> {
    OguryAdsOptinVideo *_optinVideo;
}
@property(nonatomic, weak, nullable) id<GADMediationRewardedAdEventDelegate> delegate;
@property(nonatomic, strong) GADMediationRewardedLoadCompletionHandler loadedCompletionHandler;

@end

@implementation OguryRewardedVideoCustomEvents

+ (GADVersionNumber)adSDKVersion {
     NSString *versionString = [[OguryAds shared] sdkVersion];
     NSArray *versionComponents = [versionString componentsSeparatedByString:@"."];
     GADVersionNumber version = {0};
     if (versionComponents.count == 3) {
       version.majorVersion = [versionComponents[0] integerValue];
       version.minorVersion = [versionComponents[1] integerValue];
       version.patchVersion = [versionComponents[2] integerValue];
     }
     return version;
}

+ (nullable Class<GADAdNetworkExtras>)networkExtrasClass {
    return Nil;
}

+ (GADVersionNumber)version {
    NSString *versionString = @"1.0.0.0";
    NSArray *versionComponents = [versionString componentsSeparatedByString:@"."];
    GADVersionNumber version = {0};
    if (versionComponents.count == 4) {
      version.majorVersion = [versionComponents[0] integerValue];
      version.minorVersion = [versionComponents[1] integerValue];
      version.patchVersion = [versionComponents[2] integerValue] * 100
        + [versionComponents[3] integerValue];
    }
    return version;
}

+ (void)setUpWithConfiguration:(GADMediationServerConfiguration *)configuration completionHandler:(GADMediationAdapterSetUpCompletionBlock)completionHandler {
    completionHandler(nil);
}

- (void)loadRewardedAdForAdConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration completionHandler:(GADMediationRewardedLoadCompletionHandler)completionHandler {
    NSString *serverParameter = adConfiguration.credentials.settings[@"parameter"];
    self.loadedCompletionHandler = completionHandler;
    NSError *error = nil;
    [OguryCustomEventsShared defineMediation];
    NSDictionary *dict = [OguryCustomEventsShared getDictionaryFromJSONString:serverParameter error:&error];
    if (error) {
        self.loadedCompletionHandler(nil,error);
        return;
    }
    
    NSString *assetKey = dict[OGURY_ASSET_KEY_STRING_FOR_ADMOB];
    NSString *adUnitID = dict[OGURY_AD_UNIT_ID_STRING_FOR_ADMOB];
    if (assetKey != nil) {
        [[OguryAds shared] setupWithAssetKey:assetKey];
    }
    _optinVideo = [[OguryAdsOptinVideo alloc] initWithAdUnitID:adUnitID];
    _optinVideo.optInVideoDelegate = self;
    [_optinVideo load];
}

- (void)presentFromViewController:(nonnull UIViewController *)viewController {
    if (_optinVideo.isLoaded) {
        [_optinVideo showAdInViewController:viewController];
    } else {
        NSError *error =
          [NSError errorWithDomain:@"OguryNetwork"
                              code:0
                          userInfo:@{NSLocalizedDescriptionKey : @"Unable to display ad."}];
        [self.delegate didFailToPresentWithError:error];
    }
}

#pragma mark - Ogury Optin Delegate

- (void)oguryAdsOptinVideoAdAvailable {
}

- (void)oguryAdsOptinVideoAdClosed {
    [self.delegate didEndVideo];
    [self.delegate willDismissFullScreenView];
    [self.delegate didDismissFullScreenView];
}

- (void)oguryAdsOptinVideoAdDisplayed {
    [self.delegate willPresentFullScreenView];
    [self.delegate reportImpression];
    [self.delegate didStartVideo];
}

- (void)oguryAdsOptinVideoAdError:(OguryAdsErrorType)errorType {
    NSError *error =
      [NSError errorWithDomain:@"OguryNetwork"
                          code:errorType
                      userInfo:@{NSLocalizedDescriptionKey : @"Ogury Network error , Check Code."}];
    [self.delegate didFailToPresentWithError:error];
}

- (void)oguryAdsOptinVideoAdLoaded {
    self.delegate = self.loadedCompletionHandler(self,nil);
}

- (void)oguryAdsOptinVideoAdNotAvailable {
    NSError *error =
    [NSError errorWithDomain:@"OguryNetwork"
                        code:0
                    userInfo:@{NSLocalizedDescriptionKey : @"Ad Not Available"}];
    self.loadedCompletionHandler(nil,error);
}

- (void)oguryAdsOptinVideoAdNotLoaded {
    NSError *error =
    [NSError errorWithDomain:@"OguryNetwork"
                        code:0
                    userInfo:@{NSLocalizedDescriptionKey : @"Ad Not Loaded"}];
    self.loadedCompletionHandler(nil,error);
}

- (void)oguryAdsOptinVideoAdRewarded:(OGARewardItem *)item {
    NSNumber *amount =  [NSDecimalNumber numberWithInteger:item.rewardValue.integerValue];
    NSDecimalNumber *decAmm = [NSDecimalNumber decimalNumberWithDecimal:[amount decimalValue]];

    GADAdReward *rewardItem =
        [[GADAdReward alloc] initWithRewardType:item.rewardName
                                   rewardAmount:decAmm];
    [self.delegate didRewardUserWithReward:rewardItem];
}

- (void)oguryAdsOptinVideoAdClicked {
    [self.delegate reportClick];
}

@end
