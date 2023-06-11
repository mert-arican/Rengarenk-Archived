//
//  CGSize+Static.swift
//  Rengarenk
//
//  Created by Mert Arıcan on 4.12.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

extension CGSize {
    static func -(lhs: CGSize, rhs: CGSize) -> CGSize {
        return .init(width: lhs.width-rhs.width, height: lhs.height-rhs.height)
    }
}
