//
//  ViewController.swift
//  OptinVideoExample
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

import UIKit
import OguryChoiceManager
import OguryAds

class ViewController: UIViewController {
    
    @IBOutlet weak var statusTextView: UITextView!
    var rewardedAd: OguryAdsOptinVideo?
    var adLoaded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNewStatus("Choice Manager Loading...")
        
        //The setup of Ogury Choice Manager and Ogury Ads is done AppDelegate.swift file.

        OguryChoiceManager.shared().ask(with: self) { (error, answer) in
            if error == nil {
                switch answer {
                case .noAnswer: // TCF Option
                    self.addNewStatus("Choice Manager No Answer")
                case .fullApproval: // TCF Option
                    self.addNewStatus("Choice Manager Full Approval")
                case .partialApproval: // TCF Option
                    self.addNewStatus("Choice Manager Partial Approval")
                case .refusal: // TCF Option
                    self.addNewStatus("Choice Manager Refusal")
                case .saleAllowed: // CCPA Option
                    self.addNewStatus("Choice Manager Sale Allowed")
                case .saleDenied: // CCPA Option
                    self.addNewStatus("Choice Manager Sale Denided")
                default:
                    self.addNewStatus("Choice Manager Unknown Option")
                }
            } else {
                self.addNewStatus("Choice Manager error : \(error.debugDescription)")
            }
        }
    }
    
    @IBAction func loadAdBtnPressed(_ sender: Any) {
        self.addNewStatus("Loading Ad...")
        
        rewardedAd = OguryAdsOptinVideo.init(adUnitID: "ogury_adunit")
        guard let rewardedAd = rewardedAd else {
            self.addNewStatus("Error while initialising the ad")
            return
        }
        rewardedAd.optInVideoDelegate = self
        rewardedAd.load()
    }
    
    @IBAction func showAdBtnPressed(_ sender: Any) {
        guard let rewardedAd = rewardedAd, adLoaded else {
            self.addNewStatus("Ad not loaded")
            return
        }
        self.addNewStatus("Ad requested to show")
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

extension ViewController:OguryAdsOptinVideoDelegate {
    
    func oguryAdsOptinVideoAdLoaded() {
        self.addNewStatus("Ad received")
        self.adLoaded = true
    }
    
    func oguryAdsOptinVideoAdClosed() {
        self.addNewStatus("Ad Closed")
        self.adLoaded = false
    }
    
    func oguryAdsOptinVideoAdClicked() {
        self.addNewStatus("Ad Clicked")
    }
    
    func oguryAdsOptinVideoAdDisplayed() {
        self.addNewStatus("Ad on screen")
    }
    
    func oguryAdsOptinVideoAdNotAvailable() {
        self.addNewStatus("Ad Not Available")
    }
    
    func oguryAdsOptinVideoAdRewarded(_ item: OGARewardItem!) {
        print("Reward received with name: \(item.rewardName) and value: \(item.rewardValue) ")
    }
    
    //For more informations about error codes please refer to our documentation at https://docs.ogury.co/
    func oguryAdsOptinVideoAdError(_ errorType: OguryAdsErrorType) {
        
    }
}

