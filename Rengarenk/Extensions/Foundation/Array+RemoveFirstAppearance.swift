//
//  Array+RemoveFirstAppearance.swift
//  Flying Letters
//
//  Created by Mert Arıcan on 12.10.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import Foundation
extension Array where Element: Equatable {
    @discardableResult
    mutating func removeFirstAppearance(_ element: Element) -> Element? {
        if let index = self.firstIndex(where: { $0 == element }) {
            self.remove(at: index)
        }
        return nil
    }
}
