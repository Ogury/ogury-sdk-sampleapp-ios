//
//  OguryChoiceManagerTCFV1.h
//  OguryChoiceManager
//
//  Copyright © 2020 Ogury Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OGYConstants.h"
NS_ASSUME_NONNULL_BEGIN

__attribute__((deprecated("Use OguryChoiceManagerTCFV2 class")))
@interface OguryChoiceManagerTCFV1 : NSObject

/*!
* @brief Transmit the IAB string
* @discussion While being registered to the IAB TCF, some vendors need to explicitly receive the IAB string. Check with your vendors to ensure that they process the consent signal by themselves. Otherwise, you can use the this method to obtain and pass the IAB string
* @warning We recommend to use this method only in the completion block of the ask and edit methods to get the updated value of the consent signal.
* @return String value of IAB Consent String
*/
-(NSString *)getIABConsentString;

/*!
* @brief Transmit purpose-specific consent status
* @discussion Similarly to vendors, you can access consent status for each IAB purposes, and pass this signal to your vendors and your own processes accordingly. Users can consent to all purposes at once or opt-in to only a few of them
* @warning We recommend to use this method only in the completion block of the ask and edit methods to get the updated value of the consent signal.
* @param purpose a ConsentManagerPurpose representing one of the enums value
* @return true if the specified purpose is accepted and false if not
*/
-(BOOL)isPurposeAccepted:(ConsentManagerPurpose)purpose;

/*!
* @brief Precise Geographic Location Data Feature
* @discussion Similarly to vendors, you can access consent status for each IAB special feature, and pass this signal to your vendors and your own processes accordingly. Users can consent to all  special features at once or opt-in to only a few of them
* @warning We recommend to use this method only in the completion block of the ask and edit methods to get the updated value of the consent signal.
* @param specialFeature a ConsentManagerSpecialFeature representing one of the enums value
* @return true if the specified special feature is accepted and false if not
*/
-(BOOL)isSpecialFeatureAccepted:(ConsentManagerSpecialFeature)specialFeature;

/*!
* @brief Transmit vendor-specific consent status
* @discussion Depending on the user consent choices, you may need to enable/disable some functionalities or vendor's SDK. You can check whether the user has accepted the usage of personal data for a particular vendor by calling the following method:
* @warning We recommend to use this method only in the completion block of the ask and edit methods to get the updated value of the consent signal.
* @param slug a String, uniquely identifying each vendor. As an example, the slug is ogury-ltd for Ogury. You can find the list of all slug identifiers in the Ogury Choice Manager vendor list.
* @return true if the vendor is accepted and false if not
*/
-(BOOL)isAccepted:(NSString *)slug;

@end

NS_ASSUME_NONNULL_END
