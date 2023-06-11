//
//  Array+UniquelyAppend.swift
//  Flying Letters
//
//  Created by Mert Arıcan on 19.10.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    mutating func uniquelyAppend(_ element: Element) {
        if !self.contains(element) { self.append(element) }
    }
}
