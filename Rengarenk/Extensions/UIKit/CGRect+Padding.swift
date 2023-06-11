//
//  StoreItemCollectionViewCell.swift
//  Flying Letters
//
//  Created by Mert Arıcan on 31.10.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

extension CGRect {
    func padding(_ length: CGFloat? = nil, horizontal: CGFloat? = nil, vertical: CGFloat? = nil) -> CGRect? {
        if length != nil { return padding(horizontal: length, vertical: length) }
        var origin = self.origin ; var size = self.size
        if horizontal != nil {
            origin = origin.offsetBy(dx: horizontal!)
            size = CGSize(width: size.width-(2*horizontal!), height: size.height)
            guard size.width > 0 else { return nil }
        }
        if vertical != nil {
            origin = origin.offsetBy(dy: vertical!)
            size = CGSize(width: size.width, height: size.height-(2*vertical!))
            guard size.height > 0 else { return nil }
        }
        return CGRect(origin: origin, size: size)
    }
}
