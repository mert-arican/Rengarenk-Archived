//
//  UIView+CornerRadius.swift
//  Rengarenk
//
//  Created by Mert Arıcan on 4.12.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

extension UIView {
    var commonCornerRadius: CGFloat {
        let mini = min(bounds.width, bounds.height)
//        return mini * 18.0 / 100.0
        return (mini > 100) ? (isPad ? 18.0 : 10.0) : mini * 18 / 100
    }
    
    func setCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    func getCommonCornerRadius() {
        self.setCornerRadius(commonCornerRadius)
    }
}
