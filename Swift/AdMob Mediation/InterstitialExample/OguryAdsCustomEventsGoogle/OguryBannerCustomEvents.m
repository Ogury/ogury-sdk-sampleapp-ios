//
//  OguryBannerCustomEvents.m
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OguryBannerCustomEvents.h"
#import "OguryCustomEventsShared.h"

@interface OguryBannerCustomEvents()

@property (nonatomic, strong) NSError *error;

@end

@implementation OguryBannerCustomEvents

@synthesize delegate;

- (void)requestBannerAd:(GADAdSize)adSize parameter:(nullable NSString *)serverParameter label:(nullable NSString *)serverLabel request:(nonnull GADCustomEventRequest *)request {
    
    NSError *error = nil;
    [OguryCustomEventsShared defineMediation];
    NSDictionary *dict = [OguryCustomEventsShared getDictionaryFromJSONString:serverParameter error:&error];
    if (error) {
        [self.delegate customEventBanner:self didFailAd:error];
        return;
    }
    NSString *assetKey = dict[OGURY_ASSET_KEY_STRING_FOR_ADMOB];
    NSString *adUnitID = dict[OGURY_AD_UNIT_ID_STRING_FOR_ADMOB];
    if (assetKey != nil) {
        [[OguryAds shared] setupWithAssetKey:assetKey];
    }
    self.banner = [[OguryAdsBanner alloc] initWithAdUnitID:adUnitID];
    OguryAdsBannerSize *sizeOguryBanner = [self getOgurySize:adSize.size];
    if (sizeOguryBanner == NULL) {
        NSError *error = [NSError errorWithDomain:kGADErrorDomain code:kGADErrorMediationInvalidAdSize userInfo:nil];
        [self.delegate customEventBanner:self didFailAd:error];
        return;
    }
    self.banner.frame = CGRectMake(0, 0, adSize.size.width, adSize.size.height);
    self.banner.bannerDelegate = self;
    [self.banner loadWithSize:sizeOguryBanner];
}

- (OguryAdsBannerSize *)getOgurySize:(CGSize)size {
    if ([self size:size canInclude:[[OguryAdsBannerSize small_banner_320x50] getSize]]) {
        return [OguryAdsBannerSize small_banner_320x50];
    }
    if ([self size:size canInclude:[[OguryAdsBannerSize mpu_300x250] getSize]]) {
        return [OguryAdsBannerSize mpu_300x250];
    }
    return NULL;
}

- (BOOL)size:(CGSize)sizeADMobBanner canInclude:(CGSize)sizeOguryBanner {
    if (sizeADMobBanner.height < sizeOguryBanner.height || sizeADMobBanner.width < sizeOguryBanner.width) {
        return NO;
    }
    double maxRatio = 1.5;
    if (sizeADMobBanner.height >= sizeOguryBanner.height * maxRatio || sizeADMobBanner.width >= sizeOguryBanner.width * maxRatio) {
        return NO;
    }
    return YES;
}

- (void)oguryAdsBannerAdAvailable:(OguryAdsBanner *)bannerAds {
}

- (void)oguryAdsBannerAdClicked:(OguryAdsBanner *)bannerAds {
    [self.delegate customEventBannerWasClicked:self];
}

- (void)oguryAdsBannerAdClosed:(OguryAdsBanner *)bannerAds {
}

- (void)oguryAdsBannerAdDisplayed:(OguryAdsBanner *)bannerAds {
}

- (void)oguryAdsBannerAdError:(OguryAdsErrorType)errorType forBanner:(OguryAdsBanner *)bannerAds {
    NSError *error = [NSError errorWithDomain:kGADErrorDomain
                                         code:kGADErrorServerError
                                     userInfo:nil];
    [self.delegate customEventBanner:self didFailAd:error];
}

- (void)oguryAdsBannerAdLoaded:(OguryAdsBanner *)bannerAds {
    [self.delegate customEventBanner:self didReceiveAd:bannerAds];
}

- (void)oguryAdsBannerAdNotAvailable:(OguryAdsBanner *)bannerAds {
    NSError *error = [NSError errorWithDomain:kGADErrorDomain
                                         code:kGADErrorNoFill
                                     userInfo:nil];
    [self.delegate customEventBanner:self didFailAd:error];
}

- (void)oguryAdsBannerAdNotLoaded:(OguryAdsBanner *)bannerAds {
    NSError *error = [NSError errorWithDomain:kGADErrorDomain
                                         code:kGADErrorNoFill
                                     userInfo:nil];
    [self.delegate customEventBanner:self didFailAd:error];
}

@end
