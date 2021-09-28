//
//  ViewController.m
//  InterstitialExample
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

#import "ViewController.h"
#import <OguryChoiceManager/OguryChoiceManager.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface ViewController()<GADRewardedAdDelegate>

@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) GADRewardedAd * rewardedAd;
@property (nonatomic, assign) BOOL isAdLoaded;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.statusLabel.text = @"Choice Manager Loading...";
    
    //The setup of Ogury Choice Manager is done AppDelegate file.
    [[OguryChoiceManager sharedManager] setupWithAssetKey:@"asset_key"];
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
    self.rewardedAd = [[GADRewardedAd alloc] initWithAdUnitID:@"admob_adunit"];
    [self.rewardedAd loadRequest:[GADRequest new] completionHandler:^(GADRequestError * _Nullable error) {
        if (error) {
            self.statusLabel.text = [NSString stringWithFormat:@"Error: %@",error.description];
        } else {
            self.statusLabel.text = @"Ad received";
            self.isAdLoaded = YES;
        }
    }];
}

- (IBAction)showAdBtnPressed:(id)sender {
    if (self.isAdLoaded == YES) {
        self.statusLabel.text = @"Ad requested to show";
        [self.rewardedAd presentFromRootViewController:self delegate:self];
    }
    
}

#pragma mark - AdMob Delegate
- (void)rewardedAd:(nonnull GADRewardedAd *)rewardedAd userDidEarnReward:(nonnull GADAdReward *)reward {
    NSLog(@"Reward received with type: %@ and amount : %@",reward.type ,reward.amount);
}

- (void)rewardedAdDidPresent:(GADRewardedAd *)rewardedAd {
    self.statusLabel.text = @"Ad on screen";
}

- (void)rewardedAdDidDismiss:(GADRewardedAd *)rewardedAd {
    self.statusLabel.text = @"Ad not loaded";
}

- (void)rewardedAd:(GADRewardedAd *)rewardedAd didFailToPresentWithError:(NSError *)error {
    self.statusLabel.text = [NSString stringWithFormat:@"Error: %@",error.description];
}



@end
