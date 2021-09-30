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
    
    @IBOutlet weak var statusTextView: UITextView!
    var interstitial: GADInterstitialAd?
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
        
        let request = GADRequest()

        GADInterstitialAd.load(withAdUnitID:"admob_adunit",request: request,
            completionHandler: { [self] ad, error in
                if let error = error {
                    self.addNewStatus("Error: \(error.localizedDescription)")
                    return
                }
                interstitial = ad
                interstitial?.fullScreenContentDelegate = self
                adLoaded = true
                self.addNewStatus("Ad received")
            }
        )
    }
    
    @IBAction func showAdBtnPressed(_ sender: Any) {
        guard let interstitial = interstitial, adLoaded else {
            self.addNewStatus("Ad not loaded")
            return
        }
        self.addNewStatus("Ad requested to show")
        interstitial.present(fromRootViewController: self)
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

extension ViewController: GADFullScreenContentDelegate {

    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        self.addNewStatus("Error: \(error.localizedDescription)")
    }

    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        self.addNewStatus("Ad presented")
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        self.addNewStatus("Ad dismissed")
        self.adLoaded = false
    }

}

