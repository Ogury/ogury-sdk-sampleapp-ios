//
//  OguryAdsXandrCustomEventInterstitial.m
//  sdk-mediation-xandr-ios
//
//  Created by Pernic on 09/12/2020.
//

#import <Foundation/Foundation.h>
#import "OguryAdsXandrCustomEventInterstitial.h"
#import "OguryAdsXandrCustomEventShared.h"
#import <OguryAds/OguryAds.h>


@implementation OguryAdsXandrCustomEventInterstitial
@synthesize delegate;
 
#pragma mark GodzillaCustomAdapterInterstitial
 
- (void)requestInterstitialAdWithParameter:(NSString *)parameterString
                                  adUnitId:(NSString *)idString
                       targetingParameters:(ANTargetingParameters *)targetingParameters
{
    [OguryAdsXandrCustomEventShared defineMediation];
    
    if (parameterString != nil) {
        NSDictionary *parameters = [OguryAdsXandrCustomEventShared getDictionaryFromJSONString:parameterString];
        [[OguryAds shared]setupWithAssetKey:parameters[@"assetKey"]];
    }
    self.interstitial = [[OguryAdsInterstitial alloc] initWithAdUnitID:idString];
    self.interstitial.interstitialDelegate = self;
    [self.interstitial load];
}
 
- (void)presentFromViewController:(UIViewController *)viewController {
    [self.interstitial showAdInViewController:viewController];
}

- (BOOL)isReady {
    return self.interstitial.isLoaded;
}

 
#pragma mark OguryAdsInterstitialDelegate

- (void)oguryAdsInterstitialAdClosed {
    [self.delegate didCloseAd];
}

- (void)oguryAdsInterstitialAdDisplayed {
    [self.delegate didPresentAd];
}

- (void)oguryAdsInterstitialAdError:(OguryAdsErrorType)errorType {
    [self.delegate didFailToLoadAd:[ANAdResponseCode INTERNAL_ERROR]];
}

- (void)oguryAdsInterstitialAdLoaded {
    [self.delegate didLoadInterstitialAd:self];
}

- (void)oguryAdsInterstitialAdNotAvailable {
    [self.delegate didFailToLoadAd:[ANAdResponseCode UNABLE_TO_FILL]];
}

- (void)oguryAdsInterstitialAdNotLoaded {
    [self.delegate didFailToLoadAd:[ANAdResponseCode INTERNAL_ERROR]];
}

- (void)oguryAdsInterstitialAdClicked {
    [self.delegate adWasClicked];
}



@end
