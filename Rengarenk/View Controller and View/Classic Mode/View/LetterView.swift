//
//  LetterView.swift
//  Color Coded
//
//  Created by Mert Arıcan on 11.11.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

class LetterView: UIView {
    // MARK: - Public API
    var letter: Letter!
    var isJoker: Bool { letter.isJoker }
    var isFixed: Bool { matchedAnswerCell != nil }
    var coordinate: (row: Int, col: Int)!
    var matchedAnswerCell: AnswerCellView?
    var lastFrame: CGRect!
    
    func showSelection() {
        self.contentView.layer.borderColor = self.contentView.backgroundColor?.adjust(by: -20)?.cgColor
        self.contentView.layer.borderWidth = 2.0
    }
    
    func showDeselection() {
        self.contentView.layer.borderWidth = 0.0
    }
    
    func showJoker() {
        guard isJoker else { return }
        self.contentView.backgroundColor = Colors.correctClr
    }
    
    func setBackground(_ color: UIColor) {
        self.contentView.backgroundColor = color
    }
    
    func updateFont() {
        // For size updates
        contentView.subviews.compactMap { $0 as? UILabel }.first?.font = UIFont(name: "Futura-Medium", size: DesignConstants.fontSize)
    }
    
    // MARK: - Prepare view
    
    private var contentView = UIView()
    private var properBackgroundColor: UIColor { Colors[letter.answerID] }
    
    func drawContents() {
        self.subviews.forEach { $0.removeFromSuperview() }
        contentView.subviews.forEach { $0.removeFromSuperview() }
        self.backgroundColor = properBackgroundColor
        self.getCommonCornerRadius()
        let letterLabel = UILabel(frame: self.bounds)
        letterLabel.font = UIFont(name: "Futura-Medium", size: DesignConstants.fontSize)
        letterLabel.textColor = .white
        letterLabel.textAlignment = .center
        letterLabel.text = letter.character
        letterLabel.contentMode = .center
        self.isUserInteractionEnabled = false
        contentView = UIView(frame: self.bounds)
        contentView.backgroundColor = properBackgroundColor
        contentView.getCommonCornerRadius()
        contentView.addSubview(letterLabel)
        self.addSubview(contentView)
        self.dropShadow(cornerRadius: contentView.commonCornerRadius)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        letterLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    // MARK: - Inheritance methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.getCommonCornerRadius()
        self.contentView.getCommonCornerRadius()
        self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.commonCornerRadius).cgPath
    }
}
