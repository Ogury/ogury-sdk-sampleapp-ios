//
//  ViewController.m
//  BannerExample
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

#import "ViewController.h"
#import <OguryChoiceManager/OguryChoiceManager.h>
#import <MoPubSDK/MoPub.h>

@interface ViewController ()<MPAdViewDelegate>

@property (nonatomic, weak) IBOutlet UITextView *statusTextView;
@property (nonatomic, weak) IBOutlet UIView *mpuView;
@property (nonatomic, weak) IBOutlet UIView *smallBannerView;

@property (nonatomic, assign) BOOL isMpuLoaded;
@property (nonatomic, assign) BOOL isSmallBannerLoaded;

@property (nonatomic,strong) MPAdView *smallBanner;
@property (nonatomic,strong) MPAdView *mpuBanner;

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
    self.mpuBanner = [[MPAdView alloc] initWithAdUnitId:@"a4593fc7714d49c682a00cbd512bd711"];
    self.mpuBanner.delegate = self;
    self.mpuBanner.frame = CGRectMake(0, 0, self.mpuView.frame.size.width, self.mpuView.frame.size.height);
    [self.mpuBanner loadAdWithMaxAdSize:CGSizeMake(self.mpuView.frame.size.width, self.mpuView.frame.size.height)];
}

- (IBAction)loadSmallBannerBtnPressed:(id)sender {
    [self addNewStatus:@"Small Banner Loading ..."];
    self.smallBanner = [[MPAdView alloc] initWithAdUnitId:@"3816a61b79794ab6bc1cd6713d5b42c0"];
    self.smallBanner.delegate = self;
    self.smallBanner.frame = CGRectMake(0, 0, self.smallBannerView.frame.size.width, self.smallBannerView.frame.size.height);
    [self.smallBanner loadAdWithMaxAdSize:CGSizeMake(self.smallBannerView.frame.size.width, self.smallBannerView.frame.size.height)];
}

- (IBAction)showMPUBtnPressed:(id)sender {
    if (self.isMpuLoaded == YES) {
        [self addNewStatus:@"MPU requested to show"];
        [self.mpuView addSubview:self.mpuBanner];
    }
}

- (IBAction)showSmallBannerBtnPressed:(id)sender {
    if (self.isSmallBannerLoaded == YES) {
        [self addNewStatus:@"Small Banner requested to show"];
        [self.smallBannerView addSubview:self.smallBanner];
    }
}

- (void)addNewStatus:(NSString *)status {
    NSString * statusLog = [status stringByAppendingString:@"\n"];
    self.statusTextView.text = [self.statusTextView.text stringByAppendingString:statusLog];
    NSRange bottom = NSMakeRange(self.statusTextView.text.length-1, 1);
    [self.statusTextView scrollRangeToVisible:bottom];
}

#pragma mark - MoPub Delegate

- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}

- (void)adViewDidLoadAd:(MPAdView *)bannerView adSize:(CGSize)adSize {
    if (bannerView == self.smallBanner) {
        [self addNewStatus:@"Small Banner received"];
        self.isSmallBannerLoaded = YES;
    } else if (bannerView == self.mpuBanner){
        [self addNewStatus:@"MPU Banner received"];
        self.isMpuLoaded = YES;
    }
}

- (void)adView:(MPAdView *)bannerView didFailToLoadAdWithError:(NSError *)error {
    if (bannerView == self.smallBanner) {
        [self addNewStatus:[NSString stringWithFormat:@"Small Banner Error: %@",error.description]];
    } else if (bannerView == self.mpuBanner){
        [self addNewStatus:[NSString stringWithFormat:@"MPU Banner Error: %@",error.description]];
    }
}

- (void)willPresentModalViewForAd:(MPAdView *)bannerView {
    if (bannerView == self.smallBanner) {
        [self addNewStatus:@"Small Banner Clicked"];
        self.isSmallBannerLoaded = YES;
    } else if (bannerView == self.mpuBanner){
        [self addNewStatus:@"MPU Banner Clicked"];
        self.isMpuLoaded = YES;
    }
}
@end
