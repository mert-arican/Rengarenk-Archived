//
//  CGSize+SquareLength.swift
//  Rengarenk
//
//  Created by Mert Arıcan on 5.12.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

extension CGSize {
    init(squareWith length: CGFloat) {
        self = CGSize(width: length, height: length)
    }
}
