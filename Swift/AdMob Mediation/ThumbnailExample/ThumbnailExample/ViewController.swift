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
    var thumbnail: GADBannerView?
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
        self.addNewStatus("Loading Ad...")
        let adSizeThumbnail = GADAdSizeFromCGSize(CGSize(width: 180  , height: 180)) //The size of the thumbnail
        thumbnail = GADBannerView(adSize: adSizeThumbnail)
        thumbnail!.adUnitID = "admob_adunit" //Google Ad Unit Id
        thumbnail!.rootViewController = self
        thumbnail!.delegate = self
        
        let thumbnailRequest = GADRequest()
        let thumbnailExtras = GADCustomEventExtras()
        let whitelist = ["AllowedExampleViewController","AllowedExample2ViewController"] // Extenal ViewController where thumbnail is allowed to show
        let blacklist = [NSStringFromClass(BlackListViewController.classForCoder())] // Blacklisted ViewController where thumbnail is not allowed to show
        let extrasParams:Dictionary<String, Any> = ["x_margin": 20, "y_margin": 20, "rect_corner": "bottom_right", "whitelist": whitelist, "blacklist": blacklist];
        print(extrasParams)
        thumbnailExtras.setExtras(extrasParams, forLabel:"OguryThumbnail") //Label has to match the label name given in GAM Platform to Ogury
        thumbnailRequest.register(thumbnailExtras)
        thumbnail?.load(thumbnailRequest)
    }
    
    @IBAction func showAdBtnPressed(_ sender: Any) {
        guard let thumbnailView = thumbnail, adLoaded else {
            self.addNewStatus("Ad not loaded")
            return
        }
        self.addNewStatus("Ad requested to show")
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

extension ViewController : GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        self.addNewStatus("Ad received")
        self.adLoaded = true
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        self.addNewStatus("Error: \(error.localizedDescription)")
    }

}

class BlackListViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad();
    }
}
