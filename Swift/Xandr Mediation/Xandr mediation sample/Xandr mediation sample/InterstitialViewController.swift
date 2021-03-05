//
//  ViewController.swift
//  Xandr mediation sample
//
//  Created by Pernic on 05/03/2021.
//

import UIKit
import AppNexusSDK

class InterstitialViewController: UIViewController {
    
    let interstitial = ANInterstitialAd.init(placementId:<#T##String#>)

    override func viewDidLoad() {
        super.viewDidLoad()
        interstitial.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loadInter() {
        interstitial.load()
    }
    
    @IBAction func ShowInter() {
        interstitial.display(from: self)
    }

}

extension InterstitialViewController: ANInterstitialAdDelegate{
    
    func adDidReceiveAd(_ ad: Any) {
    }
    
    func adDidClose(_ ad: Any) {
    }
    
    func adDidPresent(_ ad: Any) {
    }
    
    func ad(_ ad: Any, requestFailedWithError error: Error) {
    }
     
    func  adFailed(toDisplay ad: ANInterstitialAd)  {
    }
}

