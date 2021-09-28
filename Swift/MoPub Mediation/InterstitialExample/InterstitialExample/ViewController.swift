//
//  ViewController.swift
//  ThumbnailExample
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

import UIKit
import MoPubSDK
import OguryChoiceManager

class ViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    var interstitial: MPInterstitialAdController?
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
        
        interstitial = MPInterstitialAdController(forAdUnitId: "mopub_adunit")
        guard let interstitial = interstitial else {
            self.addStatus("Error while initialising the ad")
            return
        }
        interstitial.delegate = self
        interstitial.loadAd()
    }
    
    @IBAction func showAdBtnPressed(_ sender: Any) {
        guard let interstitial = interstitial, adLoaded else {
            self.addStatus("Ad not loaded")
            return
        }
        if adLoaded == true {
            self.addStatus("Ad requested to show")
            interstitial.show(from: self)
        }
    }
    
}

extension ViewController:MPInterstitialAdControllerDelegate {
    func interstitialDidLoadAd(_ interstitial: MPInterstitialAdController!) {
        self.addStatus("Ad received")
        self.adLoaded = true
    }
    
    func interstitialDidFail(toLoadAd interstitial: MPInterstitialAdController!, withError error: Error!) {
        self.addStatus("Error: \(error.debugDescription)")
        self.adLoaded = false
    }

    func interstitialDidAppear(_ interstitial: MPInterstitialAdController!) {
        self.addStatus("interstitialDidAppear")
    }

    func interstitialDidDisappear(_ interstitial: MPInterstitialAdController!) {
        self.addStatus("Ad not loaded")
        self.adLoaded = false
    }
    func interstitialDidReceiveTapEvent(_ interstitial: MPInterstitialAdController!) {
        self.addStatus("interstitialDidReceiveTapEvent")
    }
    
}

