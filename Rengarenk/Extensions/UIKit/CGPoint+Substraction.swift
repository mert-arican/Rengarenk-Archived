//
//  Extension+CGPoint+Substraction.swift
//  Template 7
//
//  Created by Mert Arıcan on 24.09.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

extension CGPoint {
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGFloat {
        return abs(lhs.x - rhs.x) + abs(lhs.y - rhs.y)
    }
}
