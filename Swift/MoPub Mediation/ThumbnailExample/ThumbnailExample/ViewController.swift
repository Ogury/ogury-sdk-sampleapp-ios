//
//  ViewController.swift
//  ThumbnailExample
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

import UIKit
import OguryChoiceManager
import MoPubSDK

class ViewController: UIViewController {
    
    @IBOutlet weak var statusTextView: UITextView!
    var thumbnail: MPAdView?
    var adLoaded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNewStatus("Choice Manager Loading...")
        
        //The setup of Ogury Choice Manager is done AppDelegate.swift file.
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
        addNewStatus("Loading Ad...")
        thumbnail = MPAdView.init(adUnitId: "mopub_adunit")
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
        guard let thumbnailView = thumbnail, adLoaded else {
            addNewStatus("Ad not loaded")
            return
        }
        addNewStatus("Ad requested to show")
        self.view.addSubview(thumbnailView)
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

extension ViewController : MPAdViewDelegate {
    func viewControllerForPresentingModalView() -> UIViewController! {
        return self;
    }
    
    func adViewDidLoadAd(_ view: MPAdView!, adSize: CGSize) {
        addNewStatus("Ad received")
        self.adLoaded = true
    }
    
    func adView(_ view: MPAdView!, didFailToLoadAdWithError error: Error!) {
        addNewStatus("Error: \(error.debugDescription)")
    }
}

class BlackListViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad();
    }
}
