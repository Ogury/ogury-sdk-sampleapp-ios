//
//  ViewController.swift
//  ThumbnailExample
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

import UIKit
import OguryChoiceManager
import OguryAds

class ViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    var thumbnail: OguryAdsThumbnailAd?
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
        self.statusLabel.text = "Loading Ad..."
        
        thumbnail = OguryAdsThumbnailAd.init(adUnitID: "7fe46720-4a9f-0138-0f06-0242ac120004_test")
        thumbnail!.thumbnailAdDelegate = self
        
        thumbnail?.setWhitelistBundleIdentifiers(["com.example.bundle","com.example.bundle2"]) // Extenal bundle where thumbnail is allowed to show
        thumbnail?.setBlacklistViewControllers([NSStringFromClass(BlackListViewController.classForCoder())]) // Blacklisted ViewController where thumbnail is not allowed to show
        
        thumbnail?.load(CGSize(width: 200, height: 200))
    }
    
    @IBAction func showAdBtnPressed(_ sender: Any) {
        guard let thumbnailView = thumbnail else {
            return
        }
        if adLoaded == true {
            self.statusLabel.text = "Ad requested to show"
            thumbnailView.show(with: OguryRectCorner.bottomRight, margin: OguryOffset(x: 20, y: 20))
        }
    }
    
}

extension ViewController : OguryAdsThumbnailAdDelegate {
    func oguryAdsThumbnailAdAdLoaded() {
        self.statusLabel.text = "Ad received"
        self.adLoaded = true
    }
    
    func oguryAdsThumbnailAdAdClosed() {
        self.statusLabel.text = "Ad Closed"
        self.adLoaded = false
    }
    
    func oguryAdsThumbnailAdAdClicked() {
        self.statusLabel.text = "Ad Clicked"
    }
    
    func oguryAdsThumbnailAdAdDisplayed() {
        self.statusLabel.text = "Ad on screen"
    }
    
    func oguryAdsThumbnailAdAdNotAvailable() {
        self.statusLabel.text = "Ad Not Available"
    }
    
    //For more informations about error codes please refer to our documentation at https://docs.ogury.co/
    func oguryAdsThumbnailAdAdError(_ errorType: OguryAdsErrorType) {
        self.statusLabel.text = "Error: \(errorType.rawValue)"
        self.adLoaded = false
    }
}

class BlackListViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad();
    }
}
