//
//  ViewController.m
//  InterstitialExample
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

#import "ViewController.h"
#import <OguryChoiceManager/OguryChoiceManager.h>
#import <MoPubSDK/MoPub.h>

@interface ViewController () <MPRewardedAdsDelegate>

@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, assign) BOOL isAdLoaded;

@end

@implementation ViewController


- (void) addStatus: (NSString*)string {
    NSMutableString *tmp = [[NSString stringWithFormat:@"%@\n%@", self.statusLabel.text, string] mutableCopy];

    if ([[tmp componentsSeparatedByString:@"\n"] count] > 6) {
        NSRange range = [tmp rangeOfString:@"\n"];
        tmp = [[tmp substringFromIndex: range.location + 1] mutableCopy];
    }
    self.statusLabel.text = tmp;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addStatus:  @"Choice Manager Loading..."];

    //The setup of Ogury Choice Manager is done AppDelegate file.
    [[OguryChoiceManager sharedManager] askWithViewController:self andCompletionBlock:^(NSError * _Nullable error, OguryChoiceManagerAnswer answer) {
        if (!error) {
            switch (answer) {
                case OguryChoiceManagerAnswerNoAnswer:
                    [self addStatus:@"Choice Manager No Answer"];
                    break;
                case OguryChoiceManagerAnswerFullApproval: // TCF Option
                    [self addStatus: @"Choice Manager Full Approval"];
                    break;
                case OguryChoiceManagerAnswerPartialApproval: // TCF Option
                    [self addStatus: @"Choice Manager Partial Approval"];
                    break;
                case OguryChoiceManagerAnswerRefusal: // TCF Option
                    [self addStatus: @"Choice Manager Refusal"];
                    break;
                case OguryChoiceManagerAnswerSaleAllowed: // CCPA Option
                    [self addStatus: @"Choice Manager Sale Allowed"];
                    break;
                case OguryChoiceManagerAnswerSaleDenied: // CCPA Option
                    [self addStatus: @"Choice Manager Unknown Option"];
                    break;
            }
        } else {
            [self addStatus: [NSString stringWithFormat:@"Choice Manager error : %@", error.description]];
        }
    }];
}

- (IBAction)loadAdBtnPressed:(id)sender {
    [self addStatus: @"Loading Ad..."];
    [MPRewardedAds setDelegate:self forAdUnitId:@"ebfc19b6252649ef9f77520a5ac85531"];
    [MPRewardedAds loadRewardedAdWithAdUnitID:@"ebfc19b6252649ef9f77520a5ac85531" withMediationSettings:nil];
}

- (IBAction)showAdBtnPressed:(id)sender {
    if (self.isAdLoaded == YES) {
        [self addStatus: @"Ad requested to show"];
        [MPRewardedAds presentRewardedAdForAdUnitID:@"ebfc19b6252649ef9f77520a5ac85531" fromViewController:self withReward:nil];
    }
}

#pragma mark - OguryAds Delegate


- (void)rewardedAdDidLoadForAdUnitID:(NSString *)adUnitID {
    [self addStatus: @"Ad loaded"];
    self.isAdLoaded = YES;
}

- (void)rewardedAdDidFailToLoadForAdUnitID:(NSString *)adUnitID error:(NSError *)error{
    [self addStatus: [NSString stringWithFormat:@"Error: %@ ",error.description]];
    self.isAdLoaded = NO;
}

- (void)rewardedAdDidPresentForAdUnitID:(NSString *)adUnitID{
    NSLog(@"rewardedVideoAdDidAppear");
}

- (void)rewardedAdDidDismissForAdUnitID:(NSString *)adUnitID {
    [self addStatus: @"Ad not loaded"];
    self.isAdLoaded = NO;
}

- (void)rewardedAdShouldRewardForAdUnitID:(NSString *)adUnitID reward:(MPReward *)reward {
    NSLog(@"Reward received : Type : %@ | Amount : %@", reward.currencyType, reward.amount);
}

@end
