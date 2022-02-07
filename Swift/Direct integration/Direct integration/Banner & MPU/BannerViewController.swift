//
//  BannerViewController.swift
//  Direct Integration
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

import UIKit
import OguryAds

class BannerViewController: UIViewController {
    
    @IBOutlet weak var statusTextView: UITextView!
    @IBOutlet weak var mpuView: UIView!
    @IBOutlet weak var smallBannerView: UIView!

    var smallBanner: OguryBannerAd?
    var mpuBanner: OguryBannerAd?

    override func viewDidLoad() {
        mpuBanner = OguryBannerAd(adUnitId: ConstantKeys.mpuAdUnit)
        mpuBanner?.delegate = self

        smallBanner = OguryBannerAd(adUnitId: ConstantKeys.bannerAdUnit)
        smallBanner?.delegate = self
    }

    @IBAction func loadMPUBtnPressed(_ sender: Any) {
        addNewStatus("[OguryAds][MPU] Loading ...")
        self.mpuBanner?.load(with: OguryAdsBannerSize.mpu_300x250())
    }
    
    @IBAction func loadSmallBannerBtnPressed(_ sender: Any) {
        addNewStatus("[OguryAds][Banner] Loading ...")
        self.smallBanner?.load(with: OguryAdsBannerSize.small_banner_320x50())
    }
    
    @IBAction func showMPUBtnPressed(_ sender: Any) {
        guard let mpuBanner = mpuBanner else {
            addNewStatus("[OguryAds][MPU] Not loaded")
            return
        }
        addNewStatus("[OguryAds][MPU] Requested to show")
        mpuBanner.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: mpuView.frame.size)
        mpuView.addSubview(mpuBanner)
    }
    
    @IBAction func showSmallBannerBtnPressed(_ sender: Any) {
        guard let smallBanner = smallBanner else {
            addNewStatus("[OguryAds][Banner] Not loaded")
            return
        }
        addNewStatus("[OguryAds][Banner] Requested to show")
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

extension BannerViewController : OguryBannerAdDelegate {
    
    func didLoad(_ banner: OguryBannerAd) {
        if (banner == smallBanner) {
            addNewStatus("[OguryAds][Banner] Ad loaded")
        } else if (banner == mpuBanner){
            addNewStatus("[OguryAds][MPU] Ad loaded")
        }
    }

    func didClick(_ banner: OguryBannerAd) {
        if (banner == smallBanner) {
            addNewStatus("[OguryAds][Banner] Ad clicked")
        } else if (banner == mpuBanner){
            addNewStatus("[OguryAds][MPU] Ad clicked")
        }
    }

    func didClose(_ banner: OguryBannerAd) {
        if (banner == smallBanner) {
            addNewStatus("[OguryAds][Banner] Ad closed")
        } else if (banner == mpuBanner){
            addNewStatus("[OguryAds][MPU] Ad closed")
        }
    }

    func didDisplay(_ banner: OguryBannerAd) {
        if (banner == smallBanner) {
            addNewStatus("[OguryAds][Banner] Ad displayed")
        } else if (banner == mpuBanner){
            addNewStatus("[OguryAds][MPU] Ad displayed")
        }
    }

    func didTriggerImpressionOguryBannerAd(_ banner: OguryBannerAd) {
        if (banner == smallBanner) {
            addNewStatus("[OguryAds][Banner] Ad impression")
        } else if (banner == mpuBanner){
            addNewStatus("[OguryAds][MPU] Ad impression")
        }
    }


    func didFailOguryBannerAdWithError(_ error: OguryError, for banner: OguryBannerAd) {
        if (banner == smallBanner) {
            addNewStatus("[OguryAds][Banner] Ad error: \(error.code)")
        } else if (banner == mpuBanner){
            addNewStatus("[OguryAds][MPU] Ad error: \(error.code)")
        }
        addNewStatus("For more informations about error codes please refer to our documentation at https://docs.ogury.co/")
    }

}

