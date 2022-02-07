//
//  OptinViewController.swift
//  Direct Integration
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

import UIKit
import OguryAds

class OptinViewController: UIViewController {
    
    @IBOutlet weak var statusTextView: UITextView!
    var rewardedAd: OguryOptinVideoAd?
    

    override func viewDidLoad() {
        rewardedAd = OguryOptinVideoAd(adUnitId: ConstantKeys.optinAdUnit)
        rewardedAd?.delegate = self
    }
    
    @IBAction func loadAdBtnPressed(_ sender: Any) {
        addNewStatus("[OguryAds][Opt-in] Loading")
        rewardedAd?.load()
    }
    
    @IBAction func showAdBtnPressed(_ sender: Any) {
        guard let rewardedAd = rewardedAd else {
            addNewStatus("[OguryAds][Opt-in] Ad not loaded")
            return
        }
        addNewStatus("[OguryAds][Opt-in] Requested to show")
        rewardedAd.show(in: self)
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

extension OptinViewController: OguryOptinVideoAdDelegate {

    func didLoad(_ optinVideo: OguryOptinVideoAd) {
        addNewStatus("[OguryAds][Opt-in] Ad loaded")
    }

    func didDisplay(_ optinVideo: OguryOptinVideoAd) {
        addNewStatus("[OguryAds][Opt-in] Ad displayed")
    }

    func didClick(_ optinVideo: OguryOptinVideoAd) {
        addNewStatus("[OguryAds][Opt-in] Ad clicked")
    }

    func didClose(_ optinVideo: OguryOptinVideoAd) {
        addNewStatus("[OguryAds][Opt-in] Ad closed")
    }

    func didTriggerImpressionOguryOptinVideoAd(_ optinVideo: OguryOptinVideoAd) {
        addNewStatus("[OguryAds][Opt-in] Ad impression")
    }

    func didRewardOguryOptinVideoAd(with item: OGARewardItem, for optinVideo: OguryOptinVideoAd) {
        addNewStatus("""
                     [OguryAds][Opt-in] Ad reward received:
                       Name: \(item.rewardName)
                       Value: \(item.rewardValue)
                     """)
    }

    func didFailOguryOptinVideoAdWithError(_ error: OguryError, for optinVideo: OguryOptinVideoAd) {
        addNewStatus("[OguryAds][Opt-in] Ad error: \(error.code)")
        addNewStatus("For more informations about error codes please refer to our documentation at https://docs.ogury.co/")
    }
}

