//
//  ViewController.swift
//  OptinVideoExample
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

import UIKit
import MoPubSDK
import OguryChoiceManager

class ViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    var adLoaded: Bool = false
    private var statusArray = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addStatus("Choice Manager Loading...")
        
        //The setup of Ogury Choice Manager is done AppDelegate.swift file.
        OguryChoiceManager.shared().ask(with: self) { (error, answer) in
            if error == nil {
                switch answer {
                case .noAnswer: // TCF Option
                    self.addStatus("Choice Manager No Answer")
                case .fullApproval: // TCF Option
                    self.addStatus("Choice Manager Full Approval")
                case .partialApproval: // TCF Option
                    self.addStatus("Choice Manager Partial Approval")
                case .refusal: // TCF Option
                    self.addStatus("Choice Manager Refusal")
                case .saleAllowed: // CCPA Option
                    self.addStatus("Choice Manager Sale Allowed")
                case .saleDenied: // CCPA Option
                    self.addStatus("Choice Manager Sale Denided")
                default:
                    self.addStatus("Choice Manager Unknown Option")
                }
            } else {
                self.addStatus("Choice Manager error : \(error.debugDescription)")
            }
        }
    }

    private func addStatus(_ text: String) {
        statusArray.append(text)
        if statusArray.count > 6 {
            statusArray.removeFirst()
        }
        self.statusLabel.text = statusArray.joined(separator: "\n")
    }

    @IBAction func loadAdBtnPressed(_ sender: Any) {
        self.addStatus("Loading Ad...")
        MPRewardedAds.setDelegate(self, forAdUnitId: "mopub_adunit")
        MPRewardedAds.loadRewardedAd(withAdUnitID: "mopub_adunit", withMediationSettings: nil)
    }
    
    @IBAction func showAdBtnPressed(_ sender: Any) {
        guard adLoaded else {
            self.addStatus("Ad not loaded")
            return
        }

        self.addStatus("Ad requested to show")
        MPRewardedAds.presentRewardedAd(forAdUnitID: "mopub_adunit", from: self, with: nil)
    }
    
}

extension ViewController:MPRewardedAdsDelegate {
    
    func rewardedAdDidLoad(forAdUnitID adUnitID: String!) {
        self.addStatus("rewardedAdDidLoad")
        self.adLoaded = true
    }
    func rewardedAdDidFailToLoad(forAdUnitID adUnitID: String!, error: Error!) {
        self.addStatus("rewardedAdDidFailToLoad: \(error.debugDescription)")
        self.adLoaded = false
    }

    func rewardedAdDidDismiss(forAdUnitID adUnitID: String!) {
        self.addStatus("rewardedAdDidDismiss")
    }

    func rewardedVideoAdDidAppear(forAdUnitID adUnitID: String!) {
        self.addStatus("rewardedVideoAdDidAppear")
    }
    
    func rewardedVideoAdDidDisappear(forAdUnitID adUnitID: String!) {
        self.addStatus("rewardedVideoAdDidDisappear")
        self.adLoaded = false
    }
    
    func rewardedAdShouldReward(forAdUnitID adUnitID: String!, reward: MPReward!) {
        self.addStatus("Reward received : Type : \(reward.currencyType ?? "No Curency") | Amount: \(reward.amount ?? 0)")
    }

}

