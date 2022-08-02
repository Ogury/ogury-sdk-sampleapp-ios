//
//  OptinViewController.m
//  Admob integration
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

#import "OptinViewController.h"
#import "Constants.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface OptinViewController()<GADFullScreenContentDelegate>

@property (nonatomic, weak) IBOutlet UITextView *statusTextView;
@property (nonatomic, strong) GADRewardedAd * rewardedAd;
@property (nonatomic, assign) BOOL isAdLoaded;

@end

@implementation OptinViewController

/*
    It's recommended to set up OgurySdk earlier to accelerate the load & impression process,
        in this sample the set up is done in AppDelegate.m
    On needs, replace the bundle id in the project settings and the ad unit by your Google ad unit
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)loadAdBtnPressed:(id)sender {
    [self addNewStatus: @"[Admob][Optin] Loading Ad..."];
    
    GADRequest *request = [GADRequest request];
    [GADRewardedAd loadWithAdUnitID: Admob_optin_adunit request:request completionHandler:^(GADRewardedAd *ad, NSError *error) {
          if (error) {
              [self addNewStatus: [NSString stringWithFormat:@"[Admob][Optin] Rewarded ad failed to load with error: %@", [error localizedDescription]]];
            return;
          }
        self.rewardedAd = ad;
        self.rewardedAd.fullScreenContentDelegate = self;
        self.isAdLoaded = YES;
        [self addNewStatus: @"[Admob][Optin] Ad received"];
    }];
}

- (IBAction)showAdBtnPressed:(id)sender {
    if (self.isAdLoaded == YES) {
        [self addNewStatus: @"[Admob][Optin] Ad requested to show"];
        [self.rewardedAd presentFromRootViewController:self userDidEarnRewardHandler:^{
            GADAdReward *reward = self.rewardedAd.adReward;
            [self addNewStatus: [NSString stringWithFormat:@"[Admob][Optin] received reward of type: %@, amount %@", reward.type, reward.amount]];
        }];
    } else {
        [self addNewStatus: @"[Admob][Optin] Ad not loaded"];

    }
    
}

- (void)addNewStatus:(NSString *)status {
    NSString *statusLog = [status stringByAppendingString:@"\n"];
    self.statusTextView.text = [self.statusTextView.text stringByAppendingString:statusLog];
    NSRange bottom = NSMakeRange(self.statusTextView.text.length-1, 1);
    [self.statusTextView scrollRangeToVisible:bottom];
}


#pragma mark - AdMob Delegate

/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad
    didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
    [self addNewStatus: @"[Admob][Optin] Ad did fail to present full screen content."];
}

/// Tells the delegate that the ad presented full screen content.
- (void)adWillPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    [self addNewStatus: @"[Admob][Optin] Ad will present full screen content."];
}

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    [self addNewStatus: @"[Admob][Optin] Ad did dismiss full screen content."];
}

@end
