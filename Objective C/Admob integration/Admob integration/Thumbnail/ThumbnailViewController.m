//
//  ThumbnailViewController.m
//  Admob integration
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//


#import "ThumbnailViewController.h"
#import "BlackListViewController.h"
#import "Constants.h"
#import <GoogleMobileAds/GoogleMobileAds.h>


@interface ThumbnailViewController()<GADBannerViewDelegate>

@property (nonatomic, weak) IBOutlet UITextView *statusTextView;
@property (nonatomic, strong) GADBannerView *thumbnail;
@property (nonatomic, assign) BOOL isAdLoaded;

@end

@implementation ThumbnailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)loadAdBtnPressed:(id)sender {
    [self addNewStatus: @"[Admob][Thumbnail] Loading Ad..."];
    self.thumbnail = [[GADBannerView alloc] initWithAdSize:GADAdSizeFromCGSize(CGSizeMake(200, 200))];
    self.thumbnail.adUnitID = Admob_thumbnail_adunit;
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
        [self addNewStatus: @"[Admob][Thumbnail] Ad requested to show"];
        [self.view addSubview:self.thumbnail];
    } else {
        [self addNewStatus: @"[Admob][Thumbnail] Ad not loaded"];
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
    [self addNewStatus: @"[Admob][Thumbnail] Ad received"];
    self.isAdLoaded = YES;
}

- (void)bannerView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(NSError *)error {
    [self addNewStatus: [NSString stringWithFormat:@"[Admob][Thumbnail] Error: %@",error.description]];
}

@end
