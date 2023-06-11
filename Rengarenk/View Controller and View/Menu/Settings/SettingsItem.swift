//
//  SettingsItem.swift
//  Rengarenk
//
//  Created by Mert Arıcan on 18.11.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import Foundation

struct SettingsItem {
    let index: Int
    let title: String
    let imageName: String?
    var description: String?
    var buttonTitle: String
    
    static var allItems: [SettingsItem] {
        [
            SettingsItem(index: 0, title: LocalizedTexts.restorePurchases, imageName: "purchased", buttonTitle: LocalizedTexts.restore),
            
            SettingsItem(index: 1, title: LocalizedTexts.language, imageName: nil, description: UserPreferences.language, buttonTitle: LocalizedTexts.change),
            
            SettingsItem(index: 2, title: "\(LocalizedTexts.sound): \(UserPreferences.soundsIsOn ? LocalizedTexts.on : LocalizedTexts.off)", imageName: UserPreferences.soundsIsOn ? "speaker.1" : "speaker.slash", buttonTitle: !UserPreferences.soundsIsOn ? LocalizedTexts.turnOn : LocalizedTexts.turnOff),
            
            SettingsItem(index: 3, title: "\(LocalizedTexts.flyingMode): \(!UserPreferences.flyingModeIsActive ? LocalizedTexts.on : LocalizedTexts.off)", imageName:  "paperplane", buttonTitle: UserPreferences.flyingModeIsActive ? LocalizedTexts.turnOn : LocalizedTexts.turnOff)
        ]
    }
}
