//
//  UIView+DropShadow.swift
//  Rengarenk
//
//  Created by Mert Arıcan on 4.12.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

extension UIView {
    func dropShadow(cornerRadius: CGFloat? = nil) {
        self.removeShadow()
        layer.masksToBounds = false
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowOffset = .zero
        layer.shadowRadius = 1.0
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius ?? self.layer.cornerRadius).cgPath
    }
}
