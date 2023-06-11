//
//  MarketItem.swift
//  Flying Letters
//
//  Created by Mert Arıcan on 3.11.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import Foundation

struct MarketItem {
    let title: String
    var consumableEffect: [Int]?
    var colorfulEight: Bool?
    let productIdentifier: String
    
    var isConsumable: Bool { consumableEffect != nil }
    
    private static var allTitles = LocalizedTexts.marketItemTitles
    
    private static func getIDForConsumable(index: Int) -> String {
        return "com.example.mertarican.RengarenkWords.ColorfulBundle\(index)"
    }
    
    private static func getIDForNonConsumable(postfix: String) -> String {
        return "com.example.mertarican.RengarenkWords.\(postfix)"
    }
    
    // Consumables
    private static var colorfulBundles: [MarketItem] {
        [
        MarketItem(title: allTitles[0], consumableEffect: [5, 5, 5], productIdentifier: getIDForConsumable(index: 1)), // 0.99 Alternate tier 2
        MarketItem(title: allTitles[1], consumableEffect: [7, 7, 4], productIdentifier: getIDForConsumable(index: 2)), // 2.99
        MarketItem(title: allTitles[2], consumableEffect: [16, 16, 8], productIdentifier: getIDForConsumable(index: 3)), // 4.49
        MarketItem(title: allTitles[3], consumableEffect: [28, 28, 14], productIdentifier: getIDForConsumable(index: 4)), // 6.99
        MarketItem(title: allTitles[4], consumableEffect: [42, 42, 20], productIdentifier: getIDForConsumable(index: 5)), // 9.99
        MarketItem(title: allTitles[5], consumableEffect: [42, 42, 42], productIdentifier: getIDForConsumable(index: 6)), // 12.99
        MarketItem(title: allTitles[6], consumableEffect: [72, 72, 50], productIdentifier: getIDForConsumable(index: 7)), // 16.99
        MarketItem(title: allTitles[1], consumableEffect: [100, 100, 100], productIdentifier: getIDForConsumable(index: 8)) // 22.99
        ]
    }
    
    // Nonconsumables
    private static var colorfulEight: MarketItem {  MarketItem(title: LocalizedTexts.octupleTitle, colorfulEight: true, productIdentifier: getIDForNonConsumable(postfix: "Octuple")) } // 4.49
    
    static func prepareAllItems() {
        allTitles = LocalizedTexts.marketItemTitles
//        allItems = [colorfulEight] + colorfulBundles
        allItems = colorfulBundles
    }
    
    static func getDescriptionForConsumableEffect(effect: [Int]) -> [String] {
        let titles = ["\(LocalizedTexts.fortune)", "\(LocalizedTexts.simurgh)", "\(LocalizedTexts.apocalypse)"]
        return (0...2).map { "\(effect[$0])x \(titles[$0])" }
    }
    
    static var allItems: [MarketItem] = []
    
    static var allIdentifiers: Set<String> { Set(allItems.map { $0.productIdentifier }) }
    
    static func productBought(withProductID productIdentifier: String) {
        if let item = allItems.first(where: { $0.productIdentifier == productIdentifier }) {
            if item.isConsumable { Constantstinopolis.appState.updateAfterConsumableDeal(products: item.consumableEffect!) }
            else { Constantstinopolis.appState.updateAfterNonConsumableDeal(octupledEarnings: item.colorfulEight!) }
        }
    }
}
