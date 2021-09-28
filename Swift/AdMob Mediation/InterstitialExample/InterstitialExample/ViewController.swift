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
    var interstitial: GADInterstitialAd?
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
        
        let request = GADRequest()

        GADInterstitialAd.load(withAdUnitID:"admob_adunit",request: request,
            completionHandler: { [self] ad, error in
                if let error = error {
                    self.addStatus("Error: \(error.localizedDescription)")
                    return
                }
                interstitial = ad
                interstitial?.fullScreenContentDelegate = self
                adLoaded = true
                addStatus("Ad received")
            }
        )
    }
    
    @IBAction func showAdBtnPressed(_ sender: Any) {
        guard let interstitial = interstitial, adLoaded else {
            self.addStatus("Ad not ready")
            return
        }
        self.addStatus("Ad requested to show")
        interstitial.present(fromRootViewController: self)
    }
    
}

extension ViewController: GADFullScreenContentDelegate {

    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        self.addStatus("Error: \(error.localizedDescription)")
    }

    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        self.addStatus("Ad presented")
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        self.addStatus("Ad dismissed")
        self.adLoaded = false
    }

}

