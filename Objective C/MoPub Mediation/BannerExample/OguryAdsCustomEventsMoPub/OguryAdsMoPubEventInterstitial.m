//
//  OguryAdsMoPubEventInterstitial.m
//
//  Copyright © 2019 Ogury Co. All rights reserved.
//

#import "OguryAdsMoPubEventInterstitial.h"
#import <OguryAds/OguryAds.h>

@interface OguryAdsMoPubEventInterstitial()<OguryAdsInterstitialDelegate>

@property (nonatomic,strong) OguryAdsInterstitial *interstitial;

@end

@implementation OguryAdsMoPubEventInterstitial

- (void)dealloc {
    self.interstitial.interstitialDelegate = nil;
}

- (void)requestAdWithAdapterInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup {
    NSString *assetKey = [info objectForKey:@"asset_key"];
    if (!assetKey || [assetKey isEqualToString:@""]) {
        NSError *error = [NSError errorWithCode:MOPUBErrorSDKNotInitialized];
        [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:error];
        return;
    }
    [[OguryAds shared]setupWithAssetKey:assetKey andCompletionHandler:^(NSError *error) {
        if (error) {
            NSError *error = [NSError errorWithCode:MOPUBErrorSDKNotInitialized];
            [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:error];
            return;
        }
        [[OguryAds shared] defineMediationName:@"MoPub"];
        NSString *adunitId = [info objectForKey:@"ad_unit_id"];
        self.interstitial = [[OguryAdsInterstitial alloc] initWithAdUnitID:adunitId];
        self.interstitial.interstitialDelegate = self;
        [self.interstitial load];
        
    }];
}

- (BOOL)isRewardExpected {
    return NO;
}

- (BOOL)hasAdAvailable {
    return self.interstitial.isLoaded;
}

- (void)presentAdFromViewController:(UIViewController *)viewController {
    if (self.interstitial.isLoaded) {
        [self.delegate fullscreenAdAdapterAdWillAppear:self];
        [self.interstitial showAdInViewController:viewController];
    }
}

- (BOOL)enableAutomaticImpressionAndClickTracking {
    return NO;
}

# pragma interstitial delegate

- (void)oguryAdsInterstitialAdAvailable {
}

- (void)oguryAdsInterstitialAdClosed {
    [self.delegate fullscreenAdAdapterAdWillDisappear:self];
    [self.delegate fullscreenAdAdapterAdDidDisappear:self];
    [self.delegate fullscreenAdAdapterAdWillDismiss:self];
    [self.delegate fullscreenAdAdapterAdDidDismiss:self];
}

- (void)oguryAdsInterstitialAdDisplayed {
    [self.delegate fullscreenAdAdapterAdDidAppear:self];
    [self.delegate fullscreenAdAdapterDidTrackImpression:self];
}

- (void)oguryAdsInterstitialAdError:(OguryAdsErrorType)errorType {
    NSError *error = [NSError errorWithCode:MOPUBErrorNoInventory];
    [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:error];
}

- (void)oguryAdsInterstitialAdLoaded {
    [self.delegate fullscreenAdAdapterDidLoadAd:self];
}

- (void)oguryAdsInterstitialAdNotAvailable {
    NSError *error = [NSError errorWithCode:MOPUBErrorNoInventory];
    [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:error];
}

- (void)oguryAdsInterstitialAdNotLoaded {
    NSError *error = [NSError errorWithCode:MOPUBErrorNoInventory];
    [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:error];
}

- (void)oguryAdsInterstitialAdClicked {
    [self.delegate fullscreenAdAdapterDidTrackClick:self];
}

@end
