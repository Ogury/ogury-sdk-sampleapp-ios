//
//  OguryCustomEventsShared.m
//
//  Created by Florin-Daniel DOBJENSCHI on 11/11/2020.
//

#import <Foundation/Foundation.h>
#import "OguryCustomEventsShared.h"
#import <GoogleMobileAds/GADRequestError.h>
#import <OguryAds/OguryAds.h>

@implementation OguryCustomEventsShared

+ (NSDictionary *)getDictionaryFromJSONString:(NSString *)jsonString error:(NSError **)error {
    NSString *adunitRegex = @"[a-zA-Z-_0-9]*";
    NSPredicate *adUnitPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", adunitRegex];
    if ([adUnitPredicate evaluateWithObject:jsonString]) {
        NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
        result[OGURY_AD_UNIT_ID_STRING_FOR_ADMOB] = jsonString;
        return [result copy];
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id object = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:error];
    
    if (*error) {
        NSLog(@"Error in Ogury CustomEvent : %@ with jsonString: %@", [*error localizedDescription], jsonString);
        return [NSDictionary dictionary];
    }
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *results = object;
        return results;
    } else {
        *error = [NSError errorWithDomain:kGADErrorDomain code:kGADErrorInvalidArgument userInfo:nil];
        NSLog(@"Error in Ogury CustomEvent : %@ with jsonString: %@", [*error localizedDescription], jsonString);
        return [NSDictionary dictionary];
    }
}

+ (void)defineMediation {
    [[OguryAds shared] defineMediationName:@"Google"];
}

@end
