//
//  OguryAdsMoPubEventOptin.m
//
//  Copyright © 2019 Ogury Co. All rights reserved.
//

#import "OguryAdsMoPubEventOptin.h"
#import <OguryAds/OguryAds.h>

@interface OguryAdsMoPubEventOptin()<OguryAdsOptinVideoDelegate>

@property (nonatomic,strong) OguryAdsOptinVideo *optinVideo;

@end

@implementation OguryAdsMoPubEventOptin

- (void)dealloc {
    self.optinVideo.optInVideoDelegate = nil;
}

- (void)requestAdWithAdapterInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup {
    NSString *assetKey = [info objectForKey:@"asset_key"];
    if (assetKey != nil) {
        [[OguryAds shared]setupWithAssetKey:assetKey];
    }
    [[OguryAds shared] defineMediationName:@"MoPub"];
    NSString *adunitId = [info objectForKey:@"ad_unit_id"];
    self.optinVideo = [[OguryAdsOptinVideo alloc] initWithAdUnitID:adunitId];
    self.optinVideo.optInVideoDelegate = self;
    [self.optinVideo load];
}

- (BOOL)isRewardExpected{
    return YES;
}

-(BOOL)hasAdAvailable {
    return self.optinVideo.isLoaded;
}

- (void)presentAdFromViewController:(UIViewController *)viewController {
    if (self.optinVideo.isLoaded) {
        [self.optinVideo showAdInViewController:viewController];
    }
}

- (BOOL)enableAutomaticImpressionAndClickTracking {
    return NO;
}

# pragma optinVideo delegate

- (void)oguryAdsOptinVideoAdAvailable {
}

- (void)oguryAdsOptinVideoAdClosed {
    [self.delegate fullscreenAdAdapterAdWillDisappear:self];
    [self.delegate fullscreenAdAdapterAdDidDisappear:self];
}

- (void)oguryAdsOptinVideoAdDisplayed {
    [self.delegate fullscreenAdAdapterAdDidAppear:self];
    [self.delegate fullscreenAdAdapterDidTrackImpression:self];
}

- (void)oguryAdsOptinVideoAdError:(OguryAdsErrorType)errorType {
    NSError *error = [NSError errorWithCode:MOPUBErrorNoInventory];
    [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:error];
}

- (void)oguryAdsOptinVideoAdLoaded {
    [self.delegate fullscreenAdAdapterDidLoadAd:self];
}

- (void)oguryAdsOptinVideoAdNotAvailable {
    NSError *error = [NSError errorWithCode:MOPUBErrorNoInventory];
    [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:error];
}

- (void)oguryAdsOptinVideoAdNotLoaded {
    NSError *error = [NSError errorWithCode:MOPUBErrorNoInventory];
    [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:error];
}

- (void)oguryAdsOptinVideoAdRewarded:(OGARewardItem *)item {
    NSString * currencyType = kMPRewardCurrencyTypeUnspecified;
    NSInteger amount = kMPRewardCurrencyAmountUnspecified;
    if (item.rewardName != nil && ![item.rewardName isEqualToString:@""] ) {
        currencyType = item.rewardName;
    }
    
    if (item.rewardValue != nil && ![item.rewardValue isEqualToString:@""]) {
        amount = item.rewardValue.integerValue;
    }
    MPRewardedVideoReward *reward = [[MPRewardedVideoReward alloc] initWithCurrencyType:currencyType amount:@(amount)];
    [self.delegate fullscreenAdAdapter:self willRewardUser:reward];
}

- (void)oguryAdsOptinVideoAdClicked {
    [self.delegate fullscreenAdAdapterDidTrackClick:self];
}

@end
