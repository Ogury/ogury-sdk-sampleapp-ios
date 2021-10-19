//
//  ViewController.m
//  BannerExample
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

#import "ViewController.h"
#import <OguryChoiceManager/OguryChoiceManager.h>
#import <GoogleMobileAds/GoogleMobileAds.h>


@interface ViewController()<GADBannerViewDelegate>

@property (nonatomic, weak) IBOutlet UITextView *statusTextView;
@property (nonatomic, weak) IBOutlet UIView *mpuView;
@property (nonatomic, weak) IBOutlet UIView *smallBannerView;

@property (nonatomic,assign) BOOL isMpuLoaded;
@property (nonatomic,assign) BOOL isSmallBannerLoaded;

@property (nonatomic,strong) GADBannerView *smallBanner;
@property (nonatomic,strong) GADBannerView *mpuBanner;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNewStatus:@"Choice Manager Loading..."];
    
    //The setup of Ogury Choice Manager is done AppDelegate file.
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
    self.mpuBanner = [[GADBannerView alloc]initWithAdSize:kGADAdSizeMediumRectangle];
    self.mpuBanner.adUnitID = @"admob_adunit";
    self.mpuBanner.delegate = self;
    self.mpuBanner.rootViewController = self;
    [self.mpuBanner loadRequest:[GADRequest new]];
}

- (IBAction)loadSmallBannerBtnPressed:(id)sender {
    [self addNewStatus:@"Small Banner Loading ..."];
    self.smallBanner = [[GADBannerView alloc]initWithAdSize:kGADAdSizeBanner];
    self.smallBanner.adUnitID = @"admob_adunit";
    self.smallBanner.delegate = self;
    self.smallBanner.rootViewController = self;
    [self.smallBanner loadRequest:[GADRequest new]];
}

- (IBAction)showMPUBtnPressed:(id)sender {
    if (self.isMpuLoaded == YES) {
        [self addNewStatus:@"MPU requested to show"];
        [self.mpuView addSubview:self.mpuBanner];
    } else {
        [self addNewStatus:@"MPU not loaded"];
    }

}

- (IBAction)showSmallBannerBtnPressed:(id)sender {
    if (self.isSmallBannerLoaded == YES) {
        [self addNewStatus:@"Small Banner requested to show"];
        [self.smallBannerView addSubview:self.smallBanner];
    } else {
        [self addNewStatus:@"Small Banner not loaded"];
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
            [self addNewStatus:@"Small Banner Ad received"];
            self.isSmallBannerLoaded = YES;
        } else if (bannerView == self.mpuBanner){
            [self addNewStatus:@"MPU Banner Ad received"];
            self.isMpuLoaded = YES;
        }
}

- (void)bannerViewWillPresentScreen:(GADBannerView *)bannerView {
        if (bannerView == self.smallBanner) {
            [self addNewStatus:@"Small Banner on screen"];
        } else if (bannerView == self.mpuBanner){
            [self addNewStatus:@"MPU Banner on screen"];
        }
}

- (void)bannerView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(NSError *)error {
    if (bannerView == self.smallBanner) {
        [self addNewStatus:[NSString stringWithFormat:@"Small Banner Error: %@", error.localizedDescription]];
    } else if (bannerView == self.mpuBanner){
        [self addNewStatus:[NSString stringWithFormat:@"MPU Banner Error: %@", error.localizedDescription]];
    }
}

@end
