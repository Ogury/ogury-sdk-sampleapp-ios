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

@property (nonatomic, weak) IBOutlet UITextView *statusTextView;
@property (nonatomic, strong) OguryAdsInterstitial *interstitial;
@property (nonatomic, assign) BOOL isAdLoaded;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNewStatus: @"Choice Manager Loading..."];
    
    //The setup of Ogury Choice Manager and Ogury Ads is done AppDelegate file.
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
    // Do any additional setup after loading the view.
}

- (IBAction)loadAdBtnPressed:(id)sender {
    [self addNewStatus: @"Loading Ad..."];
    self.interstitial = [[OguryAdsInterstitial alloc]initWithAdUnitID:@"ogury_adunitt"];
    self.interstitial.interstitialDelegate = self;
    [self.interstitial load];
}

- (IBAction)showAdBtnPressed:(id)sender {
    if (self.isAdLoaded == YES) {
        [self addNewStatus: @"Ad requested to show"];
        [self.interstitial showAdInViewController:self];
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

#pragma mark - OguryAds Delegate

- (void)oguryAdsInterstitialAdLoaded {
    [self addNewStatus: @"Ad received"];
    self.isAdLoaded = YES;
}

- (void)oguryAdsInterstitialAdClosed {
    [self addNewStatus: @"Ad Closed"];
    self.isAdLoaded = NO;
}

- (void)oguryAdsInterstitialAdDisplayed {
    [self addNewStatus: @"Ad on screen"];
}

- (void)oguryAdsInterstitialAdClicked {
    [self addNewStatus: @"Ad Clicked"];
}

- (void)oguryAdsInterstitialAdNotAvailable {
    [self addNewStatus: @"Ad Not Available"];
}

- (void)oguryAdsInterstitialAdError:(OguryAdsErrorType)errorType {
    [self addNewStatus: [NSString stringWithFormat:@"Error : %ld", errorType]];
    self.isAdLoaded = NO;
}

@end
