//
//  Constantstinopolis.swift
//  Seven Words
//
//  Created by Mert Arıcan on 30.09.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

/// Struct for holding various information about game and gameplay.
struct Constantstinopolis {
    // MARK: Variables for game and gameplay info.
    static var categories = [WordCategory]()
    static var appState = AppState()
    static var gameState: GameState {
        if let url = getApplicationSupportURLWithAppendingPathComponent(gamePathComponent),
            let json = try? Data(contentsOf: url), let state = GameState(json: json) {
                return state
        }
        return GameState()
    }
    static var categoryIndex: Int { gameState.categoryIndex }
    static var gamePathComponent: String { "\(UserPreferences.languageCode)Words" }
    static func loadCategories() { categories = load("\(gamePathComponent).json") }
    
    // MARK: Convenience functions and variables
    
    static func getViewController(name: String = "Main", bundle: Bundle? = nil, withIdentifier: String) -> UIViewController {
        let storyBoard = UIStoryboard(name: name, bundle: bundle)
        let viewController = storyBoard.instantiateViewController(withIdentifier: withIdentifier)
        return viewController
    }
    
    static func getApplicationSupportURLWithAppendingPathComponent(_ pathComponent: String) -> URL? {
        return try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent(pathComponent)
    }
    
    static func presentLevelsCompletedAlert(handler: @escaping ()->()) -> UIAlertController {
        let alert = UIAlertController(
            title: LocalizedTexts.allLevelsCompletedTitle,
            message: LocalizedTexts.allLevelsCompletedMessage,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: LocalizedTexts.okay,
            style: .default,
            handler: { _ in handler() }
            )
        )
        return alert
    }
}
