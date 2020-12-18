//
//  ViewController.m
//  InterstitialExample
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

#import "ViewController.h"
#import <OguryChoiceManager/OguryChoiceManager.h>
#import <OguryAds/OguryAds.h>

@interface ViewController()<OguryAdsInterstitialDelegate>

@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) OguryAdsInterstitial *interstitial;
@property (nonatomic, assign) BOOL isAdLoaded;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.statusLabel.text = @"Choice Manager Loading...";
    
    //The setup of Ogury Choice Manager and Ogury Ads is done AppDelegate file.
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
    // Do any additional setup after loading the view.
}

- (IBAction)loadAdBtnPressed:(id)sender {
    self.statusLabel.text = @"Loading Ad...";
    self.interstitial = [[OguryAdsInterstitial alloc]initWithAdUnitID:@"cdab8440-4a9d-0138-0f05-0242ac120004_test"];
    self.interstitial.interstitialDelegate = self;
    [self.interstitial load];
}

- (IBAction)showAdBtnPressed:(id)sender {
    if (self.isAdLoaded == YES) {
        self.statusLabel.text = @"Ad requested to show";
        [self.interstitial showAdInViewController:self];
    }
}

#pragma mark - OguryAds Delegate

- (void)oguryAdsInterstitialAdLoaded {
    self.statusLabel.text = @"Ad received";
    self.isAdLoaded = YES;
}

- (void)oguryAdsInterstitialAdClosed {
    self.statusLabel.text = @"Ad Closed";
    self.isAdLoaded = NO;
}

- (void)oguryAdsInterstitialAdDisplayed {
    self.statusLabel.text = @"Ad on screen";
}

- (void)oguryAdsInterstitialAdClicked {
    self.statusLabel.text = @"Ad Clicked";
}

- (void)oguryAdsInterstitialAdNotAvailable {
    self.statusLabel.text = @"Ad Not Available";
}

- (void)oguryAdsInterstitialAdError:(OguryAdsErrorType)errorType {
    self.statusLabel.text = [NSString stringWithFormat:@"Error : %ld", errorType];
    self.isAdLoaded = NO;
}

@end
