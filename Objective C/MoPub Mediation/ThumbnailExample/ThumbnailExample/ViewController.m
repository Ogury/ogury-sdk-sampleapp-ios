//
//  ViewController.m
//  BannerExample
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

#import "ViewController.h"
#import "BlackListViewController.h"
#import <OguryChoiceManager/OguryChoiceManager.h>
#import <MoPubSDK/MoPub.h>

@interface ViewController()<MPAdViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) MPAdView *thumbnail;
@property (nonatomic, assign) BOOL isAdLoaded;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.statusLabel.text = @"Choice Manager Loading...";
    
    //The setup of Ogury Choice Manager and is done AppDelegate file.
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
    self.statusLabel.text = @"Thumbnail Loading ...";
    self.thumbnail = [[MPAdView alloc] initWithAdUnitId:@"b5cabe32c7f741d687d411d5f45ec4e6"];
    self.thumbnail.delegate = self;
    self.thumbnail.maxAdSize = CGSizeMake(200, 200);
    [self.thumbnail stopAutomaticallyRefreshingContents];
    [self.thumbnail setLocalExtras:
     @{
         @"rect_corner": @"bottom_right",
         @"x_margin": @30,
         @"y_margin": @30,
         @"whitelist": @[@"com.example.bundle", @"com.example.bundle2"],
         @"blacklist": @[NSStringFromClass([BlackListViewController class])]
        
     }];
    [self.thumbnail loadAd];
}

- (IBAction)showAdBtnPressed:(id)sender {
    if (self.isAdLoaded == YES) {
        self.statusLabel.text = @"Ad requested to show";
        [self.view addSubview:self.thumbnail];
    }
}

#pragma mark - MoPub Delegate

- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}

- (void)adViewDidLoadAd:(MPAdView *)view adSize:(CGSize)adSize {
    self.statusLabel.text = @"Ad received";
    self.isAdLoaded = YES;
}

- (void)adView:(MPAdView *)view didFailToLoadAdWithError:(NSError *)error {
    self.statusLabel.text = [NSString stringWithFormat:@"Error %@", error.description];
}

@end
