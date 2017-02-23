//
//  UIView+Layout.swift
//  iBooChallenge
//
//  Created by Jordi Serra i Font on 23/2/17.
//  Copyright © 2017 kudai. All rights reserved.
//

import UIKit

extension UIView {
    func fillSuperview() {
        guard let superview = superview else { fatalError("Attempting to fill an inexistent superview") }
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor
            .constraint(equalTo: superview.leadingAnchor)
            .isActive = true
        topAnchor
            .constraint(equalTo: superview.topAnchor)
            .isActive = true
        trailingAnchor
            .constraint(equalTo: superview.trailingAnchor)
            .isActive = true
        bottomAnchor
            .constraint(equalTo: superview.bottomAnchor)
            .isActive = true
    }
}
