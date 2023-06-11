//
//  Localizations.swift
//  Rengarenk
//
//  Created by Mert Arıcan on 4.12.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import Foundation

struct Localizations: Codable {
    var localizations = [String : [String : String]]()
    
    subscript(key: String) -> String? {
        return localizations[key]?[UserPreferences.languageCode]
    }
    
    init() {  }
    
    init?(json: Data?) {
        if json != nil, let decodedLocalizations = try? JSONDecoder().decode(Localizations.self, from: json!) {
            self = decodedLocalizations
        } else { return nil }
    }
}
