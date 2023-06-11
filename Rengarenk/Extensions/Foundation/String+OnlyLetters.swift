//
//  ModelTemplate.swift
//  Flying Letters
//
//  Created by Mert Arıcan on 7.10.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import Foundation
extension String {
    var onlyLetters: String {
        var copy = self ; copy.removeAll { $0 == " " }
        return copy
    }
}
