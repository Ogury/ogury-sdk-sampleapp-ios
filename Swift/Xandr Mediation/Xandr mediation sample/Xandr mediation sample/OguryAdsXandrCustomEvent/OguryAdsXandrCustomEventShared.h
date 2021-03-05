//
//  OguryAdsXandrCustomEventsShared.h
//  sdk-mediation-xandr-ios
//

#define OGURY_ASSET_KEY_STRING_FOR_ADMOB  @"assetKey"
#define OGURY_AD_UNIT_ID_STRING_FOR_ADMOB  @"adUnitId"

NS_ASSUME_NONNULL_BEGIN

@interface OguryAdsXandrCustomEventShared : NSObject

+ (NSDictionary *)getDictionaryFromJSONString:(NSString *)jsonString;

+ (void)defineMediation;

@end

NS_ASSUME_NONNULL_END

