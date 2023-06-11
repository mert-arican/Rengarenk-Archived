//
//  Extension+UIView+RandomPosition.swift
//  Template 3
//
//  Created by Mert Arıcan on 16.09.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

extension UIView {
    func randomPosition(withTakingCareOfSize size: CGSize) -> CGPoint {
        let widthRange = frame.minX...(bounds.size.width-size.width)
        let heightRange = frame.minY...(bounds.size.height-size.height)
        return CGPoint(x: CGFloat.random(in: widthRange), y: CGFloat.random(in: heightRange))
    }
}
