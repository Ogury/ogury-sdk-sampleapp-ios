//
//  ViewController.swift
//  OptinVideoExample
//
//  Copyright © 2021 Ogury Co. All rights reserved.
//

import UIKit
import MoPubSDK
import OguryChoiceManager

class ViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    var adLoaded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.statusLabel.text = "Choice Manager Loading..."
        //The setup of Ogury Choice Manager is done AppDelegate.swift file.
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
        MPRewardedAds.setDelegate(self, forAdUnitId: "ef93d42cfed24a23b76091f5ecb5c871")
        MPRewardedAds.loadRewardedAd(withAdUnitID: "ef93d42cfed24a23b76091f5ecb5c871", withMediationSettings: [])
    }
    
    @IBAction func showAdBtnPressed(_ sender: Any) {
        if adLoaded == true {
            self.statusLabel.text = "Ad requested to show"
            MPRewardedAds.presentRewardedAd(forAdUnitID: "ef93d42cfed24a23b76091f5ecb5c871", from: self, with: nil)
        }
    }
}

extension ViewController:MPRewardedAdsDelegate {
    
    func rewardedAdDidLoad(forAdUnitID adUnitID: String!) {
        self.statusLabel.text = "Ad loaded"
        self.adLoaded = true
    }
    
    func rewardedAdDidFailToLoad(forAdUnitID adUnitID: String!, error: Error!) {
        self.statusLabel.text = "Error: \(error.debugDescription)"
        self.adLoaded = false
    }
    
    func rewardedAdDidPresent(forAdUnitID adUnitID: String!) {
        print("rewardedAdDidPresent")
    }
    
    func rewardedAdDidDismiss(forAdUnitID adUnitID: String!) {
        self.statusLabel.text = "Ad not loaded"
        self.adLoaded = false
    }
    
    func rewardedAdShouldReward(forAdUnitID adUnitID: String!, reward: MPReward!) {
        print("Reward received : Type : \(reward.currencyType ?? "No Curency") | Amount: \(reward.amount ?? 0)")
    }
}
