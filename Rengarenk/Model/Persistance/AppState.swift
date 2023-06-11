//
//  AppState.swift
//  Rengarenk
//
//  Created by Mert Arıcan on 13.12.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import Foundation

/// Struct for storing app-wide information, like power up count, whether ads are removed or not etc.
struct AppState: Codable {
    // Variables for storing non-consumable properties.
    private(set) var octupledCategoryRewards = false
    
    // Default number of power ups if user plays the game for the first time.
    private(set) var fortuneCount = 5
    private(set) var simurghCount = 5
    private(set) var apocalypseCount = 5
    
    mutating func updateAfterNonConsumableDeal(octupledEarnings: Bool) {
        self.octupledCategoryRewards = octupledEarnings
        self.save()
    }
    
    /// Updates the numbers of each power up after deal.
    /// 'Assumes 'products' is an array with 3 elements, which represents the fortune', 'simurgh' and 'apocalypse' count in order.
    mutating func updateAfterConsumableDeal(products: [Int]) {
        assert(products.count == 3)
        let powerUps = [PowerUp.fortune, .simurgh, .apocalypse]
        (0...2).forEach { self.updateAfterPowerUp(powerUp: powerUps[$0], count: products[$0]) }
    }
    
    /// Updates the power ups number according to 'count' property.
    mutating func updateAfterPowerUp(powerUp: PowerUp, count: Int = -1) {
        switch powerUp {
        case .fortune: self.fortuneCount += count
        case .simurgh: self.simurghCount += count
        case .apocalypse: self.apocalypseCount += count
        }
        self.save()
    }
    
    /// This function gives reward either at the new route point or after watching rewarded ad.
    /// If user is at new route point and 'quadrupledCategoryRewards' is true, then gives 4x reward.
    mutating func getRewardAfterCategoryEnd() -> PowerUp? {
        guard (Constantstinopolis.gameState.categoryIndex) % 10 == 0 else { return nil }
        let rewardCount = octupledCategoryRewards ? 8 : 2
        let randomInt = Int.random(in: 1...10)
        let reward: PowerUp
        if randomInt <= 5 { reward = .fortune; self.fortuneCount += rewardCount }
        else if randomInt <= 9 { reward = .simurgh; self.simurghCount += rewardCount }
        else { reward = .apocalypse; self.apocalypseCount += rewardCount }
        self.save()
        return reward
    }
    
    init() { }
    
    init?(json: Data?) {
        if json != nil, let state = try? JSONDecoder().decode(AppState.self, from: json!) {
            self = state
        } else {
            return nil
        }
    }
    
    private var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    private func save() {
        if let json = self.json {
            if let url = Constantstinopolis.getApplicationSupportURLWithAppendingPathComponent("AppState.json") {
                try? json.write(to: url)
            }
        }
    }
}
