//
//  OptinViewController.m
//  Direct integration
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

#import "OptinViewController.h"
#import "Constants.h"
#import <OguryAds/OguryAds.h>

@interface OptinViewController()<OguryOptinVideoAdDelegate>

@property (nonatomic, weak) IBOutlet UITextView *statusTextView;
@property (nonatomic, strong) OguryOptinVideoAd *optinVideo;
@property (nonatomic, assign) BOOL isAdLoaded;

@end

/*
    Don't forget to do the set up of OgurySdk,
        in this sample the set up is done in AppDelegate.m
    On needs, replace the bundle id in the project settings and the ad unit by your Ogury ad unit
 */

@implementation OptinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.optinVideo = [[OguryOptinVideoAd alloc] initWithAdUnitId: Optin_adunit];
    self.optinVideo.delegate = self;
}

- (IBAction)loadAdBtnPressed:(id)sender {
    [self addNewStatus: @"[OguryAds][Optin] Loading Ad..."];
    [self.optinVideo load];
}

- (IBAction)showAdBtnPressed:(id)sender {
    if (self.isAdLoaded == YES) {
        [self addNewStatus: @"[OguryAds][Optin] Ad requested to show"];
        [self.optinVideo showAdInViewController:self];
    } else {
        [self addNewStatus: @"[OguryAds][Optin] Ad not loaded"];
    }
}


- (void)addNewStatus:(NSString *)status {
    NSString *statusLog = [status stringByAppendingString:@"\n"];
    self.statusTextView.text = [self.statusTextView.text stringByAppendingString:statusLog];
    NSRange bottom = NSMakeRange(self.statusTextView.text.length-1, 1);
    [self.statusTextView scrollRangeToVisible:bottom];
}

#pragma mark - OguryAds Delegate

- (void)didLoadOguryOptinVideoAd:(OguryOptinVideoAd *)optinVideo {
    [self addNewStatus: @"[OguryAds][Optin] Ad loaded"];
    self.isAdLoaded = YES;
}

- (void)didDisplayOguryOptinVideoAd:(OguryOptinVideoAd *)optinVideo {
    [self addNewStatus: @"[OguryAds][Optin] Ad display"];
}

- (void)didClickOguryOptinVideoAd:(OguryOptinVideoAd *)optinVideo {
    [self addNewStatus: @"[OguryAds][Optin] Ad clicked"];
}

- (void)didCloseOguryOptinVideoAd:(OguryOptinVideoAd *)optinVideo {
    [self addNewStatus: @"[OguryAds][Optin] Ad closed"];
    self.isAdLoaded = NO;
}

- (void)didTriggerImpressionOguryOptinVideoAd:(OguryOptinVideoAd *)optinVideo {
    [self addNewStatus: @"[OguryAds][Optin] Ad on impression"];
}

- (void)didFailOguryOptinVideoAdWithError:(OguryError *)error forAd:(OguryOptinVideoAd *)optinVideo {
    [self addNewStatus: [NSString stringWithFormat:@"[OguryAds][Optin] Ad error : %ld", error.code]];
    self.isAdLoaded = NO;
}

@end
