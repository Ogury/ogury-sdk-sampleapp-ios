//
//  InterstitialViewController.swift
//  Admob Integration
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

import UIKit
import GoogleMobileAds

class InterstitialViewController: UIViewController {
    
    @IBOutlet weak var statusTextView: UITextView!
    var interstitial: GADInterstitialAd?

    @IBAction func loadAdBtnPressed(_ sender: Any) {
        addNewStatus("[Admob][Interstitial] Loading ...")

        let request = GADRequest()

        GADInterstitialAd.load(withAdUnitID: ConstantKeys.interstitialAdUnit,request: request,
            completionHandler: { [weak self] ad, error in
                if let error = error {
                    self?.addNewStatus("[Admob][Interstitial] Ad error: \(error.localizedDescription)")
                    return
                }
                self?.interstitial = ad
                self?.interstitial?.fullScreenContentDelegate = self
                self?.addNewStatus("[Admob][Interstitial] loaded")
            }
        )
    }
    
    @IBAction func showAdBtnPressed(_ sender: Any) {
        guard let interstitial = interstitial else {
            addNewStatus("[Admob][Interstitial] Not loaded")
            return
        }
        addNewStatus("[Admob][Interstitial] Requested to show")
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

/*
 * Visit admob official documentation for more information:
 * https://developers.google.com/admob/ios/quick-start
 */

extension InterstitialViewController: GADFullScreenContentDelegate {

    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        addNewStatus("[Admob][Interstitial] Ad error: \(error.localizedDescription)")
    }

    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        addNewStatus("[Admob][Interstitial] Ad presented")
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        addNewStatus("[Admob][Interstitial] Ad dismissed")
    }

    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        addNewStatus("[Admob][Interstitial] Ad clicked")
    }
}
