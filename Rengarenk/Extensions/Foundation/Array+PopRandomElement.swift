//
//  Extension+Array+PopRandomElement.swift
//  Template 7
//
//  Created by Mert Arıcan on 24.09.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import Foundation

extension Array {
    mutating func popRandomElement() -> Element? {
        if let randomIndex = self.indices.randomElement() {
            return self.remove(at: randomIndex)
        }
        return nil
    }
}
