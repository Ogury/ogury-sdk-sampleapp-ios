//
//  OguryAdsXandrCustomEventsShared.m
//  sdk-mediation-xandr-ios
//
//  Created by Pernic on 10/12/2020.
//

#import <Foundation/Foundation.h>
#import "OguryAdsXandrCustomEventShared.h"
#import <OguryAds/OguryAds.h>

@implementation OguryAdsXandrCustomEventShared

+ (NSDictionary *)getDictionaryFromJSONString:(NSString *)jsonString {
    
    NSError *error;
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id object = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    if (error) {
        NSLog(@"Error in Ogury CustomEvent : %@ with jsonString: %@", [error localizedDescription], jsonString);
        return [NSDictionary dictionary];
    }
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *results = object;
        return results;
    } else {
        NSLog(@"Error in Ogury CustomEvent : %@ with jsonString: %@", [error localizedDescription], jsonString);
        return [NSDictionary dictionary];
    }
}

+ (void)defineMediation {
    [[OguryAds shared] defineMediationName:@"Xandr"];
}

@end
