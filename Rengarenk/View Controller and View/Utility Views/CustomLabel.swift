//
//  CustomLabel.swift
//  Rengarenk
//
//  Created by Mert Arıcan on 9.12.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        super.drawText(in: rect.inset(by: insets))
    }
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + 10.0 + 10.0,
                      height: size.height)
    }
    override var text: String? { didSet { if text == nil || text == "" { self.backgroundColor = .clear } } }
}

class CustomInfoLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let inset: CGFloat = isPad ? 8.0 : 4.0
        let insets = UIEdgeInsets.init(top: inset, left: inset, bottom: inset, right: inset)
        super.drawText(in: rect.inset(by: insets))
    }
}
