//
//  UserPreferences.swift
//  Rengarenk
//
//  Created by Mert Arıcan on 13.12.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import Foundation

/// Custom struct for storing user preferences.
struct UserPreferences {
    static let languages = [
        "tr" : "TÜRKÇE",
        "en" : "ENGLISH"
    ]
    static var language: String { languages[languageCode] ?? "ENGLISH" }
    static var languageCode: String {
        if let code = UserDefaults.standard.string(forKey: "language") { return code }
        if let current = Locale.current.languageCode { return languages.keys.contains(current) ? current : "en" }
        return "en"
    }
    static var soundsIsOn: Bool {
        return UserDefaults.standard.object(forKey: "sound") != nil ? UserDefaults.standard.bool(forKey: "sound") : true
    }
    static var flyingModeIsActive = false
}
