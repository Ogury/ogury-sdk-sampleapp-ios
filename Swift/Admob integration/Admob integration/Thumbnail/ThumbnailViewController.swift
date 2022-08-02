//
//  ThumbnailViewController.swift
//  Admob Integration
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ThumbnailViewController: UIViewController {
    
    @IBOutlet weak var statusTextView: UITextView!
    var thumbnail: GADBannerView?

    /*
        It's recommended to set up OgurySdk earlier to accelerate the load & impression process,
            in this sample the set up is done in AppDelegate.swift
        On needs, replace the bundle id in the project settings and the ConstantKeys.AdUnits by your Google ad unit
     */

    override func viewDidLoad() {
        let adSizeThumbnail = GADAdSizeFromCGSize(CGSize(width: 180  , height: 180)) //The size of the thumbnail
        thumbnail = GADBannerView(adSize: adSizeThumbnail)
        thumbnail!.adUnitID = ConstantKeys.thumbnailAdUnit //Google Ad Unit Id
        thumbnail!.rootViewController = self
        thumbnail!.delegate = self
    }

    @IBAction func loadAdBtnPressed(_ sender: Any) {
        addNewStatus("[Admob][Thumbnail] Loading..")

        let thumbnailRequest = GADRequest()
        let thumbnailExtras = GADCustomEventExtras()
        let whitelist = ["AllowedExampleViewController","AllowedExample2ViewController"] // Extenal ViewController where thumbnail is allowed to show
        let blacklist = [NSStringFromClass(BlackListViewController.classForCoder())] // Blacklisted ViewController where thumbnail is not allowed to show
        let extrasParams:Dictionary<String, Any> = ["x_margin": 20, "y_margin": 20, "rect_corner": "bottom_right", "whitelist": whitelist, "blacklist": blacklist];
        thumbnailExtras.setExtras(extrasParams, forLabel:"OguryThumbnail") //Label has to match the label name given in GAM Platform to Ogury
        thumbnailRequest.register(thumbnailExtras)
        thumbnail?.load(thumbnailRequest)
    }
    
    @IBAction func showAdBtnPressed(_ sender: Any) {
        guard let thumbnailView = thumbnail else {
            addNewStatus("[Admob][Thumbnail] Ad not loaded")
            return
        }
        addNewStatus("[Admob][Thumbnail] Requested to show")
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

extension ThumbnailViewController : GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        addNewStatus("[Admob][Thumbnail] Ad received")
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        addNewStatus("[Admob][Thumbnail] Ad error: \(error.localizedDescription)")
    }

}

class BlackListViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad();
    }
}
