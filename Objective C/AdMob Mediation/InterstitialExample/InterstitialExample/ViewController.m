//
//  ViewController.m
//  InterstitialExample
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

#import "ViewController.h"
#import <OguryChoiceManager/OguryChoiceManager.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface ViewController()<GADFullScreenContentDelegate>

@property (nonatomic, weak) IBOutlet UITextView *statusTextView;
@property (nonatomic, strong) GADInterstitialAd *interstitial;
@property (nonatomic, assign) BOOL isAdLoaded;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addNewStatus: @"Choice Manager Loading..."];
    
    //The setup of Ogury Choice Manager is done AppDelegate file.
    [[OguryChoiceManager sharedManager] askWithViewController:self andCompletionBlock:^(NSError * _Nullable error, OguryChoiceManagerAnswer answer) {
        if (!error) {
            switch (answer) {
                case OguryChoiceManagerAnswerNoAnswer:
                    [self addNewStatus: @"Choice Manager No Answer"];
                    break;
                case OguryChoiceManagerAnswerFullApproval: // TCF Option
                     [self addNewStatus: @"Choice Manager Full Approval"];
                    break;
                case OguryChoiceManagerAnswerPartialApproval: // TCF Option
                      [self addNewStatus: @"Choice Manager Partial Approval"];
                    break;
                case OguryChoiceManagerAnswerRefusal: // TCF Option
                       [self addNewStatus: @"Choice Manager Refusal"];
                    break;
                case OguryChoiceManagerAnswerSaleAllowed: // CCPA Option
                        [self addNewStatus: @"Choice Manager Sale Allowed"];
                    break;
                case OguryChoiceManagerAnswerSaleDenied: // CCPA Option
                         [self addNewStatus: @"Choice Manager Unknown Option"];
                    break;
            }
        } else {
            [self addNewStatus: [NSString stringWithFormat:@"Choice Manager error : %@", error.description]];
        }
    }];
}

- (IBAction)loadAdBtnPressed:(id)sender {
    [self addNewStatus: @"Loading Ad..."];
    
    GADRequest *request = [GADRequest request];
    [GADInterstitialAd loadWithAdUnitID:@"admob_adunit"
                                request:request
                      completionHandler:^(GADInterstitialAd *ad, NSError *error) {
        if (error) {
            NSLog(@"Failed to load interstitial ad with error: %@", [error localizedDescription]);
            return;
        }
        self.interstitial = ad;
        self.interstitial.fullScreenContentDelegate = self;
        self.isAdLoaded = YES;
        [self addNewStatus: @"Ad loaded"];
    }];

}

- (IBAction)showAdBtnPressed:(id)sender {
    if (self.isAdLoaded == YES) {
        [self addNewStatus: @"Ad requested to show"];
        [self.interstitial presentFromRootViewController:self];
    } else {
        [self addNewStatus: @"Ad not loaded"];
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
    [self addNewStatus: @"Ad did fail to present full screen content."];
}

/// Tells the delegate that the ad presented full screen content.
- (void)adDidPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    [self addNewStatus: @"Ad did present full screen content."];
}

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    [self addNewStatus: @"Ad did dismiss full screen content."];
    self.isAdLoaded = NO;
}

@end
