//
//  HomeViewController.swift
//  Admob Integration
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

import UIKit
import OguryAds
import OguryChoiceManager
import GoogleMobileAds

class HomeViewController: UIViewController {

    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var consentLabel: UILabel!

    //The setup of Ogury Choice Manager and Ogury Ads is done AppDelegate.swift file.
    override func viewDidLoad() {
        versionLabel.text = """
                                OguryAds version:\(OguryAds.shared().sdkVersion ?? "Error") \
                                \nChoice Manager version: \(OguryChoiceManager.shared().consentSDKVersion())\
                                \nGoogleMobileAds versions: \(GADMobileAds.sharedInstance().sdkVersion)

                                """
        consentLabel.isHidden = true
    }




    @IBAction func askUserConsent(_ sender: Any) {
        /*
         * The ask method must be called at each launch of your application
         *  to be sure to have an up-to-date consent status.
         */
        OguryChoiceManager.shared().ask(with: self) { (error, answer) in
            self.handleConsentCallBack(answer: answer, error: error)
        }
    }

    

    @IBAction func editUserConsent(_ sender: Any) {
        OguryChoiceManager.shared().edit(with: self) { (error, answer) in
            self.handleConsentCallBack(answer: answer, error: error)
        }
    }

    private func handleConsentCallBack(answer: OguryChoiceManagerAnswer, error: Error?) {
        switch answer {
        case .noAnswer: // TCF Option
            self.addNewStatus("[Choice Manager] No Answer")
        case .fullApproval: // TCF Option
            self.addNewStatus("[Choice Manager] Full Approval")
        case .partialApproval: // TCF Option
            self.addNewStatus("[Choice Manager] Partial Approval")
        case .refusal: // TCF Option
            self.addNewStatus("[Choice Manager] Refusal")
        case .saleAllowed: // CCPA Option
            self.addNewStatus("[Choice Manager] Sale Allowed")
        case .saleDenied: // CCPA Option
            self.addNewStatus("[Choice Manager] Sale Denided")
        default:
            self.addNewStatus("[Choice Manager] Unknown Option")
        }
    }

    private func addNewStatus(_ text: String){
        consentLabel.isHidden = false
        consentLabel.text = text
    }
    
}
