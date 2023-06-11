//
//  UIView+StaticShadow.swift
//  Rengarenk
//
//  Created by Mert Arıcan on 11.06.2021.
//

import UIKit

extension UIView {
    func dropStaticShadow() {
        let shadowView = UIView(frame: self.frame)
        shadowView.backgroundColor = .clear
        self.superview?.addSubview(shadowView)
        self.superview?.sendSubviewToBack(shadowView)
        shadowView.setCornerRadius(self.layer.cornerRadius)
        shadowView.dropShadow()
    }
}
