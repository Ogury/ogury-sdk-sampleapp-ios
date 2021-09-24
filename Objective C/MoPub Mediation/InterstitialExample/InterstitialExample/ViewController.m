//
//  ViewController.m
//  InterstitialExample
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

#import "ViewController.h"
#import <OguryChoiceManager/OguryChoiceManager.h>
#import <MoPubSDK/MoPub.h>

@interface ViewController () <MPInterstitialAdControllerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) MPInterstitialAdController *interstitial;
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

    [self addStatus: @"Choice Manager Loading..."];
    //The setup of Ogury Choice Manager is done AppDelegate file.
    [[OguryChoiceManager sharedManager] askWithViewController:self andCompletionBlock:^(NSError * _Nullable error, OguryChoiceManagerAnswer answer) {
        if (!error) {
            switch (answer) {
                case OguryChoiceManagerAnswerNoAnswer:
                    [self addStatus: @"Choice Manager No Answer"];
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
    self.interstitial = [MPInterstitialAdController interstitialAdControllerForAdUnitId:@"4a0c441a9c6c4990982c36dfc5e72508"];
    self.interstitial.delegate = self;
    [self.interstitial loadAd];
}

- (IBAction)showAdBtnPressed:(id)sender {
    if (self.isAdLoaded == YES) {
        [self addStatus: @"Ad requested to show"];
        [self.interstitial showFromViewController:self];
    }
    
}

#pragma mark - MoPub Delegate
- (void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial {
    [self addStatus: @"Ad received"];
    self.isAdLoaded = YES;
}

- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial withError:(NSError *)error {
    [self addStatus: [NSString stringWithFormat:@"Error: %@",error.description]];
}

- (void)interstitialDidPresent:(MPInterstitialAdController *)interstitial {
    [self addStatus: @"Interstitial did present"];
}

- (void)interstitialDidDismiss:(MPInterstitialAdController *)interstitial {
    [self addStatus: @"Ad not loaded"];
    self.isAdLoaded = NO;
}

- (void)interstitialDidReceiveTapEvent:(MPInterstitialAdController *)interstitial {
    NSLog(@"interstitialDidReceiveTapEvent");
}

@end
