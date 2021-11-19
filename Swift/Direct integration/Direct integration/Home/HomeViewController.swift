//
//  HomeViewController.swift
//  Direct Integration Sample
//
//  Created by Fernand Peng on 16/11/2021.
//

import UIKit
import OguryAds
import OguryChoiceManager

enum ViewTag: Int {
    case banner, interstitial, optin, thumbnail
}

class HomeViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet var buttonViews: [UIView]!
    private var viewControllers: [ViewTag: UIViewController] = [:]

    override func viewDidLoad() {
        // Add tap gesture recognizer to View
        self.versionLabel.text = "OguryAds version:\(OguryAds.shared().sdkVersion ?? "Error")\nChoice Manager version: \(OguryChoiceManager.shared().consentSDKVersion())"
        
        for view in buttonViews {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickView(_:)))
            tapGesture.delegate = self
            view.addGestureRecognizer(tapGesture)
        }

    }

    @IBAction func resetViewControllers(_ sender: Any) {
        self.viewControllers.removeAll()
    }
    @objc
    func clickView(_ sender: UITapGestureRecognizer) {
        guard let sender = sender.view, let tag = ViewTag.init(rawValue: sender.tag) else { return }
        if let vc = viewControllers[tag] {
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            performSegue(withIdentifier: String("\(tag)"), sender: tag)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let tag = sender as? ViewTag else {
            fatalError("Unexpected error")
        }
        viewControllers[tag] = segue.destination
    }
}
