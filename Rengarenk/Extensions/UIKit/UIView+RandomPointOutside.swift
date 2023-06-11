//
//  UIView+RandomPointOutside.swift
//  Flying Letters
//
//  Created by Mert Arıcan on 12.10.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit
extension UIView {
    var randomPointOutside: CGPoint {
        let width = CGFloat.random(in: self.bounds.width/2 ... self.bounds.width) + 200
        let height = CGFloat.random(in: self.bounds.height/2 ... self.bounds.height) + 200
        return self.center.offsetBy(dx: Int.random(in: 0...1) % 2 == 0 ? width : -width , dy:  Int.random(in: 0...1) % 2 == 0 ? height : -height)
    }
}
