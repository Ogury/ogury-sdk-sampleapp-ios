//
//  ViewController.swift
//  ThumbnailExample
//
//  Copyright © 2021 Ogury Co. All rights reserved.
//

import UIKit
import OguryChoiceManager
import MoPubSDK

class ViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    var thumbnail: MPAdView?
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
        statusLabel.text = "Loading Ad..."
        thumbnail = MPAdView.init(adUnitId: "b5cabe32c7f741d687d411d5f45ec4e6")
        thumbnail?.delegate = self;
        thumbnail?.maxAdSize = CGSize(width: 200, height: 200)
        thumbnail?.stopAutomaticallyRefreshingContents()
        
        thumbnail?.localExtras = [
            "rect_corner": "bottom_right",
            "x_margin": 30,
            "y_margin": 30,
            "whitelist": ["com.example.bundle", "com.example.bundle2"],
            "blacklist": [BlackListViewController.className()]
        ];
        
        thumbnail?.loadAd()
    }
    
    @IBAction func showAdBtnPressed(_ sender: Any) {
        guard let thumbnailView = thumbnail else {
            return
        }
        if adLoaded == true {
            self.statusLabel.text = "Ad requested to show"
            self.view.addSubview(thumbnailView)
        }
    }
}

extension ViewController : MPAdViewDelegate {
    func viewControllerForPresentingModalView() -> UIViewController! {
        return self;
    }
    
    func adViewDidLoadAd(_ view: MPAdView!, adSize: CGSize) {
        self.statusLabel.text = "Ad received"
        self.adLoaded = true
    }
    
    func adView(_ view: MPAdView!, didFailToLoadAdWithError error: Error!) {
        self.statusLabel.text = "Error: \(error.debugDescription)"
    }
}

class BlackListViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad();
    }
}
