//
//  ViewController.swift
//  ThumbnailExample
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

import UIKit
import GoogleMobileAds
import OguryChoiceManager

class ViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    var interstitial: GADInterstitial?
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
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-7079119646488414/4240067767")
        guard let interstitial = interstitial else {
            self.statusLabel.text = "Error while initialising the ad"
            return
        }
        interstitial.delegate = self
        interstitial.load(GADRequest())
    }
    
    @IBAction func showAdBtnPressed(_ sender: Any) {
        guard let interstitial = interstitial else {
            return
        }
        if adLoaded == true {
            self.statusLabel.text = "Ad requested to show"
            interstitial.present(fromRootViewController: self)
        }
    }
    
}

extension ViewController:GADInterstitialDelegate {
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        self.statusLabel.text = "Ad received"
        self.adLoaded = true
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        self.statusLabel.text = "Error: \(error.description)"

    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        self.statusLabel.text = "Ad not loaded"
    }
    
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
    }
    
}

