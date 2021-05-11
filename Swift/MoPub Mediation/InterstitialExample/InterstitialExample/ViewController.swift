//
//  ViewController.swift
//  ThumbnailExample
//
//  Copyright © 2021 Ogury Co. All rights reserved.
//

import UIKit
import MoPubSDK
import OguryChoiceManager

class ViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    var interstitial: MPInterstitialAdController?
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
        interstitial = MPInterstitialAdController(forAdUnitId: "de5cb2a3b2bc4d5cb6c97a89be556a6f")
        guard let interstitial = interstitial else {
            self.statusLabel.text = "Error while initialising the ad"
            return
        }
        interstitial.delegate = self
        interstitial.loadAd()
    }
    
    @IBAction func showAdBtnPressed(_ sender: Any) {
        guard let interstitial = interstitial else {
            return
        }
        if adLoaded == true {
            self.statusLabel.text = "Ad requested to show"
            interstitial.show(from: self)
        }
    }
}

extension ViewController:MPInterstitialAdControllerDelegate {
    
    func interstitialDidLoadAd(_ interstitial: MPInterstitialAdController!) {
        self.statusLabel.text = "Ad received"
        self.adLoaded = true
    }
    
    func interstitialDidFail(toLoadAd interstitial: MPInterstitialAdController!, withError error: Error!) {
        self.statusLabel.text = "Error: \(error.debugDescription)"
        self.adLoaded = false
    }
    
    func interstitialDidAppear(_ interstitial: MPInterstitialAdController!) {
        print("interstitialDidAppear")
    }
    
    func interstitialDidDisappear(_ interstitial: MPInterstitialAdController!) {
        self.statusLabel.text = "Ad not loaded"
        self.adLoaded = false
    }
    
    func interstitialDidReceiveTapEvent(_ interstitial: MPInterstitialAdController!) {
        print("interstitialDidReceiveTapEvent")
    }
}
