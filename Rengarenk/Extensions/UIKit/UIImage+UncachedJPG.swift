//
//  UIImage+Uncached.swift
//  Flying Letters
//
//  Created by Mert Arıcan on 12.10.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init?(uncachedjpg name: String) {
        if let path = Bundle.main.path(forResource: name, ofType: "jpg") {
            self.init(contentsOfFile: path)
        } else {
            return nil
        }
    }
}

//extension UIImage {
//    convenience init?(uncachedjpg name: String) {
//        if let url = Bundle.main.url(forResource: name, withExtension: "jpg"), let imageData = try? Data(contentsOf: url) {
//            self.init(data: imageData)
//        } else {
//            return nil
//        }
//    }
//}
