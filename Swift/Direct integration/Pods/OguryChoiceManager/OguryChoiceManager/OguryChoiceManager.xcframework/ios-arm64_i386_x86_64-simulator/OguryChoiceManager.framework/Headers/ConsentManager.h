//
//  ConsentManager.h
//  OguryChoiceManager
//
//  Copyright © 2018 Ogury Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>
#import "OGYConstants.h"

NS_ASSUME_NONNULL_BEGIN

__attribute__((deprecated("Use OguryChoiceManager class")))
@interface ConsentManager : NSObject

+ (ConsentManager*)sharedManager;

-(void)askWithViewController:(UIViewController *)viewController assetKey:(NSString *)assetKey andCompletionBlock:(AskConsentCompletionBlock)completionBlock;
-(void)editWithViewController:(UIViewController *)viewController assetKey:(NSString *)assetKey andCompletionBlock:(AskConsentCompletionBlock)completionBlock;
-(NSString *)getIABConsentString;
-(BOOL)isPurposeAccepted:(ConsentManagerPurpose)purpose;
-(BOOL)isSpecialFeatureAccepted:(ConsentManagerSpecialFeature)specialFeature;
-(BOOL)isAccepted:(NSString *)slug;
-(NSString *)consentSDKVersion;
-(BOOL)gdprApplies;
-(BOOL)hasPaid;
-(BOOL)editAvailable;
-(void)restorePurchases;

@end

NS_ASSUME_NONNULL_END
