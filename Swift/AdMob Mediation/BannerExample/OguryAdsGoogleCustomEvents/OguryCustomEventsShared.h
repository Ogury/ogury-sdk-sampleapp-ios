//
//  OguryCustomEventsShared.h
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

#define OGURY_ASSET_KEY_STRING_FOR_ADMOB  @"assetKey"
#define OGURY_AD_UNIT_ID_STRING_FOR_ADMOB  @"adUnitId"

NS_ASSUME_NONNULL_BEGIN

@interface OguryCustomEventsShared : NSObject

+ (NSDictionary *)getDictionaryFromJSONString:(NSString *)jsonString error:(NSError **)error;
+ (void)defineMediation;

@end

NS_ASSUME_NONNULL_END
