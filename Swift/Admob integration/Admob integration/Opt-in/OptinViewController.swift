//
//  OptinViewController.swift
//  Admob Integration
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

import UIKit
import GoogleMobileAds

class OptinViewController: UIViewController {
    
    @IBOutlet weak var statusTextView: UITextView!
    var rewardedAd: GADRewardedAd?
    
    @IBAction func loadAdBtnPressed(_ sender: Any) {
        addNewStatus("[Admob][Opt-in] Loading")
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: ConstantKeys.optinAdUnit, request: request, completionHandler: { [self] ad, error in
            if let error = error {
                addNewStatus("[Admob][Opt-in] Ad error: \(error.localizedDescription)")
                return
            }
            rewardedAd = ad
            rewardedAd?.fullScreenContentDelegate = self
            addNewStatus("[Admob][Opt-in] Ad loaded")
        })
    }
    
    @IBAction func showAdBtnPressed(_ sender: Any) {
        guard let rewardedAd = rewardedAd else {
            addNewStatus("[Admob][Opt-in] Ad not loaded")
            return
        }
        addNewStatus("[Admob][Opt-in] Requested to show")
        rewardedAd.present(fromRootViewController: self, userDidEarnRewardHandler: { [weak self] in
            //reward your user here
            self?.addNewStatus("[Admob][Opt-in] User rewarded")
        })
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

extension OptinViewController: GADFullScreenContentDelegate {

    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        addNewStatus("[Admob][Opt-in] Ad error: \(error.localizedDescription)")
    }

    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        addNewStatus("[Admob][Opt-in] Ad presented")
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        addNewStatus("[Admob][Opt-in] Ad dismissed")
    }

    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        addNewStatus("[Admob][Opt-in] Ad clicked")
    }
}
