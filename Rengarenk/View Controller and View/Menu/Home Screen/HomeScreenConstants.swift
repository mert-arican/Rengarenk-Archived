//
//  HomeScreenConstants.swift
//  Flying Letters
//
//  Created by Mert Arıcan on 3.11.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

struct HomeScreenConstants {
    static var isReallyBig: Bool { isPro }
    static var preferredFontSize: CGFloat { isPad ? 28.0 : 17.0 }
    static var titleSquareLength: CGFloat { isPad ? (isReallyBig ? 80.0 : 65.0) : 48.0 }
    static var buttonLength: CGFloat { titleSquareLength + 10.0 } // { isPad ? (isReallyBig ? 120.0 : 90.0) : 70.0 }
    static var titleSpacing: CGFloat { isPad ? (isReallyBig ? 8.0 : 7.0) : 4.0 }
    static var menuButtonSpacing: CGFloat { titleSpacing + (isPad ? 20.0 : 8.0) } // { isPad ? 15.0 : 10.0 }
    
    // MARK: - Buttons
    
    static let buttonShortcuts = ["IMS"]
    static let infoButtonID = "Info Button"
    static let roadmapButtonID = "Roadmap Button"
    static let marketButtonID = "Market Button"
    static let settingsButtonID = "Settings Button"
    
    static let menuControllerIdentifiers: [String] = [
        "InfoMVC", "MarketVC", "SettingsMVC"
    ]
    
    static let menuButtons = [
        infoButtonID,
//        roadmapButtonID,
        marketButtonID,
        settingsButtonID
    ]
    
    static let assets: [String : String] = [
        infoButtonID: "info.circle",
//        roadmapButtonID: "map",
        marketButtonID : "cart",
        settingsButtonID : "gear"
    ]
}
