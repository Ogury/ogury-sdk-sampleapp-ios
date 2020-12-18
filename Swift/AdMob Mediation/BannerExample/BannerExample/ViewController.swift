//
//  ViewController.swift
//  ThumbnailExample
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

import UIKit
import GoogleMobileAds
import OguryChoiceManager

class ViewController: UIViewController {
    
    @IBOutlet weak var statusTextView: UITextView!
    @IBOutlet weak var mpuView: UIView!
    @IBOutlet weak var smallBannerView: UIView!

    var mpuLoaded: Bool = false
    var smallBannerLoaded: Bool = false

    var thumbnail: GADBannerView?
    var smallBanner: GADBannerView?
    var mpuBanner: GADBannerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNewStatus("Choice Manager Loading...")
        
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

    @IBAction func loadMPUBtnPressed(_ sender: Any) {
        self.addNewStatus("MPU Loading ...")
        mpuBanner = GADBannerView(adSize: kGADAdSizeMediumRectangle)
        mpuBanner!.adUnitID = "ca-app-pub-7079119646488414/1229378159"
        mpuBanner!.rootViewController = self
        mpuBanner!.delegate = self
        self.mpuBanner?.load(GADRequest())
    }
    
    @IBAction func loadSmallBannerBtnPressed(_ sender: Any) {
        self.addNewStatus("Small Banner Loading ...")
        smallBanner = GADBannerView(adSize: kGADAdSizeBanner)
        smallBanner!.adUnitID = "ca-app-pub-7079119646488414/7876060447"
        smallBanner!.rootViewController = self
        smallBanner!.delegate = self
        self.smallBanner?.load(GADRequest())
    }
    
    @IBAction func showMPUBtnPressed(_ sender: Any) {
        guard let mpuBanner = mpuBanner else {
            addNewStatus("MPU not initialised")
            return
        }
        
        if mpuLoaded == true {
            addNewStatus("MPU requested to show")
            mpuView.addSubview(mpuBanner)
        }
    }
    
    @IBAction func showSmallBannerBtnPressed(_ sender: Any) {
        guard let smallBanner = smallBanner else {
            addNewStatus("Small Banner not initialised")
            return
        }
        if mpuLoaded == true {
            addNewStatus("Small Banner requested to show")
            smallBannerView.addSubview(smallBanner)
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

extension ViewController : GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        if (bannerView == smallBanner) {
            addNewStatus("Small Banner received")
            smallBannerLoaded = true
        } else if (bannerView == mpuBanner){
            addNewStatus("MPU Banner received")
            mpuLoaded = true
        }
        
        
    }
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        if (bannerView == smallBanner) {
            addNewStatus("Small Banner Presented")
        } else if (bannerView == mpuBanner){
            addNewStatus("MPU Banner Presented")
        }
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        if (bannerView == smallBanner) {
            self.addNewStatus("Small Banner Error: \(error.description)")
        } else if (bannerView == mpuBanner){
            self.addNewStatus("MPU Banner Error: \(error.description)")
        }
    }
}

