//
//  ViewController.swift
//  ThumbnailExample
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

import UIKit
import MoPubSDK
import OguryChoiceManager

class ViewController: UIViewController {
    
    @IBOutlet weak var statusTextView: UITextView!
    @IBOutlet weak var mpuView: UIView!
    @IBOutlet weak var smallBannerView: UIView!
    
    var mpuLoaded: Bool = false
    var smallBannerLoaded: Bool = false
    
    var smallBanner: MPAdView?
    var mpuBanner: MPAdView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNewStatus("Choice Manager Loading...")

        let moPubsdkConfig = MPMoPubConfiguration.init(adUnitIdForAppInitialization: "a4593fc7714d49c682a00cbd512bd711")

        moPubsdkConfig.loggingLevel = .debug
//        moPubsdkConfig.mediatedNetworkConfigurations = ["OguryAdapterConfiguration":
//                                                        ["asset_key": "OGY-5575CC173955"]]

        self.addNewStatus("MoPub initializing")
        MoPub.sharedInstance().initializeSdk(with: moPubsdkConfig) {
            self.addNewStatus("MoPub initialized")
        }
        
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
        mpuBanner = MPAdView.init(adUnitId: "a4593fc7714d49c682a00cbd512bd711")
        mpuBanner!.delegate = self
        
        mpuBanner!.frame = CGRect(x: 0, y: 0, width: mpuView.frame.width, height: mpuView.frame.height);
        mpuBanner?.loadAd(withMaxAdSize: CGSize(width: mpuView.frame.width, height: mpuView.frame.height))
    }
    
    @IBAction func loadSmallBannerBtnPressed(_ sender: Any) {
        self.addNewStatus("Small Banner Loading ...")
        smallBanner = MPAdView.init(adUnitId: "3816a61b79794ab6bc1cd6713d5b42c0")
        smallBanner!.delegate = self
        
        smallBanner!.frame = CGRect(x: 0, y: 0, width: smallBannerView.frame.width, height: smallBannerView.frame.height);
        smallBanner?.loadAd(withMaxAdSize: CGSize(width: smallBannerView.frame.width, height: smallBannerView.frame.height))
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
        if smallBannerLoaded == true {
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

extension ViewController : MPAdViewDelegate {
    func viewControllerForPresentingModalView() -> UIViewController! {
        return self;
    }
    
    func adViewDidLoadAd(_ bannerView: MPAdView!, adSize: CGSize) {
        if (bannerView == smallBanner) {
            addNewStatus("Small Banner received")
            smallBannerLoaded = true
        } else if (bannerView == mpuBanner){
            addNewStatus("MPU Banner received")
            mpuLoaded = true
        }
    }
    
    func adView(_ bannerView: MPAdView!, didFailToLoadAdWithError error: Error!) {
        if (bannerView == smallBanner) {
            self.addNewStatus("Small Banner Error: \(error.debugDescription)")
        } else if (bannerView == mpuBanner){
            self.addNewStatus("MPU Banner Error: \(error.debugDescription)")
        }
    }
    
    func willPresentModalView(forAd bannerView: MPAdView!) {
        if (bannerView == smallBanner) {
            addNewStatus("Small Banner Clicked")
            smallBannerLoaded = true
        } else if (bannerView == mpuBanner){
            addNewStatus("MPU Banner Clicked")
            mpuLoaded = true
        }
    }

}

