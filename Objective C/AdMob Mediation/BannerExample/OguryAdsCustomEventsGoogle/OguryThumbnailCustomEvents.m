//
//  OguryThumbnailCustomEvents.m
//
//  Created by ogury on 20/04/2020.
//  Copyright © 2020 ogury. All rights reserved.
//

#import "OguryThumbnailCustomEvents.h"
#import "OguryCustomEventsShared.h"
#import "OGGThumbnailView.h"

static NSString * const OGGThumbnailAdAssetKey = @"assetKey";
static NSString * const OGGThumbnailAdAdUnitId = @"adUnitId";

static NSString * const OGGThumbnailAdTopMargin = @"top_margin";
static NSString * const OGGThumbnailAdLeftMargin = @"left_margin";
static NSString * const OGGThumbnailAdDefaultTopValue = @"0";
static NSString * const OGGThumbnailAdDefaultLeftValue = @"0";

static NSString * const OGGThumbnailAdRectCorner = @"rect_corner";
static NSString * const OGGThumbnailAdXMargin = @"x_margin";
static NSString * const OGGThumbnailAdYMargin = @"y_margin";

static NSString * const OGGThumbnailAdWhitelist = @"whitelist";
static NSString * const OGGThumbnailAdBlacklist = @"blacklist";

@interface OguryThumbnailCustomEvents()

@property (nonatomic, strong) OguryAdsThumbnailAd *thumbnail;
@property (nonatomic, strong) OGGThumbnailView *thumbnailView;

@end

@implementation OguryThumbnailCustomEvents

@synthesize delegate;

- (void)requestBannerAd:(GADAdSize)adSize parameter:(nullable NSString *)serverParameter label:(nullable NSString *)serverLabel request:(nonnull GADCustomEventRequest *)request {
    NSError *error = nil;
    [OguryCustomEventsShared defineMediation];
    NSDictionary *dict = [OguryCustomEventsShared getDictionaryFromJSONString:serverParameter error:&error];
    if (error) {
        [self.delegate customEventBanner:self didFailAd:error];
        return;
    }
    NSString *assetKey = dict[OGGThumbnailAdAssetKey];
    NSString *adUnitID = dict[OGGThumbnailAdAdUnitId];
    if (assetKey != nil) {
        [[OguryAds shared] setupWithAssetKey:assetKey];
    }
    
    self.thumbnail = [[OguryAdsThumbnailAd alloc] initWithAdUnitID:adUnitID];
    self.thumbnail.thumbnailAdDelegate = self;
    self.thumbnailView = [self createViewWithThumbnail:self.thumbnail request:request];
    if (!self.thumbnailView) {
        NSError *error = [NSError errorWithDomain:kGADErrorDomain
                                                 code:kGADErrorNoFill
                                             userInfo:nil];
        [self.delegate customEventBanner:self didFailAd:error];
        return;
    }
    
    [self configureWhitelistAndBlacklistWithRequest:request];
    [self load:self.thumbnail adSize:adSize];
}

- (void)configureWhitelistAndBlacklistWithRequest:(GADCustomEventRequest *)request {
    NSDictionary *additionalParameters = [request additionalParameters];
    id objectWhitelist = additionalParameters[OGGThumbnailAdWhitelist];
    if (objectWhitelist && [objectWhitelist isKindOfClass:[NSArray class]]) {
        [self.thumbnail setWhitelistBundleIdentifiers:(NSArray *)objectWhitelist];
    } else if (objectWhitelist) {
        NSLog(@"Missing or invalid extra '%@' to configure Thumbnail ad.", OGGThumbnailAdWhitelist);
    }
    
    id objectBlacklist = additionalParameters[OGGThumbnailAdBlacklist];
    if (objectBlacklist && [objectBlacklist isKindOfClass:[NSArray class]]) {
        [self.thumbnail setBlacklistViewControllers:(NSArray *)objectBlacklist];
    } else if (objectBlacklist) {
        NSLog(@"Missing or invalid extra '%@' to configure Thumbnail ad.", OGGThumbnailAdBlacklist);
    }
}


- (OGGThumbnailView *)createViewWithThumbnail:(OguryAdsThumbnailAd *)thumbnail request:(GADCustomEventRequest *)request {
    NSDictionary *additionalParameters = [request additionalParameters];
    // Legacy
    if (additionalParameters[OGGThumbnailAdTopMargin] || additionalParameters[OGGThumbnailAdLeftMargin]) {
        id topMargin = OGGThumbnailAdDefaultTopValue;
        id leftMargin = OGGThumbnailAdDefaultLeftValue;
        if (!additionalParameters[OGGThumbnailAdTopMargin]) {
            NSLog(@"Missing extra '%@' to configure Thumbnail ad. Using default value: %@", OGGThumbnailAdTopMargin, topMargin);
        } else {
            topMargin = additionalParameters[OGGThumbnailAdTopMargin];
        }
        if (!additionalParameters[OGGThumbnailAdLeftMargin]) {
            NSLog(@"Missing extra '%@' to configure Thumbnail ad. Using default value: %@", OGGThumbnailAdLeftMargin, leftMargin);
        } else {
            leftMargin = additionalParameters[OGGThumbnailAdLeftMargin];
        }
        return [[OGGThumbnailView alloc] initWithThumbnail:thumbnail leftMargin:[leftMargin floatValue] topMargin:[topMargin floatValue]];
    }
    
    // Corner gravity
    if (additionalParameters[OGGThumbnailAdRectCorner] || additionalParameters[OGGThumbnailAdXMargin] || additionalParameters[OGGThumbnailAdYMargin]) {
        OguryRectCorner rectCorner;
        if (![self parse:additionalParameters[OGGThumbnailAdRectCorner] rectCorner:&rectCorner]) {
            NSLog(@"Missing or invalid extra '%@' to configure Thumbnail ad.", OGGThumbnailAdRectCorner);
            return nil;
        }
        if (!additionalParameters[OGGThumbnailAdXMargin]) {
            NSLog(@"Missing extra '%@' to configure Thumbnail ad.", OGGThumbnailAdXMargin);
            return nil;
        }
        if (!additionalParameters[OGGThumbnailAdYMargin]) {
            NSLog(@"Missing extra '%@' to configure Thumbnail ad.", OGGThumbnailAdYMargin);
            return nil;
        }
        return [[OGGThumbnailView alloc] initWithThumbnail:thumbnail
                                                rectCorner:rectCorner
                                                   xMargin:[additionalParameters[OGGThumbnailAdXMargin] floatValue]
                                                   yMargin:[additionalParameters[OGGThumbnailAdYMargin] floatValue]];
    }
    
    // Default
    return [[OGGThumbnailView alloc] initWithThumbnail:self.thumbnail];
}

- (BOOL)parse:(NSString *)sRectCorner rectCorner:(OguryRectCorner *)rectCorner {
    if ([sRectCorner isEqualToString:@"top_right"]) {
        *rectCorner = OguryTopRight;
        return YES;
    } else if ([sRectCorner isEqualToString:@"top_left"]) {
        *rectCorner = OguryTopLeft;
        return YES;
    } else if ([sRectCorner isEqualToString:@"bottom_right"]) {
        *rectCorner = OguryBottomRight;
        return YES;
    } else if ([sRectCorner isEqualToString:@"bottom_left"]) {
        *rectCorner = OguryBottomLeft;
        return YES;
    }
    return NO;
}

- (void)load:(OguryAdsThumbnailAd *)thumbnail adSize:(GADAdSize)adSize {
    if (adSize.size.width > 0 && adSize.size.width > 0) {
        [thumbnail load:adSize.size];
    } else {
        [thumbnail load];
    }
}

- (void)oguryAdsThumbnailAdAdError:(OguryAdsErrorType)errorType {
    NSError *error = [NSError errorWithDomain:kGADErrorDomain
                                         code:kGADErrorServerError
                                     userInfo:nil];
    [self.delegate customEventBanner:self didFailAd:error];
}

- (void)oguryAdsThumbnailAdAdLoaded {
    [self.delegate customEventBanner:self didReceiveAd:self.thumbnailView];
    [self.thumbnailView showThumbnail];
}

- (void)oguryAdsThumbnailAdAdNotAvailable {
    NSError *error = [NSError errorWithDomain:kGADErrorDomain
                                         code:kGADErrorInternalError
                                     userInfo:nil];
    [self.delegate customEventBanner:self didFailAd:error];
}

- (void)oguryAdsThumbnailAdAdNotLoaded {
    NSError *error = [NSError errorWithDomain:kGADErrorDomain
                                             code:kGADErrorNoFill
                                         userInfo:nil];
    [self.delegate customEventBanner:self didFailAd:error];
}

- (void)oguryAdsThumbnailAdAdAvailable {
}

- (void)oguryAdsThumbnailAdAdClosed {
}

- (void)oguryAdsThumbnailAdAdDisplayed {
}

- (void)oguryAdsThumbnailAdAdClicked{
    [self.delegate customEventBannerWasClicked:self];
}

@end
