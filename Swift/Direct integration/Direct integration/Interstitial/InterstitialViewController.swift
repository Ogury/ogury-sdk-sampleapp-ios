//
//  InterstitialViewController.swift
//  Direct Integration
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

import UIKit
import OguryAds

class InterstitialViewController: UIViewController {
    
    @IBOutlet weak var statusTextView: UITextView!
    var interstitial: OguryInterstitialAd?

    /*
        Don't forget to do the set up of OgurySdk,
            in this sample the set up is done in AppDelegate.swift
        On needs, replace the bundle id in the project settings and the ConstantKeys.AdUnits by your Ogury ad unit
     */

    override func viewDidLoad() {
        interstitial = OguryInterstitialAd(adUnitId: ConstantKeys.interstitialAdUnit)
        interstitial?.delegate = self
    }

    @IBAction func loadAdBtnPressed(_ sender: Any) {
        addNewStatus("[OguryAds][Interstitial] Loading ...")
        interstitial?.load()
    }
    
    @IBAction func showAdBtnPressed(_ sender: Any) {
        guard let interstitial = interstitial else {
            addNewStatus("[OguryAds][Interstitial] Not loaded")
            return
        }
        addNewStatus("[OguryAds][Interstitial] Requested to show")
        interstitial.show(in: self)
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

extension InterstitialViewController: OguryInterstitialAdDelegate {
    func didLoad(_ interstitial: OguryInterstitialAd) {
        addNewStatus("[OguryAds][Interstitial] Ad loaded")
    }

    
    func didDisplay(_ interstitial: OguryInterstitialAd) {
        addNewStatus("[OguryAds][Interstitial] Ad displayed")
    }

    func didClick(_ interstitial: OguryInterstitialAd) {
        addNewStatus("[OguryAds][Interstitial] Ad clicked")
    }

    func didClose(_ interstitial: OguryInterstitialAd) {
        addNewStatus("[OguryAds][Interstitial] Ad closed")
    }

    func didTriggerImpressionOguryInterstitialAd(_ interstitial: OguryInterstitialAd) {
        addNewStatus("[OguryAds][Interstitial] Ad impression")
    }

    func didFailOguryInterstitialAdWithError(_ error: OguryError, for interstitial: OguryInterstitialAd) {
        addNewStatus("[OguryAds][Interstitial] Ad error: \(error.code)")
        addNewStatus("For more informations about error codes please refer to our documentation at https://docs.ogury.co/")
    }
}

