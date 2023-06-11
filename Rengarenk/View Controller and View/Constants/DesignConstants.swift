//
//  DesignConstants.swift
//  Rengarenk
//
//  Created by Mert Arıcan on 5.12.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

let theFont = UIFont(name: "Futura-Medium", size: DesignConstants.staticFontSize)!

/// Struct for holding the design constants for the design of the game.
struct DesignConstants {
    static var titleOffset: CGFloat { isPad ? 16.0 : 8.0 }
    static var spacing: CGFloat = isPad ? (isPro ? 7.2 : 4.8) : 3.0
    static var standartSizeForLetter: CGSize {
        let standartLength = isPad ? (isPro ? 90.0 : 80.0) : 65.0
        return CGSize(squareWith: CGFloat(standartLength))
    }
    static var standartSizeForAnswerCell: CGFloat { isPad ? (isPro ? 80 : 70) : 45 }
    static var questionHeight: CGFloat { isPad ? (isPro ? 75 : 60) : 50 }
    
    static let shrinkBarrier = 35
    
    static var scaleForFlies: CGFloat = 1.0
    static var fontSize: CGFloat { (isPad ? (isPro ? 55 : 45) : 35) * scaleForFlies }
    
    static var staticFontSize: CGFloat { isPad ? (isPro ? 27.0 : 22.0) : 18.0 }
    static var questionFontSize: CGFloat { isPad ? 25 : 20 }
    
    static var powerWidth: CGFloat { isPad ? 400 : 300 }
    static var powerHeight: CGFloat { isPad ? 75 : 48 }
}
