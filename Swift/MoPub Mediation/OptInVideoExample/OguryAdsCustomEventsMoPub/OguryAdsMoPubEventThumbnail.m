//
//  OguryAdsMoPubEventThumbnail.m
//
//  Created by ogury on 28/04/2020.
//  Copyright © 2020 ogury. All rights reserved.
//

#import "OguryAdsMoPubEventThumbnail.h"
#import "OGMThumbnailView.h"
#import <OguryAds/OguryAds.h>

static NSString * const OGMThumbnailAdAssetKey = @"asset_key";
static NSString * const OGMThumbnailAdAdUnitId = @"ad_unit_id";

static NSString * const OGMThumbnailAdTopMargin = @"top_margin";
static NSString * const OGMThumbnailAdLeftMargin = @"left_margin";
static NSString * const OGMThumbnailAdDefaultTopValue = @"0";
static NSString * const OGMThumbnailAdDefaultLeftValue = @"0";

static NSString * const OGMThumbnailAdRectCorner = @"rect_corner";
static NSString * const OGMThumbnailAdXMargin = @"x_margin";
static NSString * const OGMThumbnailAdYMargin = @"y_margin";

static NSString * const OGMThumbnailAdWhitelist = @"whitelist";
static NSString * const OGMThumbnailAdBlacklist = @"blacklist";

@interface OguryAdsMoPubEventThumbnail () <OguryAdsThumbnailAdDelegate>

@property (nonatomic, strong) OguryAdsThumbnailAd *thumbnail;
@property (nonatomic, strong) OGMThumbnailView *thumbnailView;

@end

@implementation OguryAdsMoPubEventThumbnail

- (void)dealloc {
    self.thumbnail.thumbnailAdDelegate = nil;
}

- (void)requestAdWithSize:(CGSize)size adapterInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup {
    NSString *assetKey = [info objectForKey:OGMThumbnailAdAssetKey];
    if (assetKey != nil) {
        [[OguryAds shared]setupWithAssetKey:assetKey];
    }
    [[OguryAds shared] defineMediationName:@"MoPub"];
    NSString *adunitId = [info objectForKey:OGMThumbnailAdAdUnitId];
    
    self.thumbnail = [[OguryAdsThumbnailAd alloc] initWithAdUnitID:adunitId];
    self.thumbnail.thumbnailAdDelegate = self;
    self.thumbnailView = [self createViewWithThumbnail:self.thumbnail];
    if (!self.thumbnailView) {
        NSError *error = [NSError errorWithCode:MOPUBErrorAdapterFailedToLoadAd];
        [self.delegate inlineAdAdapter:self didFailToLoadAdWithError:error];
        return;
    }
    
    [self configureWhitelistAndBlacklist];
    [self load:self.thumbnail size:size];
}

- (OGMThumbnailView *)createViewWithThumbnail:(OguryAdsThumbnailAd *)thumbnail {
    // Legacy
    if (self.localExtras[OGMThumbnailAdTopMargin] || self.localExtras[OGMThumbnailAdLeftMargin]) {
        id topMargin = OGMThumbnailAdDefaultTopValue;
        id leftMargin = OGMThumbnailAdDefaultLeftValue;
        if (!self.localExtras[OGMThumbnailAdTopMargin]) {
            NSLog(@"Missing extra '%@' to configure Thumbnail ad. Using default value: %@", OGMThumbnailAdTopMargin, topMargin);
        } else {
            topMargin = self.localExtras[OGMThumbnailAdTopMargin];
        }
        if (!self.localExtras[OGMThumbnailAdLeftMargin]) {
            NSLog(@"Missing extra '%@' to configure Thumbnail ad. Using default value: %@", OGMThumbnailAdLeftMargin, leftMargin);
        } else {
            leftMargin = self.localExtras[OGMThumbnailAdLeftMargin];
        }
        return [[OGMThumbnailView alloc] initWithThumbnail:thumbnail leftMargin:[leftMargin floatValue] topMargin:[topMargin floatValue]];
    }
    
    // Corner gravity
    if (self.localExtras[OGMThumbnailAdRectCorner] || self.localExtras[OGMThumbnailAdXMargin] || self.localExtras[OGMThumbnailAdYMargin]) {
        OguryRectCorner rectCorner;
        if (![self parse:self.localExtras[OGMThumbnailAdRectCorner] rectCorner:&rectCorner]) {
            NSLog(@"Missing or invalid extra '%@' to configure Thumbnail ad.", OGMThumbnailAdRectCorner);
            return nil;
        }
        if (!self.localExtras[OGMThumbnailAdXMargin]) {
            NSLog(@"Missing extra '%@' to configure Thumbnail ad.", OGMThumbnailAdXMargin);
            return nil;
        }
        if (!self.localExtras[OGMThumbnailAdYMargin]) {
            NSLog(@"Missing extra '%@' to configure Thumbnail ad.", OGMThumbnailAdYMargin);
            return nil;
        }
        return [[OGMThumbnailView alloc] initWithThumbnail:thumbnail
                                                rectCorner:rectCorner
                                                   xMargin:[self.localExtras[OGMThumbnailAdXMargin] floatValue]
                                                   yMargin:[self.localExtras[OGMThumbnailAdYMargin] floatValue]];
    }
    
    // Default
    return [[OGMThumbnailView alloc] initWithThumbnail:self.thumbnail];
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

- (void)configureWhitelistAndBlacklist {
    id objectWhitelist = self.localExtras[OGMThumbnailAdWhitelist];
    if (objectWhitelist && [objectWhitelist isKindOfClass:[NSArray class]]) {
        [self.thumbnail setWhitelistBundleIdentifiers:(NSArray *)objectWhitelist];
    } else if (objectWhitelist) {
        NSLog(@"Missing or invalid extra '%@' to configure Thumbnail ad.", OGMThumbnailAdWhitelist);
    }
    
    id objectBlacklist = self.localExtras[OGMThumbnailAdBlacklist];
    if (objectBlacklist && [objectBlacklist isKindOfClass:[NSArray class]]) {
        [self.thumbnail setWhitelistBundleIdentifiers:(NSArray *)objectBlacklist];
    } else if (objectBlacklist) {
        NSLog(@"Missing or invalid extra '%@' to configure Thumbnail ad.", OGMThumbnailAdBlacklist);
    }
}

- (void)load:(OguryAdsThumbnailAd *)thumbnail size:(CGSize)size {
    if (size.height > 0 && size.width > 0) {
        [thumbnail load:size];
    } else {
        [thumbnail load];
    }
}

# pragma thumbnail delegate

- (void)oguryAdsThumbnailAdAdAvailable {
}

- (BOOL)enableAutomaticImpressionAndClickTracking{
    return NO;
}

- (void)didDisplayAd {
}

- (void)rotateToOrientation:(UIInterfaceOrientation)newOrientation {
}

- (void)oguryAdsThumbnailAdAdClosed {
}

- (void)oguryAdsThumbnailAdAdDisplayed {
    [self.delegate inlineAdAdapterDidTrackImpression:self];
}

- (void)oguryAdsThumbnailAdAdError:(OguryAdsErrorType)errorType {
    NSError *error = [NSError errorWithCode:MOPUBErrorNoInventory];
    [self.delegate inlineAdAdapter:self didFailToLoadAdWithError:error];
}

- (void)oguryAdsThumbnailAdAdLoaded {
    [self.delegate inlineAdAdapter:self didLoadAdWithAdView:self.thumbnailView];
    self.thumbnailView.hidden = YES;
    [self.thumbnailView showThumbnail];
}

- (void)oguryAdsThumbnailAdAdNotAvailable {
    NSError *error = [NSError errorWithCode:MOPUBErrorNoInventory];
    [self.delegate inlineAdAdapter:self didFailToLoadAdWithError:error];
}

- (void)oguryAdsThumbnailAdAdNotLoaded {
    NSError *error = [NSError errorWithCode:MOPUBErrorNoInventory];
    [self.delegate inlineAdAdapter:self didFailToLoadAdWithError:error];
}

- (void)oguryAdsThumbnailAdAdClicked {
    [self.delegate inlineAdAdapterDidTrackClick:self];
}

@end
