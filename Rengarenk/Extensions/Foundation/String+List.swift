//
//  String+List.swift
//  Flying Letters
//
//  Created by Mert Arıcan on 12.10.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import Foundation

extension String {
    var list: [String] { self.map { String($0) } }
}
