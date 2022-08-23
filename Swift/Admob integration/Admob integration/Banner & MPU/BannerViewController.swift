//
//  BannerViewController.swift
//  Admob Integration
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

import UIKit
import GoogleMobileAds

class BannerViewController: UIViewController {
    
    @IBOutlet weak var statusTextView: UITextView!
    @IBOutlet weak var mpuView: UIView!
    @IBOutlet weak var smallBannerView: UIView!

    var smallBanner: GADBannerView?
    var mpuBanner: GADBannerView?

    /*
        It's recommended to set up OgurySdk earlier to accelerate the load & impression process,
            in this sample the set up is done in AppDelegate.swift
        On needs, replace the bundle id in the project settings and the ConstantKeys.AdUnits by your Google ad unit
     */

    override func viewDidLoad() {
        mpuBanner = GADBannerView(adSize: GADAdSizeMediumRectangle)
        mpuBanner!.adUnitID = ConstantKeys.mpuAdUnit
        mpuBanner!.rootViewController = self
        mpuBanner!.delegate = self

        smallBanner = GADBannerView(adSize: GADAdSizeBanner)
        smallBanner!.adUnitID = ConstantKeys.bannerAdUnit
        smallBanner!.rootViewController = self
        smallBanner!.delegate = self
    }

    @IBAction func loadMPUBtnPressed(_ sender: Any) {
        addNewStatus("[Admob][MPU] Loading ...")
        self.mpuBanner?.load(GADRequest())
    }
    
    @IBAction func loadSmallBannerBtnPressed(_ sender: Any) {
        addNewStatus("[Admob][Banner] Loading ...")
        self.smallBanner?.load(GADRequest())
    }
    
    @IBAction func showMPUBtnPressed(_ sender: Any) {
        guard let mpuBanner = mpuBanner else {
            addNewStatus("[Admob][MPU] Not loaded")
            return
        }
        addNewStatus("[Admob][MPU] Requested to show")
        mpuBanner.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: mpuView.frame.size)
        mpuView.addSubview(mpuBanner)
    }
    
    @IBAction func showSmallBannerBtnPressed(_ sender: Any) {
        guard let smallBanner = smallBanner else {
            addNewStatus("[Admob][Banner] Not loaded")
            return
        }
        addNewStatus("[Admob][Banner] Requested to show")
        smallBanner.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: smallBannerView.frame.size)
        smallBannerView.addSubview(smallBanner)
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

extension BannerViewController : GADBannerViewDelegate {

    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        if (bannerView == smallBanner) {
            addNewStatus("[Admob][Banner] Ad loaded")
        } else if (bannerView == mpuBanner){
            addNewStatus("[Admob][MPU] Ad loaded")
        }
    }


    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        if (bannerView == smallBanner) {
            addNewStatus("[Admob][Banner] Ad presented")
        } else if (bannerView == mpuBanner){
            addNewStatus("[Admob][MPU] Ad presented")
        }
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        if (bannerView == smallBanner) {
            addNewStatus("[Admob][Banner] Ad error: \(error.localizedDescription)")
        } else if (bannerView == mpuBanner){
            addNewStatus("[Admob][MPU] Ad error: \(error.localizedDescription)")
        }
    }

}
