//
//  UIView+RemoveShadow.swift
//  Rengarenk
//
//  Created by Mert Arıcan on 11.12.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

extension UIView {
    func removeShadow() {
        self.layer.shadowColor = UIColor.clear.cgColor
    }
}
