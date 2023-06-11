//
//  Array+ReplaceFirst.swift
//  Flying Letters
//
//  Created by Mert Arıcan on 12.10.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import Foundation
extension Array where Element: Equatable {
    mutating func replaceFirst(_ lhs: Element, with rhs: Element) {
        if let lhsIndex = self.firstIndex(where: { $0 == lhs }) {
            self[lhsIndex] = rhs
        }
    }
}
