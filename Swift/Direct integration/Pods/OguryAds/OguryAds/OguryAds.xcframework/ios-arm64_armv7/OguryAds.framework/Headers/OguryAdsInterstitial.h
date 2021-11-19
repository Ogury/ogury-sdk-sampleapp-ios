#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OguryAdsDelegate.h"


@interface OguryAdsInterstitial : NSObject
 
@property (nonatomic, weak) id  <OguryAdsInterstitialDelegate> _Nullable interstitialDelegate;
@property (nonatomic, assign) BOOL isLoaded;
@property (nonatomic, strong) NSString  * _Nullable adUnitID;
@property (nonatomic, strong) NSString * _Nullable userId;

- (instancetype _Nullable)initWithAdUnitID:( NSString* _Nullable )adUnitID;

- (void)load;
- (void)showAdInViewController:(UIViewController * _Nonnull)viewController;

///Deprecated use 'showAdInViewController:' method instead
- (void)showInViewController:(UIViewController * _Nonnull)controller __attribute__((deprecated("Use 'showAdInViewController:' method instead")));

@end

