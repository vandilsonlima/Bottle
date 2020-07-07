//
//  UIView+Utils.swift
//  Bottle
//
//  Created by Vandilson Lima on 05/07/20.
//  Copyright © 2020 klsoft. All rights reserved.
//

import UIKit

extension UIView {

    func makeShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowOffset = .init(width: 0, height: 0)
        layer.shadowRadius = 10
    }
}
