//
//  OguryThumbnailCustomEvents.h
//
//  Created by ogury on 20/04/2020.
//  Copyright © 2020 ogury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GADCustomEventBanner.h>
#import <GoogleMobileAds/GADRequestError.h>
#import <OguryAds/OguryAds.h>

NS_ASSUME_NONNULL_BEGIN

@interface OguryThumbnailCustomEvents : NSObject<OguryAdsThumbnailAdDelegate, GADCustomEventBanner, GADAdNetworkExtras>
@end

NS_ASSUME_NONNULL_END
