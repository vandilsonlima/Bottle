//
//  ViewController.swift
//  Bottle
//
//  Created by Vandilson Lima on 23/06/20.
//  Copyright © 2020 klsoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var fullBottleImageView: UIImageView!
    @IBOutlet weak var emptyBottleImageView: UIImageView!
    @IBOutlet weak var levelConstraint: NSLayoutConstraint!

    var level = CGFloat(0)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(tap))
        )
        fill(1)
    }

    func fill(_ p: CGFloat) {
        let height = fullBottleImageView.frame.height
        levelConstraint.constant = -(height * p)
    }

    @objc func tap() {
        level += 0.1
        fill(1 - level)
    }
}

