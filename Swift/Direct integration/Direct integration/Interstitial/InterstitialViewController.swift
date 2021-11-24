//
//  InterstitialViewController.swift
//  Direct Integration Sample
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

import UIKit
import OguryChoiceManager
import OguryAds

class InterstitialViewController: UIViewController {
    
    @IBOutlet weak var statusTextView: UITextView!
    var interstitial: OguryAdsInterstitial?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNewStatus("[Choice Manager] Loading...")
        
        //The setup of Ogury Choice Manager and Ogury Ads is done AppDelegate.swift file.
        
        OguryChoiceManager.shared().ask(with: self) { (error, answer) in
            if error == nil {
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
            } else {
                self.addNewStatus("[Choice Manager] error : \(error.debugDescription)")
            }
        }
    }

    
    @IBAction func loadAdBtnPressed(_ sender: Any) {
        addNewStatus("[Ad][Interstitial] Loading ...")

        interstitial = OguryAdsInterstitial(adUnitID: ConstantKeys.interstitialAdUnit)
        guard let interstitial = interstitial else {
            addNewStatus("[Ad][Interstitial] Init error")
            return
        }
        interstitial.interstitialDelegate = self
        interstitial.load()
    }
    
    @IBAction func showAdBtnPressed(_ sender: Any) {
        guard let interstitial = interstitial else {
            addNewStatus("[Ad][Interstitial] Not loaded")
            return
        }
        addNewStatus("[Ad][Interstitial] Requested to show")
        interstitial.showAd(in: self)
    }

    func addNewStatus(_ status: String) {
        DispatchQueue.main.async {
            let textToLog = status + "\n"
            self.statusTextView.textStorage.append(NSAttributedString(string: textToLog))
            let bottom = NSMakeRange(self.statusTextView.text.count - 1, 1)
            self.statusTextView.scrollRangeToVisible(bottom)
        }
    }
    
}

extension InterstitialViewController:OguryAdsInterstitialDelegate {
    
    func oguryAdsInterstitialAdLoaded() {
        addNewStatus("[Ad][Interstitial] Ad loaded")
    }
    
    func oguryAdsInterstitialAdClosed() {
        addNewStatus("[Ad][Interstitial] Ad closed")
    }
    
    func oguryAdsInterstitialAdDisplayed() {
        addNewStatus("[Ad][Interstitial] Ad displayed")
    }
    
    func oguryAdsInterstitialAdClicked() {
        addNewStatus("[Ad][Interstitial] Ad clicked")
    }
    
    func oguryAdsInterstitialAdNotAvailable() {
        addNewStatus("[Ad][Interstitial] Ad not available")
    }

    func oguryAdsInterstitialAdOnAdImpression() {
        addNewStatus("[Ad][Interstitial] Ad on impressions")
    }
    //For more informations about error codes please refer to our documentation at https://docs.ogury.co/
    func oguryAdsInterstitialAdError(_ errorType: OguryAdsErrorType) {
        addNewStatus("[Ad][Interstitial] Ad error: \(errorType.rawValue)")
        addNewStatus("For more informations about error codes please refer to our documentation at https://docs.ogury.co/")
    }
}

