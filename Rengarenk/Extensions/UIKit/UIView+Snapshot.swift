//
//  UIView+Snapshot.swift
//  Rengarenk
//
//  Created by Mert Arıcan on 16.02.2021.
//  Copyright © 2021 Mert Arıcan. All rights reserved.
//

import UIKit

extension UIView {
    var snapshot: UIImage? {
        UIGraphicsBeginImageContext(bounds.size)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
