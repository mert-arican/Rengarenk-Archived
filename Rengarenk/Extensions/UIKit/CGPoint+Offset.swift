//
//  Extension+CGPoint+Offset.swift
//  Template 3
//
//  Created by Mert Arıcan on 16.09.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

extension CGPoint {
    func offsetBy(dx: CGFloat? = nil, dy: CGFloat? = nil) -> CGPoint {
        return CGPoint(x: self.x + (dx ?? 0), y: self.y + (dy ?? 0))
    }
}
