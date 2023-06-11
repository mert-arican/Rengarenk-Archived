//
//  NextView.swift
//  Rengarenk
//
//  Created by Mert Arıcan on 16.12.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit
import StoreKit

class NextView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.backgroundColor = Colors.randomColor
        self.getCommonCornerRadius()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var reward: PowerUp?
    var nextCategory: (()->())?
    @objc private func _nextCategory() { self.nextCategory?(); self.subviews.forEach { $0.removeFromSuperview() } }
    
    func getRewardDescription(rewar: PowerUp?=nil) -> String {
        guard let reward = rewar ?? self.reward else { return "" }
        let quantifier = "\(LocalizedTexts.reward)" + (Constantstinopolis.appState.octupledCategoryRewards ? ": 8 x" : ": 2 x")
        switch reward {
        case .fortune: return "\(quantifier) \(LocalizedTexts.fortune)"
        case .simurgh: return "\(quantifier) \(LocalizedTexts.simurgh)"
        case .apocalypse: return "\(quantifier) \(LocalizedTexts.apocalypse)"
        }
    }
    
    func indicateLabel(label: UILabel, count: Int = 0) {
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.3,
            delay: 0.0,
            options: .curveLinear,
            animations: { label.alpha = (label.alpha == 0.0) ? 1.0 : 0.0 }
        ) { _ in if count < 3 { self.indicateLabel(label: label, count: count+1) } }
    }
    
    private var bottomView = UIView()
    
    private func getRewardLabel(bottomFrame: CGRect, reward: PowerUp?=nil) {
        let label = UILabel(frame: bottomFrame)
        label.textColor = .white
        label.textAlignment = .center
        label.font = theFont.withSize(isPad ? 18.0 : 14.0)
        label.text = getRewardDescription(rewar: reward)
        label.backgroundColor = self.backgroundColor?.adjust(by: -20.0)
        self.addSubview(label)
        bottomView = label
    }
    
    func prepareView() {
        let border = self.bounds.padding(10.0)!
        let h = border.height / 7.0
        let labelFrame = CGRect(x: border.minX-10.0, y: border.minY-10.0, width: border.width+20, height: h+10.0)
        
        let completedLabel = UILabel(frame: labelFrame)
        completedLabel.textAlignment = .center
        completedLabel.textColor = .white
        completedLabel.font = theFont
        completedLabel.adjustsFontSizeToFitWidth = true
        completedLabel.minimumScaleFactor = 0.1
        completedLabel.clipsToBounds = true
        completedLabel.text = "\(LocalizedTexts.level) \(LocalizedTexts.completed)"
        completedLabel.backgroundColor = self.backgroundColor?.adjust(by: -20.0)
        self.addSubview(completedLabel)
        self.clipsToBounds = true
        
        let bottomFrame = CGRect(x: border.minX-10.0, y: border.maxY-h, width: border.width+20.0, height: h+10.0)
        if reward == nil {
            let label = UILabel(frame: bottomFrame)
            label.backgroundColor = self.backgroundColor?.adjust(by: -20.0)
            self.addSubview(label)
            bottomView = label
        } else { getRewardLabel(bottomFrame: bottomFrame) }
        
        let categoryIndex = Constantstinopolis.categoryIndex
        let squareFrame = CGRect(x: border.minX+(1.5*h), y: completedLabel.frame.maxY + (h/2.0), width: border.width-(3*h), height: 4*h)
        var revImg = (4*h)/10.0*(CGFloat(categoryIndex % 10)-1)
        var revH = (4*h)/10.0*(CGFloat(categoryIndex % 10))
        if categoryIndex % 10 == 0 {
            revImg = (4*h)/10.0*9.0 ; revH = (4*h)
        }
        
        let bView = UIView(frame: squareFrame)
        bView.getCommonCornerRadius()
        bView.clipsToBounds = true
        self.addSubview(bView)
        
        let sq2 = CGRect(origin: bView.bounds.origin, size: .init(width: bView.bounds.width, height: 4*h - revH))
        
        let square = UIView(frame: .init(origin: bView.bounds.origin, size: .init(width: bView.bounds.width, height: 4*h - revImg)))
        square.backgroundColor = self.backgroundColor?.adjust(by: -20.0)
        bView.addSubview(square)
        
        let nextTitle = UIButton(type: .system)
        nextTitle.frame = bView.bounds
        nextTitle.titleLabel?.font = theFont
        nextTitle.setTitleColor(.white, for: .normal)
        nextTitle.setTitle("\(LocalizedTexts.level) \(categoryIndex)", for: .normal)
        bView.addSubview(nextTitle)
        nextTitle.addTarget(self, action: #selector(_nextCategory), for: .touchUpInside)
        
        let imageV = UIImageView(frame: squareFrame)
        imageV.backgroundColor = self.backgroundColor
        imageV.alpha = 0.4
        imageV.layer.borderWidth = 1.4
        imageV.layer.borderColor = square.backgroundColor?.cgColor
        self.addSubview(imageV)
        imageV.contentMode = .scaleAspectFill
        self.sendSubviewToBack(imageV)
        imageV.clipsToBounds = true
        imageV.getCommonCornerRadius()
        self.clipsToBounds = true
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 1.4,
            delay: 0.0,
            options: .curveEaseInOut,
            animations: { square.frame = sq2 })
        
        if Constantstinopolis.categoryIndex % 20 == 0 {
            SKStoreReviewController.requestReview()
        }
    }
}

