//
//  ViewController.m
//  InterstitialExample
//
//  Copyright © 2021 Ogury Co. All rights reserved.
//

#import "ViewController.h"
#import <OguryChoiceManager/OguryChoiceManager.h>
#import <MoPubSDK/MoPub.h>

@interface ViewController () <MPRewardedAdsDelegate>

@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, assign) BOOL isAdLoaded;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.statusLabel.text = @"Choice Manager Loading...";
    
    //The setup of Ogury Choice Manager is done AppDelegate file.
    [[OguryChoiceManager sharedManager] askWithViewController:self andCompletionBlock:^(NSError * _Nullable error, OguryChoiceManagerAnswer answer) {
        if (!error) {
            switch (answer) {
                case OguryChoiceManagerAnswerNoAnswer:
                    self.statusLabel.text = @"Choice Manager No Answer";
                    break;
                case OguryChoiceManagerAnswerFullApproval: // TCF Option
                    self.statusLabel.text = @"Choice Manager Full Approval";
                    break;
                case OguryChoiceManagerAnswerPartialApproval: // TCF Option
                    self.statusLabel.text = @"Choice Manager Partial Approval";
                    break;
                case OguryChoiceManagerAnswerRefusal: // TCF Option
                    self.statusLabel.text = @"Choice Manager Refusal";
                    break;
                case OguryChoiceManagerAnswerSaleAllowed: // CCPA Option
                    self.statusLabel.text = @"Choice Manager Sale Allowed";
                    break;
                case OguryChoiceManagerAnswerSaleDenied: // CCPA Option
                    self.statusLabel.text = @"Choice Manager Unknown Option";
                    break;
            }
        } else {
            self.statusLabel.text = [NSString stringWithFormat:@"Choice Manager error : %@", error.description];
        }
    }];
}

- (IBAction)loadAdBtnPressed:(id)sender {
    self.statusLabel.text = @"Loading Ad...";
    [MPRewardedAds setDelegate:self forAdUnitId:@"ef93d42cfed24a23b76091f5ecb5c871"];
    [MPRewardedAds loadRewardedAdWithAdUnitID:@"ef93d42cfed24a23b76091f5ecb5c871" withMediationSettings:@[]];
}

- (IBAction)showAdBtnPressed:(id)sender {
    if (self.isAdLoaded == YES) {
        self.statusLabel.text = @"Ad requested to show";
        [MPRewardedAds presentRewardedAdForAdUnitID:@"ef93d42cfed24a23b76091f5ecb5c871" fromViewController:self withReward:nil];
    }
}

#pragma mark - OguryAds Delegate

- (void)rewardedAdDidLoadForAdUnitID:(NSString *)adUnitID {
    self.statusLabel.text = @"Ad loaded";
    self.isAdLoaded = YES;
}

- (void)rewardedAdDidFailToLoadForAdUnitID:(NSString *)adUnitID error:(NSError *)error {
    self.statusLabel.text = [NSString stringWithFormat:@"Error: %@ ",error.description];
    self.isAdLoaded = NO;
}

- (void)rewardedAdDidPresentForAdUnitID:(NSString *)adUnitID {
    NSLog(@"rewardedAdDidPresentForAdUnitID");
}

- (void)rewardedAdDidDismissForAdUnitID:(NSString *)adUnitID {
    self.statusLabel.text = @"Ad not loaded";
    self.isAdLoaded = NO;
}

- (void)rewardedAdShouldRewardForAdUnitID:(NSString *)adUnitID reward:(MPReward *)reward {
    NSLog(@"Reward received : Type : %@ | Amount : %@", reward.currencyType, reward.amount);
}

@end
