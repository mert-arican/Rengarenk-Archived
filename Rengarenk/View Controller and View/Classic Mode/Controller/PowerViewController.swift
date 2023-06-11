//
//  PowerViewController.swift
//  Flying Letters
//
//  Created by Mert Arıcan on 22.10.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

class PowerViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var topLevelView: UIStackView!
    @IBOutlet private var buttons: [SurroundingButton]!
    
    @IBOutlet private weak var width: NSLayoutConstraint!
    @IBOutlet private weak var height: NSLayoutConstraint!
    
    static var assets: [(title: String, description: String)] {
        [
            (LocalizedTexts.fortune, LocalizedTexts.fortuneDesc),
            (LocalizedTexts.simurgh, LocalizedTexts.simurghDesc),
            (LocalizedTexts.apocalypse, LocalizedTexts.apocalypseDesc),
            (LocalizedTexts.grandBazaar, LocalizedTexts.grandBazaarBuy)
        ]
    }
    
    var resignationHandler: ((String)->())?
    var allPowers: [Int]!
    
    private func setButtons() {
        var mixedColors = Colors.getMixedColorsFromColorWheel(of: 4)
        for (index, button) in buttons.enumerated() {
            let asset = PowerViewController.assets[index]
            button.subviews.forEach { $0.removeFromSuperview() }
            button.getCommonCornerRadius()
            var bounds = button.bounds.offsetBy(dx: 0.0, dy: 2.0)
            let titleLabelSize = CGSize(width: bounds.width, height: bounds.height/2)
            let titleLabel = UILabel(frame: CGRect(origin: bounds.origin, size: titleLabelSize))
            titleLabel.adjustsFontSizeToFitWidth = true
            titleLabel.minimumScaleFactor = 0.1
            titleLabel.text = (index < PowerViewController.assets.count-1) ? "\(asset.title) (\(allPowers[index])x)" : asset.title
            titleLabel.font = isPro ? theFont.withSize(theFont.pointSize-5.0) : theFont
            titleLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            titleLabel.textAlignment = .center
            button.addSubview(titleLabel)
            bounds = bounds.offsetBy(dx: 0.0, dy: -4.0)
            let descriptionLabelOrigin = bounds.origin.offsetBy(dx: 0.0, dy: titleLabelSize.height)
            let descriptionLabelSize = titleLabelSize
            let descriptionLabel = UILabel(frame: CGRect(origin: descriptionLabelOrigin, size: descriptionLabelSize))
            descriptionLabel.adjustsFontSizeToFitWidth = true
            descriptionLabel.minimumScaleFactor = 0.1
            descriptionLabel.text = asset.description
            descriptionLabel.textAlignment = .center
            descriptionLabel.textColor = .white
            button.name = asset.title
            button.addSubview(descriptionLabel)
            button.backgroundColor = mixedColors.popRandomElement()
            button.dropShadow()
        }
    }
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttons.forEach { $0.addGestureRecognizer(self.tapGesture) }
        self.view.backgroundColor = theColor
        width.constant = DesignConstants.powerWidth
        height.constant = DesignConstants.powerHeight
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let fittedSize = topLevelView?.sizeThatFits(UIView.layoutFittingCompressedSize) {
            preferredContentSize = CGSize(width: fittedSize.width+30, height: fittedSize.height+30)
        }
        setButtons()
    }
    
    // MARK: - Gestures
    
    private var tapGesture: UITapGestureRecognizer {
        return UITapGestureRecognizer(target: self, action: #selector(powerUp(_:)))
    }
    
    @objc private func powerUp(_ sender: UITapGestureRecognizer) {
        if let button = sender.view as? SurroundingButton {
            self.presentingViewController?.dismiss(animated: true) {
                self.resignationHandler?(button.name)
            }
        }
    }
}
