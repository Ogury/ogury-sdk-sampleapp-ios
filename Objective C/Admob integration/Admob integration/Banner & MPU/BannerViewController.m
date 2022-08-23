//
//  ViewController+BannerViewController.m
//  Admob integration
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

#import "BannerViewController.h"
#import "Constants.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface BannerViewController()<GADBannerViewDelegate>

@property (nonatomic, weak) IBOutlet UITextView *statusTextView;
@property (nonatomic, weak) IBOutlet UIView *mpuView;
@property (nonatomic, weak) IBOutlet UIView *smallBannerView;

@property (nonatomic, assign) BOOL isMpuLoaded;
@property (nonatomic, assign) BOOL isSmallBannerLoaded;

@property (nonatomic,strong) GADBannerView *smallBanner;
@property (nonatomic,strong) GADBannerView *mpuBanner;

@end

@implementation BannerViewController

/*
    It's recommended to set up OgurySdk earlier to accelerate the load & impression process,
        in this sample the set up is done in AppDelegate.m
    On needs, replace the bundle id in the project settings and the ad unit by your Google ad unit
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mpuBanner = [[GADBannerView alloc]initWithAdSize:GADAdSizeMediumRectangle];
    self.mpuBanner.adUnitID = Admob_MPU_adunit;
    self.mpuBanner.delegate = self;
    self.mpuBanner.rootViewController = self;
    self.smallBanner = [[GADBannerView alloc]initWithAdSize:GADAdSizeBanner];
    self.smallBanner.adUnitID = Admob_banner_adunit;
    self.smallBanner.delegate = self;
    self.smallBanner.rootViewController = self;
}

- (IBAction)loadMPUBtnPressed:(id)sender {
    [self addNewStatus:@"[Admob][MPU] Loading ..."];
    [self.mpuBanner loadRequest:[GADRequest new]];
}

- (IBAction)loadSmallBannerBtnPressed:(id)sender {
    [self addNewStatus:@"[Admob][Small banner] Loading ..."];
    [self.smallBanner loadRequest:[GADRequest new]];
}

- (IBAction)showMPUBtnPressed:(id)sender {
    if (self.isMpuLoaded == YES) {
        [self addNewStatus:@"[Admob][MPU] requested to show"];
        [self.mpuView addSubview:self.mpuBanner];
    } else {
        [self addNewStatus:@"[Admob][MPU] not loaded"];
    }

}

- (IBAction)showSmallBannerBtnPressed:(id)sender {
    if (self.isSmallBannerLoaded == YES) {
        [self addNewStatus:@"[Admob][Small banner] requested to show"];
        [self.smallBannerView addSubview:self.smallBanner];
    } else {
        [self addNewStatus:@"[Admob][Small banner] not loaded"];
    }
}

- (void)addNewStatus:(NSString *)status {
    NSString * statusLog = [status stringByAppendingString:@"\n"];
    self.statusTextView.text = [self.statusTextView.text stringByAppendingString:statusLog];
    NSRange bottom = NSMakeRange(self.statusTextView.text.length-1, 1);
    [self.statusTextView scrollRangeToVisible:bottom];
}

#pragma mark - AdMob Delegate
- (void)bannerViewDidReceiveAd:(GADBannerView *)bannerView {
        if (bannerView == self.smallBanner) {
            [self addNewStatus:@"[Admob][Small banner] Ad received"];
            self.isSmallBannerLoaded = YES;
        } else if (bannerView == self.mpuBanner){
            [self addNewStatus:@"[Admob][MPU] Banner Ad received"];
            self.isMpuLoaded = YES;
        }
}

- (void)bannerViewWillPresentScreen:(GADBannerView *)bannerView {
        if (bannerView == self.smallBanner) {
            [self addNewStatus:@"[Admob][Small banner] on screen"];
        } else if (bannerView == self.mpuBanner){
            [self addNewStatus:@"[Admob][MPU] Banner on screen"];
        }
}

- (void)bannerView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(NSError *)error {
    if (bannerView == self.smallBanner) {
        [self addNewStatus:[NSString stringWithFormat:@"[Admob][Small banner] Error: %@", error.localizedDescription]];
    } else if (bannerView == self.mpuBanner){
        [self addNewStatus:[NSString stringWithFormat:@"[Admob][MPU] Banner Error: %@", error.localizedDescription]];
    }
}

@end
