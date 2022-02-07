//
//  ViewController+BannerViewController.m
//  Direct integration
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

#import "BannerViewController.h"
#import "Constants.h"
#import <OguryAds/OguryAds.h>

@interface BannerViewController()<OguryBannerAdDelegate>

@property (nonatomic, weak) IBOutlet UITextView *statusTextView;
@property (nonatomic, weak) IBOutlet UIView *mpuView;
@property (nonatomic, weak) IBOutlet UIView *smallBannerView;

@property (nonatomic, assign) BOOL isMpuLoaded;
@property (nonatomic, assign) BOOL isSmallBannerLoaded;

@property (nonatomic, strong) OguryBannerAd *smallBanner;
@property (nonatomic, strong) OguryBannerAd *mpuBanner;

@end

@implementation BannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mpuBanner = [[OguryBannerAd alloc] initWithAdUnitId: MPU_adunit];
    self.mpuBanner.delegate = self;
    self.smallBanner = [[OguryBannerAd alloc] initWithAdUnitId: Banner_adunit];
    self.smallBanner.delegate = self;
}

- (IBAction)loadMPUBtnPressed:(id)sender {
    [self addNewStatus:@"[OguryAds][MPU] Loading ..."];
    [self.mpuBanner loadWithSize:OguryAdsBannerSize.mpu_300x250];
}

- (IBAction)loadSmallBannerBtnPressed:(id)sender {
    [self addNewStatus:@"[OguryAds][Small Banner] Loading ..."];
    [self.smallBanner loadWithSize:OguryAdsBannerSize.small_banner_320x50];
}

- (IBAction)showMPUBtnPressed:(id)sender {
    if (self.isMpuLoaded == YES) {
        [self addNewStatus:@"[OguryAds][MPU] requested to show"];
        self.mpuBanner.frame = CGRectMake(0, 0, self.mpuView.frame.size.width, self.mpuView.frame.size.height);
        [self.mpuView addSubview:self.mpuBanner];
    } else {
        [self addNewStatus:@"[OguryAds][MPU] not loaded"];
    }
}

- (IBAction)showSmallBannerBtnPressed:(id)sender {
    if (self.isSmallBannerLoaded == YES) {
        [self addNewStatus:@"[OguryAds][Small Banner] requested to show"];
        self.smallBanner.frame = CGRectMake(0, 0, self.smallBannerView.frame.size.width, self.smallBannerView.frame.size.height);
        [self.smallBannerView addSubview:self.smallBanner];
    } else {
        [self addNewStatus:@"[OguryAds][Small Banner] not loaded"];
    }
}

- (void)addNewStatus:(NSString *)status {
    NSString * statusLog = [status stringByAppendingString:@"\n"];
    self.statusTextView.text = [self.statusTextView.text stringByAppendingString:statusLog];
    NSRange bottom = NSMakeRange(self.statusTextView.text.length-1, 1);
    [self.statusTextView scrollRangeToVisible:bottom];
}

#pragma mark - OguryAds Delegate

- (void)didLoadOguryBannerAd:(OguryBannerAd *)banner {
    if (banner == self.smallBanner) {
        [self addNewStatus:@"[OguryAds][Small Banner] Ad loaded"];
        self.isSmallBannerLoaded = YES;
    } else if (banner == self.mpuBanner){
        [self addNewStatus:@"[OguryAds][MPU] Ad loaded"];
        self.isMpuLoaded = YES;
    }
}

- (void)didDisplayOguryBannerAd:(OguryBannerAd *)banner {
    if (banner == self.smallBanner) {
        [self addNewStatus:@"[OguryAds][Small Banner] Ad displayed"];
    } else if (banner == self.mpuBanner){
        [self addNewStatus:@"[OguryAds][MPU] Ad displayed"];
    }
}

- (void)didClickOguryBannerAd:(OguryBannerAd *)banner {
    if (banner == self.smallBanner) {
        [self addNewStatus:@"[OguryAds][Small Banner] Ad Clicked"];
    } else if (banner == self.mpuBanner){
        [self addNewStatus:@"[OguryAds][MPU] Ad Clicked"];
    }
}

- (void)didCloseOguryBannerAd:(OguryBannerAd *)banner {
    if (banner == self.smallBanner) {
        [self addNewStatus:@"[OguryAds][Small Banner] Ad Closed"];
    } else if (banner == self.mpuBanner){
        [self addNewStatus:@"[OguryAds][MPU] Ad Closed"];
    }
}

- (void)didTriggerImpressionOguryBannerAd:(OguryBannerAd *)banner {
    if (banner == self.smallBanner) {
        [self addNewStatus:@"[OguryAds][Small Banner] Ad on impressions"];
    } else if (banner == self.mpuBanner){
        [self addNewStatus:@"[OguryAds][MPU] Ad on impressions"];
    }
}

- (void)didFailOguryBannerAdWithError:(OguryError *)error forAd:(OguryBannerAd *)banner {
    if (banner == self.smallBanner) {
        [self addNewStatus:[NSString stringWithFormat:@"[OguryAds][Small Banner] Error: %ld", error.code]];
    } else if (banner == self.mpuBanner){
        [self addNewStatus:[NSString stringWithFormat:@"[OguryAds][MPU] Error: %ld", error.code]];
    }
    [self addNewStatus: @"For more informations about error codes please refer to our documentation at https://docs.ogury.co/"];
}

@end
