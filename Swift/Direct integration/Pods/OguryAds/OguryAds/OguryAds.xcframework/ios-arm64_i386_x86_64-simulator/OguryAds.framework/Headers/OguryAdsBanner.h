#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>
#import "OguryAdsDelegate.h"
#import "OguryAdsBannerSize.h"
#import <UIKit/UIViewController.h>

NS_ASSUME_NONNULL_BEGIN

@interface OguryAdsBanner : UIView

@property (nonatomic, weak) id <OguryAdsBannerDelegate> bannerDelegate;
@property (nonatomic, strong) NSString  * _Nullable adUnitID;
@property (nonatomic, assign) BOOL isLoaded;
- (instancetype _Nullable)initWithAdUnitID:( NSString* _Nullable )adUnitID;

- (void)loadWithSize:(OguryAdsBannerSize *)size;
- (void)close;
- (BOOL)isExpanded;

@end

NS_ASSUME_NONNULL_END

