//
//  OguryAdsXandrCustomEventInterstitial.h
//  sdk-mediation-xandr-ios
//

#import <OguryAds/OguryAds.h>
#import <AppNexusSDK/ANCustomAdapter.h>

NS_ASSUME_NONNULL_BEGIN

@interface OguryAdsXandrCustomEventInterstitial : NSObject<ANCustomAdapterInterstitial, OguryAdsInterstitialDelegate>

@property (nonatomic, strong) OguryAdsInterstitial *interstitial;

@end

NS_ASSUME_NONNULL_END




