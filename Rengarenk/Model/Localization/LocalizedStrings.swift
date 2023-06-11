//
//  LocalizedStrings.swift
//  Rengarenk
//
//  Created by Mert Arıcan on 4.12.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import Foundation

struct LocalizedTitles {
    // MARK: Strings for title's of the menu pages.
    static var info: [String] { "INFO".localize().components(separatedBy: " ") }
    static var route: [String] { "ROUTE".localize().components(separatedBy: " ") }
    static var settings: [String] { "SETTINGS".localize().components(separatedBy: " ") }
    static var language: [String] { "LANGUAGE".localize().components(separatedBy: " ") }
    static var grandBazaar: [String] { "GRAND BAZAAR".localize().components(separatedBy: " ") }
}

struct LocalizedTexts {
    static var level: String { "LEVEL".localize() }
    static var correct: String { "CORRECT".localize() }
    static var simurghInstruction: String { "SIMURGH INSTRUCTION".localize() }
    static var fortune: String { "FORTUNE".localize() }
    static var simurgh: String { "SIMURGH".localize() }
    static var apocalypse: String { "APOCALYPSE".localize() }
    static var grandBazaar: String { "GRAND BAZAAR".localize() }
    static var fortuneDesc: String { "FORTUNE DESCRIPTION".localize() }
    static var simurghDesc: String { "SIMURGH DESCRIPTION".localize() }
    static var apocalypseDesc: String { "APOCALYPSE DESCRIPTION".localize() }
    static var grandBazaarBuy: String { "GRANDBAZAAR DESCRIPTION".localize() }
    static var completed: String { "COMPLETED".localize() }
    static var reward: String { "REWARD".localize() }
    static var restorePurchases: String { "RESTORE PURCHASES".localize() }
    static var sound: String { "SOUND".localize() }
    static var flyingMode: String { "FLYING MODE".localize() }
    static var language: String { "LANGUAGE".localize() }
    static var restore: String { "RESTORE".localize() }
    static var change: String { "CHANGE".localize() }
    static var on: String { "ON".localize() }
    static var off: String { "OFF".localize() }
    static var turnOn: String { "TURN ON".localize() }
    static var turnOff: String { "TURN OFF".localize() }
    static var octupleTitle: String { "COLORFUL OCTUPLE".localize() }
    static var okay: String { "OKAY".localize() }
    static var octupleDescription: String { "COLORFUL OCTUPLE DESCRIPTION".localize() }
    static var buy: String { "BUY".localize() }
    static var error: String { "ERROR".localize() }
    static var allLevelsCompletedTitle: String { "ALL LEVELS COMPLETED TITLE".localize() }
    static var allLevelsCompletedMessage: String { "ALL LEVELS COMPLETED MESSAGE".localize() }
    static var restoredSuccessfully: String { "RESTORED SUCCESSFULLY".localize() }
    static var roadmapImageNames: [String] { (0...24).map { "IMG\($0)".localize() } }
    static var infoDescriptions: [String] { (1...5).map { "INFO\($0)".localize() } }
    static var marketItemTitles: [String] { (1...8).map { "COLORFUL BUNDLE".localize() + " \(RomenNumbers.getRomen(of: $0))" } }
}

fileprivate extension String {
    func localize() -> String {
        return localizations[self] ?? "NIL"
    }
}

enum RomenNumbers: String {
    case one = "I"
    case two = "II"
    case three = "III"
    case four = "IV"
    case five = "V"
    case six = "VI"
    case seven = "VII"
    case eight = "VIII"
    
    static var allCases = [one, two, three, four, five, six, seven, eight]
    static func getRomen(of number: Int) -> String { allCases[number-1].rawValue }
}
