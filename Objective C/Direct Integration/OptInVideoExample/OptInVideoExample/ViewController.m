//
//  ViewController.m
//  OptInVideoExample
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

#import "ViewController.h"
#import <OguryChoiceManager/OguryChoiceManager.h>
#import <OguryAds/OguryAds.h>

@interface ViewController()<OguryAdsOptinVideoDelegate>

@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) OguryAdsOptinVideo *optinVideo;
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
    self.optinVideo = [[OguryAdsOptinVideo alloc]initWithAdUnitID:@"b1773ac0-4a9d-0138-d91c-0242ac120004_test"];
    self.optinVideo.optInVideoDelegate = self;
    [self.optinVideo load];
}

- (IBAction)showAdBtnPressed:(id)sender {
    if (self.isAdLoaded == YES) {
        self.statusLabel.text = @"Ad requested to show";
        [self.optinVideo showAdInViewController:self];
    }
}

#pragma mark - OguryAds Delegate

- (void)oguryAdsOptinVideoAdLoaded {
    self.statusLabel.text = @"Ad received";
    self.isAdLoaded = YES;
}

- (void)oguryAdsOptinVideoAdClosed {
    self.statusLabel.text = @"Ad Closed";
    self.isAdLoaded = NO;
}

- (void)oguryAdsOptinVideoAdDisplayed {
    self.statusLabel.text = @"Ad on screen";
}

- (void)oguryAdsOptinVideoAdClicked {
    self.statusLabel.text = @"Ad Clicked";
}

- (void)oguryAdsOptinVideoAdNotAvailable {
    self.statusLabel.text = @"Ad Not Available";
}

- (void)oguryAdsOptinVideoAdError:(OguryAdsErrorType)errorType {
    self.statusLabel.text = [NSString stringWithFormat:@"Error : %ld", errorType];
    self.isAdLoaded = NO;
}

- (void)oguryAdsOptinVideoAdRewarded:(OGARewardItem *)item {
    NSLog(@"Reward received with name: : %@ and value : %@", item.rewardName,item.rewardValue);
}


@end
