//
//  BannerViewController.swift
//  Xandr mediation sample
//
//

import UIKit
import AppNexusSDK

class BannerViewController: UIViewController {
    
    let banner = ANBannerAdView(frame: <#T##CGRect#>, placementId: <#T##String#>, adSize: CGSize(width: 320, height: 50))
    let mpu = ANBannerAdView(frame: <#T##CGRect#>, placementId: <#T##String#>, adSize: CGSize(width: 300, height: 250))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        banner.rootViewController = self;
        banner.autoRefreshInterval = 0
        banner.delegate = self
        self.view.addSubview(banner)
        
        mpu.rootViewController = self;
        mpu.autoRefreshInterval = 0
        mpu.delegate = self
        self.view.addSubview(mpu)
    }
    
    @IBAction func loadBanner() {
        banner.loadAd()
    }
    
    @IBAction func loadmpu() {
        mpu.loadAd()
    }

}

extension BannerViewController: ANBannerAdViewDelegate{
    
    func adDidReceiveAd(_ ad: Any) {
        NSLog("Ad load")
    }
    
    func adDidClose(_ ad: Any) {
        NSLog("Ad close")
    }
    
    func adDidPresent(_ ad: Any) {
        NSLog("Ad displayed")
    }
    
    func ad(_ ad: Any, requestFailedWithError error: Error) {
        NSLog("Ad request failed")
    }
}

