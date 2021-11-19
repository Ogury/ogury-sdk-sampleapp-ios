#import <Foundation/Foundation.h>
#import <OguryAds/OguryAdsDelegate.h>
#import <OguryAds/OguryAdsInterstitial.h>
#import <OguryAds/OguryAdsOptinVideo.h>
#import <OguryAds/OguryAdsThumbnailAd.h>
#import <OguryAds/OguryAdsBanner.h>
#import <OguryAds/OGARewardItem.h>
#import <OguryAds/Ogury.h>

typedef void (^SetupCompletionBlock)(NSError* error);
typedef void (^LoadCompletionBlock)(void);

@interface OguryAds : NSObject

@property (nonatomic, strong) NSString *sdkVersion;

+ (instancetype)shared;
- (void)setupWithAssetKey:(NSString *)assetKey;
- (void)setupWithAssetKey:(NSString *)assetKey andCompletionHandler:(SetupCompletionBlock)completionHandler;
- (void)setupWithAssetKey:(NSString *)assetKey andMediationName:(NSString *)mediationName;
- (void)setupWithAssetKey:(NSString *)assetKey mediationName:(NSString *)mediationName andCompletionHandler:(SetupCompletionBlock)completionHandler;
- (void)defineSDKType:(NSUInteger)sdkType;
- (void)defineMediationName:(NSString *)mediationName;

@end
