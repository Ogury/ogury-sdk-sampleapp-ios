//
//  ViewController.m
//  BannerExample
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

#import "ViewController.h"
#import <OguryChoiceManager/OguryChoiceManager.h>
#import <OguryAds/OguryAds.h>


@interface ViewController()<OguryAdsBannerDelegate>

@property (nonatomic, weak) IBOutlet UITextView *statusTextView;
@property (nonatomic, weak) IBOutlet UIView *mpuView;
@property (nonatomic, weak) IBOutlet UIView *smallBannerView;

@property (nonatomic, assign) BOOL isMpuLoaded;
@property (nonatomic, assign) BOOL isSmallBannerLoaded;

@property (nonatomic, strong) OguryAdsBanner *smallBanner;
@property (nonatomic, strong) OguryAdsBanner *mpuBanner;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNewStatus:@"Choice Manager Loading..."];
    
    //The setup of Ogury Choice Manager and Ogury Ads is done AppDelegate file.
    [[OguryChoiceManager sharedManager] askWithViewController:self andCompletionBlock:^(NSError * _Nullable error, OguryChoiceManagerAnswer answer) {
        if (!error) {
            switch (answer) {
                case OguryChoiceManagerAnswerNoAnswer:
                    [self addNewStatus:@"Choice Manager No Answer"];
                    break;
                case OguryChoiceManagerAnswerFullApproval: // TCF Option
                    [self addNewStatus:@"Choice Manager Full Approval"];
                    break;
                case OguryChoiceManagerAnswerPartialApproval: // TCF Option
                    [self addNewStatus:@"Choice Manager Partial Approval"];
                    break;
                case OguryChoiceManagerAnswerRefusal: // TCF Option
                    [self addNewStatus:@"Choice Manager Refusal"];
                    break;
                case OguryChoiceManagerAnswerSaleAllowed: // CCPA Option
                    [self addNewStatus:@"Choice Manager Sale Allowed"];
                    break;
                case OguryChoiceManagerAnswerSaleDenied: // CCPA Option
                    [self addNewStatus:@"Choice Manager Unknown Option"];
                    break;
            }
        } else {
            [self addNewStatus:[NSString stringWithFormat:@"Choice Manager error : %@", error.description]];
        }
    }];
}

- (IBAction)loadMPUBtnPressed:(id)sender {
    [self addNewStatus:@"MPU Loading ..."];
    self.mpuBanner = [[OguryAdsBanner alloc] initWithAdUnitID:@"ogury_adunit"];
    self.mpuBanner.bannerDelegate = self;
    [self.mpuBanner loadWithSize:OguryAdsBannerSize.mpu_300x250];
}

- (IBAction)loadSmallBannerBtnPressed:(id)sender {
    [self addNewStatus:@"Small Banner Loading ..."];
    self.smallBanner = [[OguryAdsBanner alloc] initWithAdUnitID:@"ogury_adunit"];
    self.smallBanner.bannerDelegate = self;
    [self.smallBanner loadWithSize:OguryAdsBannerSize.small_banner_320x50];
}

- (IBAction)showMPUBtnPressed:(id)sender {
    if (self.isMpuLoaded == YES) {
        [self addNewStatus:@"MPU requested to show"];
        self.mpuBanner.frame = CGRectMake(0, 0, self.mpuView.frame.size.width, self.mpuView.frame.size.height);
        [self.mpuView addSubview:self.mpuBanner];
    } else {
        [self addNewStatus:@"MPU not loaded"];
    }
}

- (IBAction)showSmallBannerBtnPressed:(id)sender {
    if (self.isSmallBannerLoaded == YES) {
        [self addNewStatus:@"Small Banner requested to show"];
        self.smallBanner.frame = CGRectMake(0, 0, self.smallBannerView.frame.size.width, self.smallBannerView.frame.size.height);
        [self.smallBannerView addSubview:self.smallBanner];
    } else {
        [self addNewStatus:@"Small banner not loaded"];
    }
}

- (void)addNewStatus:(NSString *)status {
    NSString * statusLog = [status stringByAppendingString:@"\n"];
    self.statusTextView.text = [self.statusTextView.text stringByAppendingString:statusLog];
    NSRange bottom = NSMakeRange(self.statusTextView.text.length-1, 1);
    [self.statusTextView scrollRangeToVisible:bottom];
}

#pragma mark - OguryAds Delegate

- (void)oguryAdsBannerAdLoaded:(OguryAdsBanner*)bannerAds {
    if (bannerAds == self.smallBanner) {
        [self addNewStatus:@"Small Banner Ad received"];
        self.isSmallBannerLoaded = YES;
    } else if (bannerAds == self.mpuBanner){
        [self addNewStatus:@"MPU Banner Ad received"];
        self.isMpuLoaded = YES;
    }
}

- (void)oguryAdsBannerAdClosed:(OguryAdsBanner*)bannerAds {
    if (bannerAds == self.smallBanner) {
        [self addNewStatus:@"Small Banner Ad Closed"];
    } else if (bannerAds == self.mpuBanner){
        [self addNewStatus:@"MPU Banner Ad Closed"];
    }
}

- (void)oguryAdsBannerAdDisplayed:(OguryAdsBanner*)bannerAds {
    if (bannerAds == self.smallBanner) {
        [self addNewStatus:@"Small Banner Ad on screen"];
    } else if (bannerAds == self.mpuBanner){
        [self addNewStatus:@"MPU Banner Ad on screen"];
    }
}

- (void)oguryAdsBannerAdClicked:(OguryAdsBanner*)bannerAds {
    if (bannerAds == self.smallBanner) {
        [self addNewStatus:@"Small Banner Ad Clicked"];
    } else if (bannerAds == self.mpuBanner){
        [self addNewStatus:@"MPU Banner Ad Clicked"];
    }
}

- (void)oguryAdsBannerAdNotAvailable:(OguryAdsBanner*)bannerAds {
    if (bannerAds == self.smallBanner) {
        [self addNewStatus:@"Small Banner Not Available"];
    } else if (bannerAds == self.mpuBanner){
        [self addNewStatus:@"MPU Banner Not Available"];
    }
}

- (void)oguryAdsBannerAdError:(OguryAdsErrorType)errorType forBanner:(OguryAdsBanner*)bannerAds {
    if (bannerAds == self.smallBanner) {
        [self addNewStatus:[NSString stringWithFormat:@"Small Banner Error: %ld", errorType]];
    } else if (bannerAds == self.mpuBanner){
        [self addNewStatus:[NSString stringWithFormat:@"MPU Banner Error: %ld", errorType]];
    }
}

@end
