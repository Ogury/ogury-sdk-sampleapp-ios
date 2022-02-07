//
//  InterstitialViewController.m
//  Direct integration
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

#import "InterstitialViewController.h"
#import "Constants.h"
#import <OguryAds/OguryAds.h>

@interface InterstitialViewController()<OguryInterstitialAdDelegate>

@property (nonatomic, weak) IBOutlet UITextView *statusTextView;
@property (nonatomic, strong) OguryInterstitialAd *interstitial;
@property (nonatomic, assign) BOOL isAdLoaded;

@end

@implementation InterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interstitial = [[OguryInterstitialAd alloc] initWithAdUnitId: Interstitial_adunit];
    self.interstitial.delegate = self;
    // Do any additional setup after loading the view.
}

- (IBAction)loadAdBtnPressed:(id)sender {
    [self addNewStatus: @"[OguryAds][Interstitial] Loading ..."];
    [self.interstitial load];
}

- (IBAction)showAdBtnPressed:(id)sender {
    [self addNewStatus: @"[OguryAds][Interstitial] Requested to show"];
    [self.interstitial showAdInViewController:self];
}

- (void)addNewStatus:(NSString *)status {
    NSString * statusLog = [status stringByAppendingString:@"\n"];
    self.statusTextView.text = [self.statusTextView.text stringByAppendingString:statusLog];
    NSRange bottom = NSMakeRange(self.statusTextView.text.length-1, 1);
    [self.statusTextView scrollRangeToVisible:bottom];
}

#pragma mark - OguryAds Delegate

- (void)didLoadOguryInterstitialAd:(OguryInterstitialAd *)interstitial {
    [self addNewStatus: @"[OguryAds][Interstitial] Ad loaded"];
}

- (void)didDisplayOguryInterstitialAd:(OguryInterstitialAd *)interstitial {
    [self addNewStatus: @"[OguryAds][Interstitial] Ad displayed"];
}

- (void)didClickOguryInterstitialAd:(OguryInterstitialAd *)interstitial {
    [self addNewStatus: @"[OguryAds][Interstitial] Ad clicked"];
}

- (void)didCloseOguryInterstitialAd:(OguryInterstitialAd *)interstitial {
    [self addNewStatus: @"[OguryAds][Interstitial] Ad closed"];
}

- (void)didTriggerImpressionOguryInterstitialAd:(OguryInterstitialAd *)interstitial {
    [self addNewStatus: @"[OguryAds][Interstitial] Ad on impression"];

}

- (void)didFailOguryInterstitialAdWithError:(OguryError *)error forAd:(OguryInterstitialAd *)interstitial {
    [self addNewStatus: [NSString stringWithFormat:@"[OguryAds][Interstitial] Ad error: %ld", error.code]];
    [self addNewStatus: @"For more informations about error codes please refer to our documentation at https://docs.ogury.co/"];
    self.isAdLoaded = NO;
}


@end
