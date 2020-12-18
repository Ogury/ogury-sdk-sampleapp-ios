//
//  ViewController.m
//  InterstitialExample
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

#import "ViewController.h"
#import <OguryChoiceManager/OguryChoiceManager.h>
#import <MoPub/MoPub.h>

@interface ViewController () <MPInterstitialAdControllerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) MPInterstitialAdController *interstitial;
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
    self.interstitial = [MPInterstitialAdController interstitialAdControllerForAdUnitId:@"de5cb2a3b2bc4d5cb6c97a89be556a6f"];
    self.interstitial.delegate = self;
    [self.interstitial loadAd];
}

- (IBAction)showAdBtnPressed:(id)sender {
    if (self.isAdLoaded == YES) {
        self.statusLabel.text = @"Ad requested to show";
        [self.interstitial showFromViewController:self];
    }
    
}

#pragma mark - MoPub Delegate
- (void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial {
    self.statusLabel.text = @"Ad received";
    self.isAdLoaded = YES;
}

- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial withError:(NSError *)error {
    self.statusLabel.text = [NSString stringWithFormat:@"Error: %@",error.description];
}

- (void)interstitialDidAppear:(MPInterstitialAdController *)interstitial {
    NSLog(@"interstitialDidAppear");
}

- (void)interstitialDidDisappear:(MPInterstitialAdController *)interstitial {
    self.statusLabel.text = @"Ad not loaded";
    self.isAdLoaded = NO;
}

- (void)interstitialDidReceiveTapEvent:(MPInterstitialAdController *)interstitial {
    NSLog(@"interstitialDidReceiveTapEvent");
}

@end
