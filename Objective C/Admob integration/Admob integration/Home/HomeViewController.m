//
//  HomeViewController.m
//  Admob integration
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OguryChoiceManager/OguryChoiceManager.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <OgurySdk/Ogury.h>
#import "HomeViewController.h"
#import "Constants.h"


@interface HomeViewController()

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *consentLabel;

- (void)handleConsentCallBack:(OguryChoiceManagerAnswer)answer error:(NSError* _Nullable)error;

@end

@implementation HomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _versionLabel.text = [NSString stringWithFormat:@"OgurySdk versions:%@\
                                                    \nGoogleMobileAds version:%s",
                          Ogury.getSdkVersion,
                          GoogleMobileAdsVersionString];
    [_consentLabel setHidden:true];
}

- (IBAction)askUserConsent:(id)sender {
    //The setup of Ogury Choice Manager and Ogury Ads is done AppDelegate file.
    [[OguryChoiceManager sharedManager] askWithViewController:self andCompletionBlock:^(NSError * _Nullable error, OguryChoiceManagerAnswer answer) {
        [self handleConsentCallBack:answer error:error];
    }];
}

- (IBAction)editUserConsent:(id)sender {
    [[OguryChoiceManager sharedManager] editWithViewController:self andCompletionBlock:^(NSError * _Nullable error, OguryChoiceManagerAnswer answer) {
        [self handleConsentCallBack:answer error:error];
    }];
}



- (void)handleConsentCallBack:(OguryChoiceManagerAnswer)answer error:(NSError* _Nullable)error {
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
}

- (void)addNewStatus:(NSString *)status {
    [_consentLabel setHidden:false];
    _consentLabel.text = status;
}

@end
