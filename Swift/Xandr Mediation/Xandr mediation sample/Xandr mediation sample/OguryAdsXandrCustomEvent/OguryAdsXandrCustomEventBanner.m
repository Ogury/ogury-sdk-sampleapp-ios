//
//  OguryAdsXandrCustomEventBanner.m
//  sdk-mediation-xandr-ios
//
//  Created by Pernic on 10/12/2020.
//
#import "OguryAdsXandrCustomEventBanner.h"
#import "OguryAdsXandrCustomEventShared.h"

@implementation OguryAdsXandrCustomEventBanner
@synthesize delegate;
 
#pragma mark GodzillaCustomAdapterBanner
 
- (void)requestBannerAdWithSize:(CGSize)size
             rootViewController:(UIViewController *)rootViewController
                serverParameter:(NSString *)parameterString
                       adUnitId:(NSString *)idString
            targetingParameters:(ANTargetingParameters *)targetingParameters
{
    [OguryAdsXandrCustomEventShared defineMediation];
    
    if (parameterString != nil) {
        NSDictionary *parameters = [OguryAdsXandrCustomEventShared getDictionaryFromJSONString:parameterString];
        [[OguryAds shared]setupWithAssetKey:parameters[@"assetKey"]];
    }
    self.banner = [[OguryAdsBanner alloc]initWithAdUnitID:idString];
    OguryAdsBannerSize *sizeOguryBanner = [self getOgurySize:size];
    if (sizeOguryBanner == NULL) {
        [self.delegate didFailToLoadAd:[ANAdResponseCode UNABLE_TO_FILL]];
        return;
    }
    self.banner.frame = CGRectMake(0, 0, size.width, size.height);
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

- (BOOL)size:(CGSize)sizeXandrBanner canInclude:(CGSize)sizeOguryBanner {
    if (sizeXandrBanner.height < sizeOguryBanner.height || sizeXandrBanner.width < sizeOguryBanner.width) {
        return NO;
    }
    double maxRatio = 1.5;
    if (sizeXandrBanner.height >= sizeOguryBanner.height * maxRatio || sizeXandrBanner.width >= sizeOguryBanner.width * maxRatio) {
        return NO;
    }
    return YES;
}
 
#pragma mark OguryAdsBannerDelegate


- (void)oguryAdsBannerAdClicked:(OguryAdsBanner *)bannerAds {
    [self.delegate adWasClicked];
}

- (void)oguryAdsBannerAdClosed:(OguryAdsBanner *)bannerAds {
    [self.delegate didCloseAd];
}

- (void)oguryAdsBannerAdDisplayed:(OguryAdsBanner *)bannerAds {
    [self.delegate didPresentAd];
}

- (void)oguryAdsBannerAdError:(OguryAdsErrorType)errorType forBanner:(OguryAdsBanner *)bannerAds {
    [self.delegate didFailToLoadAd:[ANAdResponseCode INTERNAL_ERROR]];
}

- (void)oguryAdsBannerAdLoaded:(OguryAdsBanner *)bannerAds {
    [self.delegate didLoadBannerAd:bannerAds];
}

- (void)oguryAdsBannerAdNotAvailable:(OguryAdsBanner *)bannerAds {
    [self.delegate didFailToLoadAd:[ANAdResponseCode UNABLE_TO_FILL]];
}

- (void)oguryAdsBannerAdNotLoaded:(OguryAdsBanner *)bannerAds {
    [self.delegate didFailToLoadAd:[ANAdResponseCode INTERNAL_ERROR]];
}

 
@end
