//
//  LanguageItem.swift
//  Rengarenk
//
//  Created by Mert Arıcan on 3.12.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import Foundation

struct LanguageItem {
    let languageCode: String
    var isSelected: Bool {
        UserPreferences.languageCode == self.languageCode
    }
    
    static let allItems = [
        LanguageItem(languageCode: "en"),
        LanguageItem(languageCode: "tr")
    ]
}
