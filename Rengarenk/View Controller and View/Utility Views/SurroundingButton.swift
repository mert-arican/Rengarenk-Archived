//
//  SurroundingButton.swift
//  Rengarenk
//
//  Created by Mert Arıcan on 4.12.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

class SurroundingButton: UIButton {
    var name: String!
    var vcIdentifier: String?
    override var isHighlighted: Bool {
        didSet { self.alpha = self.isHighlighted ? 0.8 : 1 }
    }
}
