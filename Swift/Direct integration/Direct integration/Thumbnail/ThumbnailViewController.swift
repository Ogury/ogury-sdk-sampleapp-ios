//
//  ThumbnailViewController.swift
//  Direct Integration Sample
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

import UIKit
import OguryChoiceManager
import OguryAds

class ThumbnailViewController: UIViewController {
    
    @IBOutlet weak var statusTextView: UITextView!
    var thumbnail: OguryAdsThumbnailAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNewStatus("[Choice Manager] Loading...")
        
        //The setup of Ogury Choice Manager is done AppDelegate.swift file.
        OguryChoiceManager.shared().ask(with: self) { (error, answer) in
            if error == nil {
                switch answer {
                case .noAnswer: // TCF Option
                    self.addNewStatus("[Choice Manager] No Answer")
                case .fullApproval: // TCF Option
                    self.addNewStatus("[Choice Manager] Full Approval")
                case .partialApproval: // TCF Option
                    self.addNewStatus("[Choice Manager] Partial Approval")
                case .refusal: // TCF Option
                    self.addNewStatus("[Choice Manager] Refusal")
                case .saleAllowed: // CCPA Option
                    self.addNewStatus("[Choice Manager] Sale Allowed")
                case .saleDenied: // CCPA Option
                    self.addNewStatus("[Choice Manager] Sale Denided")
                default:
                    self.addNewStatus("[Choice Manager] Unknown Option")
                }
            } else {
                self.addNewStatus("[Choice Manager] error : \(error.debugDescription)")
            }
        }
    }

    
    @IBAction func loadAdBtnPressed(_ sender: Any) {
        addNewStatus("[Ad][Thumbnail] Loading..")

        thumbnail = OguryAdsThumbnailAd(adUnitID: ConstantKeys.thumbnailAdUnit)
        thumbnail!.thumbnailAdDelegate = self
        
        thumbnail?.setWhitelistBundleIdentifiers(["com.example.bundle","com.example.bundle2"]) // Extenal bundle where thumbnail is allowed to show
        thumbnail?.setBlacklistViewControllers([NSStringFromClass(BlackListViewController.classForCoder())]) // Blacklisted ViewController where thumbnail is not allowed to show
        
        thumbnail?.load(CGSize(width: 200, height: 200))
    }
    
    @IBAction func showAdBtnPressed(_ sender: Any) {
        guard let thumbnailView = thumbnail else {
            addNewStatus("[Ad][Thumbnail] Ad not loaded")
            return
        }
        addNewStatus("[Ad][Thumbnail] Requested to show")
        thumbnailView.show(with: OguryRectCorner.bottomRight, margin: OguryOffset(x: 20, y: 20))
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

extension ThumbnailViewController : OguryAdsThumbnailAdDelegate {
    func oguryAdsThumbnailAdAdLoaded() {
        addNewStatus("[Ad][Thumbnail] Ad loaded")
    }
    
    func oguryAdsThumbnailAdAdClosed() {
        addNewStatus("[Ad][Thumbnail] Ad closed")
    }
    
    func oguryAdsThumbnailAdAdClicked() {
        addNewStatus("[Ad][Thumbnail] Ad clicked")
    }
    
    func oguryAdsThumbnailAdAdDisplayed() {
        addNewStatus("[Ad][Thumbnail] Ad displayed")
    }
    
    func oguryAdsThumbnailAdAdNotAvailable() {
        addNewStatus("[Ad][Thumbnail] Ad not available")
    }

    func oguryAdsThumbnailAdAdAvailable() {
        addNewStatus("[Ad][Thumbnail] Ad available")
    }

    func oguryAdsThumbnailAdAdNotLoaded() {
        addNewStatus("[Ad][Thumbnail] Ad not loaded")
    }

    func oguryAdsThumbnailAdOnAdImpression() {
        addNewStatus("[Ad][Thumbnail] Ad on impression")
    }
    //For more informations about error codes please refer to our documentation at https://docs.ogury.co/
    func oguryAdsThumbnailAdAdError(_ errorType: OguryAdsErrorType) {
        addNewStatus("[Ad][Thumbnail] Ad error: \(errorType.rawValue)")
        addNewStatus("For more informations about error codes please refer to our documentation at https://docs.ogury.co/")
    }
}

class BlackListViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad();
    }
}
