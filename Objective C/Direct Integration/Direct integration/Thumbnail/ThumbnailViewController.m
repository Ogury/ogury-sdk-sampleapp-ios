//
//  ThumbnailViewController.m
//  Direct integration
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//


#import "ThumbnailViewController.h"
#import "BlackListViewController.h"
#import "Constants.h"
#import <OguryAds/OguryAds.h>


@interface ThumbnailViewController()<OguryThumbnailAdDelegate>

@property (nonatomic, weak) IBOutlet UITextView *statusTextView;
@property (nonatomic, strong) OguryThumbnailAd *thumbnail;
@property (nonatomic, assign) BOOL isAdLoaded;

@end

@implementation ThumbnailViewController

/*
    Don't forget to do the set up of OgurySdk,
        in this sample the set up is done in AppDelegate.m
    On needs, replace the bundle id in the project settings and the ad unit by your Ogury ad unit
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    self.thumbnail = [[OguryThumbnailAd alloc]initWithAdUnitId: Thumbnail_adunit];
    self.thumbnail.delegate = self;
    [self.thumbnail setWhitelistBundleIdentifiers:@[@"com.example.bundle",@"com.example.bundle2"]];// Extenal bundle where thumbnail is allowed to show
    [self.thumbnail setBlacklistViewControllers:@[NSStringFromClass([BlackListViewController class])]];// Blacklisted
}

- (IBAction)loadAdBtnPressed:(id)sender {
    [self addNewStatus: @"Loading Ad..."];

    [self.thumbnail load];
}

- (IBAction)showAdBtnPressed:(id)sender {
    if (self.isAdLoaded == YES) {
        [self addNewStatus: @"[OguryAds][Thumbnail] Ad requested to show"];
        [self.thumbnail show];
    } else {
        [self addNewStatus: @"[OguryAds][Thumbnail] Ad not loaded"];
    }
}


- (void)addNewStatus:(NSString *)status {
    NSString *statusLog = [status stringByAppendingString:@"\n"];
    self.statusTextView.text = [self.statusTextView.text stringByAppendingString:statusLog];
    NSRange bottom = NSMakeRange(self.statusTextView.text.length-1, 1);
    [self.statusTextView scrollRangeToVisible:bottom];
}

#pragma mark - OguryAds Delegate

- (void)didLoadOguryThumbnailAd:(OguryThumbnailAd *)thumbnail {
    [self addNewStatus: @"[OguryAds][Thumbnail] Ad loaded"];
    self.isAdLoaded = YES;
}

- (void)didDisplayOguryThumbnailAd:(OguryThumbnailAd *)thumbnail {
    [self addNewStatus: @"[OguryAds][Thumbnail] Ad displayeds"];
}

- (void)didClickOguryThumbnailAd:(OguryThumbnailAd *)thumbnail {
    [self addNewStatus: @"[OguryAds][Thumbnail] Ad clicked"];
}

- (void)didCloseOguryThumbnailAd:(OguryThumbnailAd *)thumbnail {
    [self addNewStatus: @"[OguryAds][Thumbnail] Ad closed"];
    self.isAdLoaded = NO;
}

- (void)didTriggerImpressionOguryThumbnailAd:(OguryThumbnailAd *)thumbnail {
    [self addNewStatus: @"[OguryAds][Thumbnail] Ad on impression"];

}

- (void)didFailOguryThumbnailAdWithError:(OguryError *)error forAd:(OguryThumbnailAd *)thumbnail {
    [self addNewStatus: [NSString stringWithFormat:@"[OguryAds][Thumbnail] Ad error : %ld", error.code]];
    self.isAdLoaded = NO;
}

@end
