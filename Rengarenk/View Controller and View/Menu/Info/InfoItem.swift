//
//  InfoItem.swift
//  Rengarenk
//
//  Created by Mert Arıcan on 21.11.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import Foundation

struct InfoItem {
    let imageName: String
    let description: String
    
    static var allInfoDescriptions = LocalizedTexts.infoDescriptions
    
    static var allItems: [InfoItem] {
        return (0...4).map { InfoItem(imageName: "INFO\($0)", description: allInfoDescriptions[$0]) }
    }
}
