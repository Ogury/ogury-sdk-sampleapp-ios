//
//  Copyright © 2020 ogury. All rights reserved.
//

#import "OGGThumbnailView.h"
#import <OguryAds/OguryAds.h>

@interface OGGThumbnailView()

@property (nonatomic, strong) OguryAdsThumbnailAd *thumbnail;
@property (nonatomic, assign) BOOL thumbnailShown;
@property (nonatomic, assign) BOOL thumbnailViewInWindow;

@property (nonatomic, assign) BOOL isDefault;

@property (nonatomic, assign) BOOL isLegacy;
@property (nonatomic, assign) CGPoint legacyPosition;

@property (nonatomic, assign) OguryRectCorner rectCorner;
@property (nonatomic, assign) OguryOffset margin;

@end

@implementation OGGThumbnailView

- (id)initWithThumbnail:(OguryAdsThumbnailAd *)thumbnail {
    if (self = [super init]) {
        _thumbnail = thumbnail;
        _isDefault = YES;
    }
    return self;
}

- (id)initWithThumbnail:(OguryAdsThumbnailAd *)thumbnail leftMargin:(CGFloat)leftMargin topMargin:(CGFloat)topMargin {
    if (self = [super init]) {
        _thumbnail = thumbnail;
        _isLegacy = YES;
        _legacyPosition = CGPointMake(leftMargin, topMargin);
    }
    return self;
}

- (id)initWithThumbnail:(OguryAdsThumbnailAd *)thumbnail rectCorner:(OguryRectCorner)rectCorner xMargin:(CGFloat)xMargin yMargin:(CGFloat)yMargin {
    if (self = [super init]) {
        _thumbnail = thumbnail;
        _rectCorner = rectCorner;
        _margin = OguryOffsetMake(xMargin, yMargin);
    }
    return self;
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    [self thumbnailViewIsVisible];
    [self showThumbnail];
}

- (void)showThumbnail {
    if (!self.thumbnailShown && self.thumbnailViewInWindow && self.thumbnail!= nil) {
        if (self.isDefault) {
            [self.thumbnail show];
        } else if (self.isLegacy) {
            [self.thumbnail show:self.legacyPosition];
        } else {
            [self.thumbnail showWithOguryRectCorner:self.rectCorner margin:self.margin];
        }
        self.thumbnailShown = YES;
    }
}

- (void)thumbnailViewIsVisible {
    self.thumbnailViewInWindow = YES;
}

@end
