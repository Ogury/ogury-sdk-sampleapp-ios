//
//  InterstitialViewController.m
//  Admob integration
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

#import "InterstitialViewController.h"
#import "Constants.h"
#import <OguryChoiceManager/OguryChoiceManager.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface InterstitialViewController()<GADFullScreenContentDelegate>

@property (nonatomic, weak) IBOutlet UITextView *statusTextView;
@property (nonatomic, strong) GADInterstitialAd *interstitial;
@property (nonatomic, assign) BOOL isAdLoaded;

@end

@implementation InterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)loadAdBtnPressed:(id)sender {
    [self addNewStatus: @"[Admob][Interstitial] Loading Ad..."];
    
    GADRequest *request = [GADRequest request];
    [GADInterstitialAd loadWithAdUnitID: Admob_interstitial_adunit
                                request:request
                      completionHandler:^(GADInterstitialAd *ad, NSError *error) {
        if (error) {
            NSLog(@"[Admob][Interstitial] Failed to load interstitial ad with error: %@", [error localizedDescription]);
            return;
        }
        self.interstitial = ad;
        self.interstitial.fullScreenContentDelegate = self;
        self.isAdLoaded = YES;
        [self addNewStatus: @"[Admob][Interstitial] Ad loaded"];
    }];

}

- (IBAction)showAdBtnPressed:(id)sender {
    if (self.isAdLoaded == YES) {
        [self addNewStatus: @"[Admob][Interstitial] Ad requested to show"];
        [self.interstitial presentFromRootViewController:self];
    } else {
        [self addNewStatus: @"[Admob][Interstitial] Ad not loaded"];
    }
}

- (void)addNewStatus:(NSString *)status {
    NSString * statusLog = [status stringByAppendingString:@"\n"];
    self.statusTextView.text = [self.statusTextView.text stringByAppendingString:statusLog];
    NSRange bottom = NSMakeRange(self.statusTextView.text.length-1, 1);
    [self.statusTextView scrollRangeToVisible:bottom];
}

#pragma mark - AdMob Delegate

/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad didFailToPresentFullScreenContentWithError: (nonnull NSError *)error {
    [self addNewStatus: @"[Admob][Interstitial] Ad did fail to present full screen content."];
}

/// Tells the delegate that the ad presented full screen content.
- (void)adDidPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    [self addNewStatus: @"[Admob][Interstitial] Ad did present full screen content."];
}

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    [self addNewStatus: @"[Admob][Interstitial] Ad did dismiss full screen content."];
    self.isAdLoaded = NO;
}

@end
