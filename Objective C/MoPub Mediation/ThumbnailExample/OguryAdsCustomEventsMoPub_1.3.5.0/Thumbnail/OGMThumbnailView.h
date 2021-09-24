//
//  OGMThumbnailView.h
//
//  Created by ogury on 11/05/2020.
//  Copyright © 2020 ogury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OguryAds/OguryAds.h>

NS_ASSUME_NONNULL_BEGIN

@interface OGMThumbnailView : UIView

- (id)initWithThumbnail:(OguryAdsThumbnailAd *)thumbnail;

- (id)initWithThumbnail:(OguryAdsThumbnailAd *)thumbnail leftMargin:(CGFloat)leftMargin topMargin:(CGFloat)topMargin;

- (id)initWithThumbnail:(OguryAdsThumbnailAd *)thumbnail rectCorner:(OguryRectCorner)rectCorner xMargin:(CGFloat)xMargin yMargin:(CGFloat)yMargin;

- (void)showThumbnail;

@end

NS_ASSUME_NONNULL_END
