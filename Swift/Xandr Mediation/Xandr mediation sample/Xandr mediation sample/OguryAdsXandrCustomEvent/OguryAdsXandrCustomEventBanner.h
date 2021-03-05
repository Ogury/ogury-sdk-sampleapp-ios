#import <OguryAds/OguryAds.h>
#import <AppNexusSDK/ANCustomAdapter.h>

NS_ASSUME_NONNULL_BEGIN

@interface OguryAdsXandrCustomEventBanner : NSObject<OguryAdsBannerDelegate, ANCustomAdapterBanner>

@property (nonatomic, strong) OguryAdsBanner *banner;

@end

NS_ASSUME_NONNULL_END

