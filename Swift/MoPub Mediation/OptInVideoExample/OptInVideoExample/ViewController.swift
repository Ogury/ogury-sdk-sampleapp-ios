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
    
    @IBOutlet weak var statusTextView: UITextView!
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
        MPRewardedAds.setDelegate(self, forAdUnitId: "mopub_adunit")
        MPRewardedAds.loadRewardedAd(withAdUnitID: "mopub_adunit", withMediationSettings: nil)
    }
    
    @IBAction func showAdBtnPressed(_ sender: Any) {
        guard adLoaded else {
            self.addNewStatus("Ad not loaded")
            return
        }

        self.addNewStatus("Ad requested to show")
        MPRewardedAds.presentRewardedAd(forAdUnitID: "mopub_adunit", from: self, with: nil)
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

extension ViewController:MPRewardedAdsDelegate {
    
    func rewardedAdDidLoad(forAdUnitID adUnitID: String!) {
        self.addNewStatus("rewardedAdDidLoad")
        self.adLoaded = true
    }
    func rewardedAdDidFailToLoad(forAdUnitID adUnitID: String!, error: Error!) {
        self.addNewStatus("rewardedAdDidFailToLoad: \(error.debugDescription)")
        self.adLoaded = false
    }

    func rewardedAdDidDismiss(forAdUnitID adUnitID: String!) {
        self.addNewStatus("rewardedAdDidDismiss")
    }

    func rewardedVideoAdDidAppear(forAdUnitID adUnitID: String!) {
        self.addNewStatus("rewardedVideoAdDidAppear")
    }
    
    func rewardedVideoAdDidDisappear(forAdUnitID adUnitID: String!) {
        self.addNewStatus("rewardedVideoAdDidDisappear")
        self.adLoaded = false
    }
    
    func rewardedAdShouldReward(forAdUnitID adUnitID: String!, reward: MPReward!) {
        self.addNewStatus("Reward received : Type : \(reward.currencyType ?? "No Curency") | Amount: \(reward.amount ?? 0)")
    }

}

