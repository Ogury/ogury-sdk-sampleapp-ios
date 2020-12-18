//
//  ViewController.swift
//  OptinVideoExample
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

import UIKit
import GoogleMobileAds
import OguryChoiceManager

class ViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    var rewardedAd: GADRewardedAd?
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
        
        rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-7079119646488414/1484954054")
        guard let rewardedAd = rewardedAd else {
            self.statusLabel.text = "Error while initialising the ad"
            return
        }
        rewardedAd.load(GADRequest()) { error in
            if let error = error {
                self.statusLabel.text = "Error: \(error)"
            } else {
                DispatchQueue.main.async {
                    self.statusLabel.text = "Ad received"
                    self.adLoaded = true
                }
            }
        }
    }
    
    @IBAction func showAdBtnPressed(_ sender: Any) {
        guard let rewardedAd = rewardedAd else {
            return
        }
        if adLoaded == true {
            self.statusLabel.text = "Ad requested to show"
            rewardedAd.present(fromRootViewController: self, delegate: self)
        }
    }
    
}

extension ViewController:GADRewardedAdDelegate {
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        print("Reward received with ammount: \(reward.amount) and type: \(reward.type) ")
    }
    
    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
        self.statusLabel.text = "Ad on screen"
    }
    
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        self.statusLabel.text = "Ad not loaded"
    }
    
    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
        self.statusLabel.text = "Error: \(error)"
    }
}

