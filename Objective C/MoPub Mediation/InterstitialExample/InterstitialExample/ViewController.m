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

@property (nonatomic, weak) IBOutlet UITextView *statusTextView;
@property (nonatomic, strong) MPInterstitialAdController *interstitial;
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
    self.interstitial = [MPInterstitialAdController interstitialAdControllerForAdUnitId:@"mopub_adunit"];
    self.interstitial.delegate = self;
    [self.interstitial loadAd];
}

- (IBAction)showAdBtnPressed:(id)sender {
    if (self.isAdLoaded == YES) {
        [self addNewStatus: @"Ad requested to show"];
        [self.interstitial showFromViewController:self];
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


#pragma mark - MoPub Delegate
- (void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial {
    [self addNewStatus: @"Ad received"];
    self.isAdLoaded = YES;
}

- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial withError:(NSError *)error {
    [self addNewStatus: [NSString stringWithFormat:@"Error: %@",error.description]];
}

- (void)interstitialDidPresent:(MPInterstitialAdController *)interstitial {
    [self addNewStatus: @"Interstitial did present"];
}

- (void)interstitialDidDismiss:(MPInterstitialAdController *)interstitial {
    [self addNewStatus: @"Ad not loaded"];
    self.isAdLoaded = NO;
}

- (void)interstitialDidReceiveTapEvent:(MPInterstitialAdController *)interstitial {
    [self addNewStatus: @"interstitialDidReceiveTapEvent"];
}

@end
