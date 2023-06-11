//
//  WordCategory.swift
//  Flying Letters
//
//  Created by Mert Arıcan on 7.10.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import Foundation

struct WordCategory: Decodable {
    let question: String
    let answers: [String]
    
    init?(json: Data?) {
        if json != nil, let newCategory = try? JSONDecoder().decode(WordCategory.self, from: json!) {
            self = newCategory
        } else {
            return nil
        }
    }
}
