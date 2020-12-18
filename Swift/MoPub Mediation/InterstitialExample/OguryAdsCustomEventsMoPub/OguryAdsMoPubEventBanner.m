//
//  OguryAdsMoPubEventBanner.m
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OguryAdsMoPubEventBanner.h"
#import <OguryAds/OguryAds.h>

@interface OguryAdsMoPubEventBanner()<OguryAdsBannerDelegate>

@property (nonatomic,strong) OguryAdsBanner *banner;

@end

@implementation OguryAdsMoPubEventBanner

- (void)dealloc {
    self.banner.bannerDelegate = nil;
}

- (void)requestAdWithSize:(CGSize)size adapterInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup {
    NSString *assetKey = [info objectForKey:@"asset_key"];
    if (assetKey != nil) {
        [[OguryAds shared] setupWithAssetKey:assetKey];
    }
    [[OguryAds shared] defineMediationName:@"MoPub"];
    NSString *adunitId = [info objectForKey:@"ad_unit_id"];
    self.banner = [[OguryAdsBanner alloc]initWithAdUnitID:adunitId];
    OguryAdsBannerSize *sizeOguryBanner = [self getOgurySize:size];
    if (sizeOguryBanner == NULL) {
        NSError *error = [NSError errorWithCode:MOPUBErrorNoInventory];
        [self.delegate inlineAdAdapter:self didFailToLoadAdWithError:error];
        return;
    }
    self.banner.bannerDelegate = self;
    self.banner.frame = CGRectMake(0, 0, size.width, size.height);
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

- (BOOL)enableAutomaticImpressionAndClickTracking {
    return NO;
}

- (BOOL)size:(CGSize)sizeMopubBanner canInclude:(CGSize)sizeOguryBanner {
    if (sizeMopubBanner.height < sizeOguryBanner.height || sizeMopubBanner.width < sizeOguryBanner.width) {
        return NO;
    }
    double maxRatio = 1.5;
    if (sizeMopubBanner.height >= sizeOguryBanner.height * maxRatio || sizeMopubBanner.width >= sizeOguryBanner.width * maxRatio) {
        return NO;
    }
    return YES;
}

# pragma banner delegate

- (void)oguryAdsBannerAdAvailable:(OguryAdsBanner *)bannerAds {
}

- (void)oguryAdsBannerAdClicked:(OguryAdsBanner *)bannerAds {
    [self.delegate inlineAdAdapterWillBeginUserAction:self];
    [self.delegate inlineAdAdapterDidTrackClick:self];
}

- (void)oguryAdsBannerAdClosed:(OguryAdsBanner *)bannerAds {
     [self.delegate inlineAdAdapterDidEndUserAction:self];
}

- (void)oguryAdsBannerAdDisplayed:(OguryAdsBanner *)bannerAds {
     [self.delegate inlineAdAdapterDidTrackImpression:self];
}

- (void)oguryAdsBannerAdError:(OguryAdsErrorType)errorType forBanner:(OguryAdsBanner *)bannerAds {
    NSError *error = [NSError errorWithCode:MOPUBErrorNoInventory];
    [self.delegate inlineAdAdapter:self didFailToLoadAdWithError:error];
}

- (void)oguryAdsBannerAdLoaded:(OguryAdsBanner *)bannerAds {
    [self.delegate inlineAdAdapter:self didLoadAdWithAdView:bannerAds];
}

- (void)oguryAdsBannerAdNotAvailable:(OguryAdsBanner *)bannerAds {
    NSError *error = [NSError errorWithCode:MOPUBErrorNoInventory];
    [self.delegate inlineAdAdapter:self didFailToLoadAdWithError:error];
}

- (void)oguryAdsBannerAdNotLoaded:(OguryAdsBanner *)bannerAds {
    NSError *error = [NSError errorWithCode:MOPUBErrorNoInventory];
    [self.delegate inlineAdAdapter:self didFailToLoadAdWithError:error];
}

- (void)oguryAdsThumbnailAdAdClicked {
    [self.delegate inlineAdAdapterDidTrackClick:self];
}

@end
