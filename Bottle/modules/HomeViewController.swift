//
//  ViewController.swift
//  Bottle
//
//  Created by Vandilson Lima on 23/06/20.
//  Copyright © 2020 klsoft. All rights reserved.
//

import UIKit
import GoogleMobileAds

class HomeViewController: UIViewController {
    @IBOutlet weak var fullBottleImageView: UIImageView!
    @IBOutlet weak var emptyBottleImageView: UIImageView!
    @IBOutlet weak var levelConstraint: NSLayoutConstraint!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.layer.cornerRadius = 30
        addButton.makeShadow()
        setDarkModeImages()
        update()
        registerForNotifications()

        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }

    func registerForNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(update),
            name: Notification.Name(rawValue: "notification.response"),
            object: nil
        )
    }

    func setDarkModeImages() {
        switch traitCollection.userInterfaceStyle {
        case .dark:
            fullBottleImageView.image = UIImage(named: "bottle-full-light")
            emptyBottleImageView.image = UIImage(named: "bottle-empty-light")
        default:
            break
        }
    }

    func fill(_ p: CGFloat, animated: Bool) {
        let fill = min(max(p, 0), 1)
        let height = fullBottleImageView.frame.height
        levelConstraint.constant = -(height * fill)

        guard animated else { return }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func update() {
        DailyControl.check()
        fill(CGFloat(Bottle.shared.percentageFilled), animated: false)
    }

    @IBAction func didTapSettingsButton(_ sender: Any) {
        let vc = SettingsViewController()
        vc.onChange = update
        present(vc, animated: true)
    }

    @IBAction func didTapAddButton(_ sender: Any) {
        Bottle.shared.removeCup()
        let p = CGFloat(Bottle.shared.percentageFilled)
        fill(p, animated: true)
        //NotificationScheduler.shared.testNotification()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

