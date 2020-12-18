//
//  OguryBannerCustomEvents.h
//
//  Created by Florin-Daniel DOBJENSCHI on 11/11/2020.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GADCustomEventBanner.h>
#import <GoogleMobileAds/GADRequestError.h>
#import <OguryAds/OguryAds.h>

NS_ASSUME_NONNULL_BEGIN

@interface OguryBannerCustomEvents : NSObject<OguryAdsBannerDelegate, GADCustomEventBanner>

@property (nonatomic, strong) OguryAdsBanner *banner;

@end

NS_ASSUME_NONNULL_END

