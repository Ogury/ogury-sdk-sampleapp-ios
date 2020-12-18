//
//  OguryInterstitialCustomEvents.m
//
//  Copyright © 2019 Ogury Co. All rights reserved.
//

#import "OguryInterstitialCustomEvents.h"
#import "OguryCustomEventsShared.h"

@interface OguryInterstitialCustomEvents()

@property (nonatomic,strong) NSError *error;

@end

@implementation OguryInterstitialCustomEvents

@synthesize delegate;

- (instancetype)init {
    id instance = [super init];
    if (instance) {
        self.error = [NSError errorWithDomain:NSStringFromClass(self.class) code:kGADErrorNoFill userInfo:nil];
    }
    return instance;
}

- (void)presentFromRootViewController:(nonnull UIViewController *)rootViewController {
    if (self.interstitial.isLoaded) {
        [self.interstitial showAdInViewController:rootViewController];
    }
}

- (void)requestInterstitialAdWithParameter:(nullable NSString *)serverParameter label:(nullable NSString *)serverLabel request:(nonnull GADCustomEventRequest *)request {
    NSError *jsonError = nil;
    [OguryCustomEventsShared defineMediation];
    NSDictionary *dict = [OguryCustomEventsShared getDictionaryFromJSONString:serverParameter error:&jsonError];
    if (jsonError) {
        [delegate customEventInterstitial:self didFailAd:jsonError];
        return;
    }
    NSString *assetKey = dict[OGURY_ASSET_KEY_STRING_FOR_ADMOB];
    NSString *adUnitID = dict[OGURY_AD_UNIT_ID_STRING_FOR_ADMOB];
    if (assetKey != nil) {
        [[OguryAds shared]setupWithAssetKey:assetKey];
    }
    self.interstitial = [[OguryAdsInterstitial alloc] initWithAdUnitID:adUnitID];
    self.interstitial.interstitialDelegate = self;
    [self.interstitial load];
}

- (void)oguryAdsInterstitialAdAvailable {
}

- (void)oguryAdsInterstitialAdClosed {
    [delegate customEventInterstitialDidDismiss:self];
}

- (void)oguryAdsInterstitialAdDisplayed {
    [delegate customEventInterstitialWillPresent:self];
}

- (void)oguryAdsInterstitialAdError:(OguryAdsErrorType)errorType {
    [delegate customEventInterstitial:self didFailAd:self.error];
}

- (void)oguryAdsInterstitialAdLoaded {
    [delegate customEventInterstitialDidReceiveAd:self];
}

- (void)oguryAdsInterstitialAdNotAvailable {
    [delegate customEventInterstitial:self didFailAd:self.error];
}

- (void)oguryAdsInterstitialAdNotLoaded {
    [delegate customEventInterstitial:self didFailAd:self.error];
}

- (void)oguryAdsInterstitialAdClicked {
    [delegate customEventInterstitialWasClicked:self];
}

@end
