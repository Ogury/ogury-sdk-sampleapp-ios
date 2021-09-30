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
    
    @IBOutlet weak var statusTextView: UITextView!
    var interstitial: MPInterstitialAdController?
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
        
        interstitial = MPInterstitialAdController(forAdUnitId: "mopub_adunit")
        guard let interstitial = interstitial else {
            self.addNewStatus("Error while initialising the ad")
            return
        }
        interstitial.delegate = self
        interstitial.loadAd()
    }
    
    @IBAction func showAdBtnPressed(_ sender: Any) {
        guard let interstitial = interstitial, adLoaded else {
            self.addNewStatus("Ad not loaded")
            return
        }
        self.addNewStatus("Ad requested to show")
        interstitial.show(from: self)
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

extension ViewController:MPInterstitialAdControllerDelegate {
    func interstitialDidLoadAd(_ interstitial: MPInterstitialAdController!) {
        self.addNewStatus("Ad received")
        self.adLoaded = true
    }
    
    func interstitialDidFail(toLoadAd interstitial: MPInterstitialAdController!, withError error: Error!) {
        self.addNewStatus("Error: \(error.debugDescription)")
        self.adLoaded = false
    }

    func interstitialDidAppear(_ interstitial: MPInterstitialAdController!) {
        self.addNewStatus("interstitialDidAppear")
    }

    func interstitialDidDisappear(_ interstitial: MPInterstitialAdController!) {
        self.addNewStatus("Ad not loaded")
        self.adLoaded = false
    }
    func interstitialDidReceiveTapEvent(_ interstitial: MPInterstitialAdController!) {
        self.addNewStatus("interstitialDidReceiveTapEvent")
    }
    
}

