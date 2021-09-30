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
    
    @IBOutlet weak var statusTextView: UITextView!
    var thumbnail: OguryAdsThumbnailAd?
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
        
        thumbnail = OguryAdsThumbnailAd.init(adUnitID: "ogury_adunit")
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
            addNewStatus("Ad requested to show")
            thumbnailView.show(with: OguryRectCorner.bottomRight, margin: OguryOffset(x: 20, y: 20))
        }
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

extension ViewController : OguryAdsThumbnailAdDelegate {
    func oguryAdsThumbnailAdAdLoaded() {
        addNewStatus("Ad received")
        self.adLoaded = true
    }
    
    func oguryAdsThumbnailAdAdClosed() {
        addNewStatus("Ad Closed")
        self.adLoaded = false
    }
    
    func oguryAdsThumbnailAdAdClicked() {
        addNewStatus("Ad Clicked")
    }
    
    func oguryAdsThumbnailAdAdDisplayed() {
        addNewStatus("Ad on screen")
    }
    
    func oguryAdsThumbnailAdAdNotAvailable() {
        addNewStatus("Ad Not Available")
    }
    
    //For more informations about error codes please refer to our documentation at https://docs.ogury.co/
    func oguryAdsThumbnailAdAdError(_ errorType: OguryAdsErrorType) {
        addNewStatus("Error: \(errorType.rawValue)")
        self.adLoaded = false
    }
}

class BlackListViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad();
    }
}
