//
//  BannerViewController.swift
//  Direct Integration Sample
//
//  Copyright © 2020 Ogury Co. All rights reserved.
//

import UIKit
import OguryChoiceManager
import OguryAds

class BannerViewController: UIViewController {
    
    @IBOutlet weak var statusTextView: UITextView!
    @IBOutlet weak var mpuView: UIView!
    @IBOutlet weak var smallBannerView: UIView!

    var smallBanner: OguryAdsBanner?
    var mpuBanner: OguryAdsBanner?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNewStatus("[Choice Manager] Loading...")
        
        //The setup of Ogury Choice Manager and Ogury Ads is done AppDelegate.swift file.
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

    @IBAction func loadMPUBtnPressed(_ sender: Any) {
        addNewStatus("[Ad][MPU] Loading ...")
        mpuBanner = OguryAdsBanner(adUnitID: ConstantKeys.mpuAdUnit)
        mpuBanner!.bannerDelegate = self
        self.mpuBanner?.load(with: OguryAdsBannerSize.mpu_300x250())
    }
    
    @IBAction func loadSmallBannerBtnPressed(_ sender: Any) {
        addNewStatus("[Ad][Banner] Loading ...")
        smallBanner = OguryAdsBanner(adUnitID: ConstantKeys.bannerAdUnit)
        smallBanner!.bannerDelegate = self
        self.smallBanner?.load(with: OguryAdsBannerSize.small_banner_320x50())
    }
    
    @IBAction func showMPUBtnPressed(_ sender: Any) {
        guard let mpuBanner = mpuBanner else {
            addNewStatus("[Ad][MPU] Not loaded")
            return
        }
        addNewStatus("[Ad][MPU] Requested to show")
        mpuBanner.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: mpuView.frame.size)
        mpuView.addSubview(mpuBanner)
    }
    
    @IBAction func showSmallBannerBtnPressed(_ sender: Any) {
        guard let smallBanner = smallBanner else {
            addNewStatus("[Ad][Banner] Not loaded")
            return
        }
        addNewStatus("[Ad][Banner] Requested to show")
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

extension BannerViewController : OguryAdsBannerDelegate {
    func oguryAdsBannerAdLoaded(_ bannerAds: OguryAdsBanner!) {
        if (bannerAds == smallBanner) {
            addNewStatus("[Ad][Banner] Ad loaded")
        } else if (bannerAds == mpuBanner){
            addNewStatus("[Ad][MPU] Ad loaded")
        }
    }
    
    func oguryAdsBannerAdClicked(_ bannerAds: OguryAdsBanner!) {
        if (bannerAds == smallBanner) {
            addNewStatus("[Ad][Banner] Ad clicked")
        } else if (bannerAds == mpuBanner){
            addNewStatus("[Ad][MPU] Ad clicked")
        }
    }
    
    func oguryAdsBannerAdNotAvailable(_ bannerAds: OguryAdsBanner!) {
        if (bannerAds == smallBanner) {
            addNewStatus("[Ad][Banner] Ad not available")
        } else if (bannerAds == mpuBanner){
            addNewStatus("[Ad][MPU] Ad not available")
        }
    }

    //For more informations about error codes please refer to our documentation at https://docs.ogury.co/
    func oguryAdsBannerAdError(_ errorType: OguryAdsErrorType, for bannerAds: OguryAdsBanner!) {
        if (bannerAds == smallBanner) {
            addNewStatus("[Ad][Banner] Ad error: \(errorType.rawValue)")
        } else if (bannerAds == mpuBanner){
            addNewStatus("[Ad][MPU] Ad error: \(errorType.rawValue)")
        }
        addNewStatus("For more informations about error codes please refer to our documentation at https://docs.ogury.co/")

    }
}

