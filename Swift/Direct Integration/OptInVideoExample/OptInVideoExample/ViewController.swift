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
    
    @IBOutlet weak var statusLabel: UILabel!
    var rewardedAd: OguryAdsOptinVideo?
    var adLoaded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.statusLabel.text = "Choice Manager Loading..."
        
        //The setup of Ogury Choice Manager and Ogury Ads is done AppDelegate.swift file.
        OguryChoiceManager.shared().ask(with: self) { (error, answer) in
            if error == nil {
                switch answer {
                case .noAnswer: // TCF Option
                    self.statusLabel.text = "Choice Manager No Answer"
                case .fullApproval: // TCF Option
                    self.statusLabel.text = "Choice Manager Full Approval"
                case .partialApproval: // TCF Option
                    self.statusLabel.text = "Choice Manager Partial Approval"
                case .refusal: // TCF Option
                    self.statusLabel.text = "Choice Manager Refusal"
                case .saleAllowed: // CCPA Option
                    self.statusLabel.text = "Choice Manager Sale Allowed"
                case .saleDenied: // CCPA Option
                    self.statusLabel.text = "Choice Manager Sale Denided"
                default:
                    self.statusLabel.text = "Choice Manager Unknown Option"
                }
            } else {
                self.statusLabel.text = "Choice Manager error : \(error.debugDescription)"
            }
        }
    }
    
    @IBAction func loadAdBtnPressed(_ sender: Any) {
        self.statusLabel.text = "Loading Ad..."
        
        rewardedAd = OguryAdsOptinVideo.init(adUnitID: "ogury_adunit")
        guard let rewardedAd = rewardedAd else {
            self.statusLabel.text = "Error while initialising the ad"
            return
        }
        rewardedAd.optInVideoDelegate = self
        rewardedAd.load()
    }
    
    @IBAction func showAdBtnPressed(_ sender: Any) {
        guard let rewardedAd = rewardedAd else {
            return
        }
        if adLoaded == true {
            self.statusLabel.text = "Ad requested to show"
            rewardedAd.showAd(in: self)
        }
    }
    
}

extension ViewController:OguryAdsOptinVideoDelegate {
    
    func oguryAdsOptinVideoAdLoaded() {
        self.statusLabel.text = "Ad received"
        self.adLoaded = true
    }
    
    func oguryAdsOptinVideoAdClosed() {
        self.statusLabel.text = "Ad Closed"
        self.adLoaded = false
    }
    
    func oguryAdsOptinVideoAdClicked() {
        self.statusLabel.text = "Ad Clicked"
    }
    
    func oguryAdsOptinVideoAdDisplayed() {
        self.statusLabel.text = "Ad on screen"
    }
    
    func oguryAdsOptinVideoAdNotAvailable() {
        self.statusLabel.text = "Ad Not Available"
    }
    
    func oguryAdsOptinVideoAdRewarded(_ item: OGARewardItem!) {
        print("Reward received with name: \(item.rewardName) and value: \(item.rewardValue) ")
    }
    
    //For more informations about error codes please refer to our documentation at https://docs.ogury.co/
    func oguryAdsOptinVideoAdError(_ errorType: OguryAdsErrorType) {
        
    }
}

