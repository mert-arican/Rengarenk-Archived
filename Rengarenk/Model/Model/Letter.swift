//
//  Letter.swift
//  Flying Letters
//
//  Created by Mert Arıcan on 7.10.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import Foundation

struct Letter: Identifiable, Equatable, Hashable, CustomStringConvertible {
    let index: Int
    let character: String
    var answerID: Int
    var isJoker = false
    
    init(index: Int, answerID: Int = 0, character: String, isJoker: Bool = false) {
        assert(character.count == 1, "More than one character passed to 'Letter' struct initializer.")
        self.index = index ; self.answerID = answerID
        self.character = character ; self.isJoker = isJoker
    }
    
    // MARK: - Protocol conformances
    
    var id: String { "\(character)\(index)" }
    var description: String { "Letter" + id }
    static func ==(lhs: Letter, rhs: Letter) -> Bool {
        return lhs.id == rhs.id
    }
}
