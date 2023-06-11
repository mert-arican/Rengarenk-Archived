//
//  Colors.swift
//  Seven Words
//
//  Created by Mert Arıcan on 30.09.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

let theColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1).adjust(by: -10.0)!

/// Struct for colors of the game.
struct Colors {
    private static var allColors: [UIColor] {  [#colorLiteral(red: 0.08393948525, green: 0.4489227533, blue: 0.9299840331, alpha: 1), #colorLiteral(red: 0.2405773699, green: 0.7062084079, blue: 1, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1).adjust(by: -14.0)!, #colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1), #colorLiteral(red: 1, green: 0.3735414147, blue: 0.5522007346, alpha: 1), #colorLiteral(red: 0.9411380291, green: 0.09814669937, blue: 0.2134164572, alpha: 1), clrP] }
    private static var clrP: UIColor { [#colorLiteral(red: 0.5148210526, green: 0.455485642, blue: 0.6614447236, alpha: 1), #colorLiteral(red: 0.6042832136, green: 0.5346438885, blue: 0.7763594985, alpha: 1)].randomElement()! }
    static let hagiaSophia = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
    static let imperialP = #colorLiteral(red: 0.4, green: 0.007843137255, blue: 0.2352941176, alpha: 1)
    static let correctClr = #colorLiteral(red: 0.05602998286, green: 0.6727496386, blue: 0.05504766852, alpha: 1)
    static var colorDict = [UIColor]()
    static var randomColor: UIColor { allColors.randomElement()! }
    static var currentColor: UIColor { self[appWide_currentAnswerID] }
    
    static subscript(index: Int) -> UIColor {
        return index < colorDict.count ? colorDict[index] : .gray
    }
    
    static var forGradient: [CGColor] { self.allColors.map { $0.cgColor } }
    
    static func getMixedColorsFromColorWheel(of number: Int, forHome: Bool = false) -> [UIColor] {
        let _allColors = !forHome ? self.allColors : [#colorLiteral(red: 0.08393948525, green: 0.4489227533, blue: 0.9299840331, alpha: 1), #colorLiteral(red: 0.2405773699, green: 0.7062084079, blue: 1, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1).adjust(by: -14.0)!, #colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1), #colorLiteral(red: 1, green: 0.3735414147, blue: 0.5522007346, alpha: 1), #colorLiteral(red: 0.9411380291, green: 0.09814669937, blue: 0.2134164572, alpha: 1), #colorLiteral(red: 0.5148210526, green: 0.455485642, blue: 0.6614447236, alpha: 1)]
        var colors = [UIColor]()
        let randomIndex = allColors.indices.randomElement()!
        for index in 0..<number {
            let ind = (randomIndex + index) % _allColors.count
            colors.append(_allColors[ind])
        }
        return colors.reversed()
    }
    
    static func prepareColors() {
        colorDict = []
        var allAvailableColors = allColors
        for _ in 0...12 { colorDict.append( allAvailableColors.popRandomElement() ?? .gray) }
    }
    
    static func random(except: [UIColor]) -> UIColor {
        var colors = allColors
        except.forEach { colors.removeFirstAppearance($0) }
        return colors.popRandomElement()!
    }
    
    static func getMixedColors(of number: Int, except: [UIColor]? = nil) -> [UIColor] {
        var colors = allColors ; var mixedColors = [UIColor]()
        except?.forEach { colors.removeFirstAppearance($0) }
        for _ in 0..<number {
            if colors.isEmpty {
                colors = mixedColors ; colors.removeLast()
            }
            mixedColors.append(colors.popRandomElement()!)
        }
        return mixedColors
    }
}
