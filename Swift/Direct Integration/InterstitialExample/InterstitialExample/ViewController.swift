//
//  ViewController.swift
//  ThumbnailExample
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

import UIKit
import OguryChoiceManager
import OguryAds

class ViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    var interstitial: OguryAdsInterstitial?
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
        
        interstitial = OguryAdsInterstitial.init(adUnitID: "cdab8440-4a9d-0138-0f05-0242ac120004_test")
        guard let interstitial = interstitial else {
            self.statusLabel.text = "Error while initialising the ad"
            return
        }
        interstitial.interstitialDelegate = self
        interstitial.load()
    }
    
    @IBAction func showAdBtnPressed(_ sender: Any) {
        guard let interstitial = interstitial else {
            return
        }
        if adLoaded == true {
            self.statusLabel.text = "Ad requested to show"
            interstitial.showAd(in: self)
        }
    }
    
}

extension ViewController:OguryAdsInterstitialDelegate {
    
    func oguryAdsInterstitialAdLoaded() {
        self.statusLabel.text = "Ad received"
        self.adLoaded = true
    }
    
    func oguryAdsInterstitialAdClosed() {
        self.statusLabel.text = "Ad Closed"
        self.adLoaded = false
    }
    
    func oguryAdsInterstitialAdDisplayed() {
        self.statusLabel.text = "Ad on screen"
    }
    
    func oguryAdsInterstitialAdClicked() {
        self.statusLabel.text = "Ad Clicked"
    }
    
    func oguryAdsInterstitialAdNotAvailable() {
        self.statusLabel.text = "Ad Not Available"
    }
    
    //For more informations about error codes please refer to our documentation at https://docs.ogury.co/
    func oguryAdsInterstitialAdError(_ errorType: OguryAdsErrorType) {
        self.statusLabel.text = "Error: \(errorType.rawValue)"
        self.adLoaded = false
    }
}

