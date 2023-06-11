//
//  UIView+Center.swift
//  Rengarenk
//
//  Created by Mert Arıcan on 4.12.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

extension UIView {
    func moveToCenter() {
        if let superview = self.superview {
            let center = superview.centerOfBounds.offsetBy(dx: -self.bounds.width/2.0, dy: -self.bounds.height/2.0)
            self.frame.origin = center
        }
    }
}

extension UIView {
    var centerOfBounds: CGPoint {
        return CGPoint(x: self.bounds.midX, y: self.bounds.midY)
    }
}
