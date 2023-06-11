//
//  UIView+MoveBy.swift
//  Rengarenk
//
//  Created by Mert Arıcan on 4.12.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

extension UIView {
    func moveBy(dx: CGFloat = 0.0, dy: CGFloat = 0.0) {
        self.frame.origin = self.frame.origin.offsetBy(dx: dx, dy: dy)
    }
}
