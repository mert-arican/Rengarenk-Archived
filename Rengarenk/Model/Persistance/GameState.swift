//
//  GameState.swift
//  Flying Letters
//
//  Created by Mert Arıcan on 12.10.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import Foundation

/// Struct for storing gameplay information, like current level, currently revealed letters etc.
struct GameState: Codable {
    // MARK: - Public API
    
    /// Makes necessary changes and saves new state when user completes the category.
    mutating func categoryCompleted() {
        categoryIndex += 1
        alreadySolvedIndices = []
        currentlyRevealedIndices = []
        save()
    }
    
    /// Makes necessary changes after correct answer and saves current state to memory.
    mutating func updateAfterCorrectAnswer(_ index: Int) {
        alreadySolvedIndices.append(index)
        currentlyRevealedIndices = [] ; save()
    }
    
    /// Saves changes to memory after letter reveal.
    mutating func updateAfterLetterReveal(revealedIndex: Int?, powerUp: PowerUp) {
        if let index = revealedIndex {
            self.currentlyRevealedIndices.append(index)
            if powerUp != .apocalypse {
                Constantstinopolis.appState.updateAfterPowerUp(powerUp: powerUp)
            }
        }
        save()
    }
    
    /// Helper function for updating the 'appState' after using apocalypse.
    func updateAfterApocalypse() { Constantstinopolis.appState.updateAfterPowerUp(powerUp: .apocalypse) }
    
    // MARK: - Private API
    
    // MARK: Progress
    var categoryIndex: Int = 0
    private(set) var alreadySolvedIndices: [Int] = []
    private(set) var currentlyRevealedIndices: [Int] = []
    
    // MARK:  PowerUps
    private var appState: AppState { Constantstinopolis.appState }
    var fortuneCount: Int { appState.fortuneCount }
    var simurghCount: Int { appState.simurghCount }
    var apocalypseCount: Int { appState.apocalypseCount }
    
    init?(json: Data?) {
        if json != nil, let state = try? JSONDecoder().decode(GameState.self, from: json!) {
            self = state
        } else {
            return nil
        }
    }
    
    init() {}
    
    private var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    private func save() {
        if let url = Constantstinopolis.getApplicationSupportURLWithAppendingPathComponent(Constantstinopolis.gamePathComponent),
            let json = self.json {
            try? json.write(to: url)
        }
    }
}
