//
//  ThumbnailViewController.swift
//  Direct Integration
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

import UIKit
import OguryAds

class ThumbnailViewController: UIViewController {
    
    @IBOutlet weak var statusTextView: UITextView!
    var thumbnail: OguryThumbnailAd?

    /*
        Don't forget to do the set up of OgurySdk,
            in this sample the set up is done in AppDelegate.swift
        On needs, replace the bundle id in the project settings and the ConstantKeys.AdUnits by your Ogury ad unit
     */

    override func viewDidLoad() {
        thumbnail = OguryThumbnailAd(adUnitId: ConstantKeys.thumbnailAdUnit)
        thumbnail?.delegate = self

        thumbnail?.setWhitelistBundleIdentifiers(["com.example.bundle","com.example.bundle2"]) // Extenal bundle where thumbnail is allowed to show
        thumbnail?.setBlacklistViewControllers([NSStringFromClass(BlackListViewController.classForCoder())]) // Blacklisted ViewController where thumbnail is not allowed to show
        
    }

    
    @IBAction func loadAdBtnPressed(_ sender: Any) {
        addNewStatus("[OguryAds][Thumbnail] Loading..")
        thumbnail?.load(CGSize(width: 200, height: 200))
    }
    
    @IBAction func showAdBtnPressed(_ sender: Any) {
        guard let thumbnailView = thumbnail else {
            addNewStatus("[OguryAds][Thumbnail] Ad not loaded")
            return
        }
        addNewStatus("[OguryAds][Thumbnail] Requested to show")
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

extension ThumbnailViewController : OguryThumbnailAdDelegate {
    func didLoad(_ thumbnail: OguryThumbnailAd) {
        addNewStatus("[OguryAds][Thumbnail] Ad loaded")
    }

    func didDisplay(_ thumbnail: OguryThumbnailAd) {
        addNewStatus("[OguryAds][Thumbnail] Ad displayed")
    }

    func didClick(_ thumbnail: OguryThumbnailAd) {
        addNewStatus("[OguryAds][Thumbnail] Ad clicked")
    }

    func didClose(_ thumbnail: OguryThumbnailAd) {
        addNewStatus("[OguryAds][Thumbnail] Ad closed")
    }

    func didTriggerImpressionOguryThumbnailAd(_ thumbnail: OguryThumbnailAd) {
        addNewStatus("[OguryAds][Thumbnail] Ad impression")
    }

    func didFailOguryThumbnailAdWithError(_ error: OguryError, for thumbnail: OguryThumbnailAd) {
        addNewStatus("[OguryAds][Thumbnail] Ad error: \(error.code)")
        addNewStatus("For more informations about error codes please refer to our documentation at https://docs.ogury.co/")
    }
}

class BlackListViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad();
    }
}
