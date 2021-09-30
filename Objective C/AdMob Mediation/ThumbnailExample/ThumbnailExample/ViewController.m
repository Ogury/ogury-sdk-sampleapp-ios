//
//  ViewController.m
//  ThumbnailExample
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

#import "ViewController.h"
#import "BlackListViewController.h"
#import <OguryChoiceManager/OguryChoiceManager.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface ViewController()<GADBannerViewDelegate>

@property (nonatomic, weak) IBOutlet UITextView *statusTextView;
@property (nonatomic, strong) GADBannerView *thumbnail;
@property (nonatomic, assign) BOOL isAdLoaded;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addNewStatus: @"Choice Manager Loading..."];
    
    //The setup of Ogury Choice Manager is done AppDelegate file.
    [[OguryChoiceManager sharedManager] setupWithAssetKey:@"asset_key"];
    [[OguryChoiceManager sharedManager] askWithViewController:self andCompletionBlock:^(NSError * _Nullable error, OguryChoiceManagerAnswer answer) {
        if (error == nil) {
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
    self.thumbnail = [[GADBannerView alloc] initWithAdSize:GADAdSizeFromCGSize(CGSizeMake(200, 200))];
    self.thumbnail.adUnitID = @"admob_adunit";
    self.thumbnail.delegate = self;
    self.thumbnail.rootViewController = self;
    
    GADRequest * thumbnailRequest = [GADRequest new];
    GADCustomEventExtras * thumbnailExtras = [GADCustomEventExtras new];
    NSArray<NSString*>* whitelist = @[@"com.example.bundle",@"com.example.bundle"]; // Extenal Bundles where thumbnail is allowed to show
    NSArray<NSString*>* blacklist = @[NSStringFromClass([BlackListViewController class])]; // Blacklisted ViewController where thumbnail is not allowed to show
    NSDictionary * extrasParams =@{@"x_margin": @20, @"y_margin": @20, @"rect_corner": @"bottom_right", @"whitelist": whitelist, @"blacklist": blacklist};
    [thumbnailExtras setExtras:extrasParams forLabel:@"OguryThumbnail"];
    [thumbnailRequest registerAdNetworkExtras:thumbnailExtras];
    [self.thumbnail loadRequest:thumbnailRequest];
}

- (IBAction)showAdBtnPressed:(id)sender {
    if (self.isAdLoaded == YES) {
        [self addNewStatus: @"Ad requested to show"];
        [self.view addSubview:self.thumbnail];
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

#pragma mark - AdMob Delegate
- (void)bannerViewDidReceiveAd:(GADBannerView *)bannerView {
    [self addNewStatus: @"Ad received"];
    self.isAdLoaded = YES;
}

- (void)bannerView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(NSError *)error {
    [self addNewStatus: [NSString stringWithFormat:@"Error: %@",error.description]];
}

@end
