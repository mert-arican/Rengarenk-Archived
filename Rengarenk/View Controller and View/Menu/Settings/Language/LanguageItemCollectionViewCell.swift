//
//  LanguageItemCollectionViewCell.swift
//  Rengarenk
//
//  Created by Mert Arıcan on 3.12.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

class LanguageItemCollectionViewCell: UICollectionViewCell {
    var item: LanguageItem! { didSet { prepareView() } }
    
    // MARK: - Prepare view
    
    private lazy var itemView = self.getContentView()
    private lazy var shadowView = self.getContentView()
    
    private func getFrameForTop() -> CGRect {
        let height = self.bounds.height * 1.4 / 7
        let originY = self.bounds.minY
        let origin = CGPoint(x: 0.0, y: originY)
        let size = CGSize(width: self.bounds.width, height: height)
        return .init(origin: origin, size: size)
    }
    
    private func getFrameBetween() -> CGRect {
        let titleFrame = getFrameForTop()
        let buttonFrame = getFrameForBottom()
        let origin = titleFrame.offsetBy(dx: 0.0, dy: titleFrame.height).origin
        let size = CGSize(width: self.bounds.width, height: buttonFrame.origin.y - titleFrame.height)
        return .init(origin: origin, size: size)
    }
    
    private func getFrameForBottom() -> CGRect {
        let height = self.bounds.height * 1.4 / 7
        let originY = self.bounds.maxY - height
        let origin = CGPoint(x: 0.0, y: originY)
        let size = CGSize(width: self.bounds.width, height: height)
        return .init(origin: origin, size: size)
    }
    
    private func getContentView() -> UIView {
        let view = UIView(frame: self.bounds)
        view.clipsToBounds = true
        view.getCommonCornerRadius()
        self.addSubview(view)
        return view
    }
    
    private func prepareView() {
        self.itemView.subviews.forEach { $0.removeFromSuperview() }
        
        let randomColor = Colors.randomColor
        
        self.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.layer.borderWidth = item.isSelected ? 4.0 : 0.0
        
        // MARK: Top
        let top = UIView(frame: getFrameForTop())
        top.backgroundColor = randomColor.adjust(by: -20.0)
        itemView.addSubview(top)
        
        // MARK: View Between
        let label = UILabel(frame: self.getFrameBetween())
        label.textColor = .white
        label.backgroundColor = randomColor
        label.font = theFont.withSize(isPad ? 40.0 : 30.0)
        label.textAlignment = .center
        label.text = UserPreferences.languages[item.languageCode]
        label.clipsToBounds = true
        itemView.addSubview(label)
        
        // MARK: Bottom
        let bottom = UIView(frame: getFrameForBottom())
        bottom.backgroundColor = randomColor.adjust(by: -20.0)
        itemView.addSubview(bottom)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectLanguage(_:))))
        self.sendSubviewToBack(shadowView)
        shadowView.dropShadow()
    }
    
    // MARK: - Gestures
    
    @objc private func selectLanguage(_ sender: UITapGestureRecognizer) {
        if let cell = sender.view as? LanguageItemCollectionViewCell, let code = cell.item?.languageCode {
            UserDefaults.standard.set(code, forKey: "language")
            if let collectionView = self.superview as? UICollectionView {
                collectionView.reloadData()
            }
            Constantstinopolis.loadCategories()
        }
    }
}
