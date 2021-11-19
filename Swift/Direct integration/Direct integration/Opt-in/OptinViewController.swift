//
//  OptinViewController.swift
//  Direct Integration Sample
//
//  Created by Fernand Peng on 16/11/2021.
//

import UIKit
import OguryChoiceManager
import OguryAds

class OptinViewController: UIViewController {
    
    @IBOutlet weak var statusTextView: UITextView!
    var rewardedAd: OguryAdsOptinVideo?
    
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
        addNewStatus("[Ad][Opt-in] Loading")

        rewardedAd = OguryAdsOptinVideo.init(adUnitID: ConstantKeys.optinAdUnit)
        guard let rewardedAd = rewardedAd else {
            addNewStatus("[Ad][Opt-in] Init error")
            return
        }
        rewardedAd.optInVideoDelegate = self
        rewardedAd.load()
    }
    
    @IBAction func showAdBtnPressed(_ sender: Any) {
        guard let rewardedAd = rewardedAd else {
            addNewStatus("[Ad][Opt-in] Ad not loaded")
            return
        }
        addNewStatus("[Ad][Opt-in] Requested to show")
        rewardedAd.showAd(in: self)
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

extension OptinViewController: OguryAdsOptinVideoDelegate {
    
    func oguryAdsOptinVideoAdLoaded() {
        addNewStatus("[Ad][Opt-in] Ad loaded")
    }
    
    func oguryAdsOptinVideoAdClosed() {
        addNewStatus("[Ad][Opt-in] Ad closed")
    }
    
    func oguryAdsOptinVideoAdClicked() {
        addNewStatus("[Ad][Opt-in] Ad clicked")
    }
    
    func oguryAdsOptinVideoAdDisplayed() {
        addNewStatus("[Ad][Opt-in] Ad displayed")
    }
    
    func oguryAdsOptinVideoAdNotAvailable() {
        addNewStatus("[Ad][Opt-in] Ad not available")
    }

    func oguryAdsOptinVideoAdOnAdImpression() {
        addNewStatus("[Ad][Opt-in] Ad on impressions")
    }

    func oguryAdsOptinVideoAdRewarded(_ item: OGARewardItem!) {
        addNewStatus("[Ad][Opt-in] Ad reward received - name: \(item.rewardName), value: \(item.rewardValue)")
    }
    
    //For more informations about error codes please refer to our documentation at https://docs.ogury.co/
    func oguryAdsOptinVideoAdError(_ errorType: OguryAdsErrorType) {
        addNewStatus("[Ad][Opt-in] Ad error: \(errorType.rawValue)")
        addNewStatus("For more informations about error codes please refer to our documentation at https://docs.ogury.co/")
    }
}

