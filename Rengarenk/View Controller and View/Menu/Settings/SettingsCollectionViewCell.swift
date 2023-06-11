//
//  SettingsCollectionViewCell.swift
//  Rengarenk
//
//  Created by Mert Arıcan on 18.11.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

class SettingsCollectionViewCell: UICollectionViewCell {
    var item: SettingsItem! { didSet { prepareView() } }
    var present: ((UIViewController)->())?
    
    // MARK: - Prepare view
    
    private lazy var itemView = self.getContentView()
    private lazy var shadowView = self.getContentView()
    private var padding: CGFloat { isPad ? (isPro ? 90.0 : 70.0) : 60.0 }
    
    private func getFrameForTitle() -> CGRect {
        let height = self.bounds.height * 1.4 / 7
        let originY = self.bounds.minY
        let origin = CGPoint(x: 0.0, y: originY)
        let size = CGSize(width: self.bounds.width, height: height)
        return .init(origin: origin, size: size)
    }
    
    private func getFrameBetween() -> CGRect {
        let titleFrame = getFrameForTitle()
        let buttonFrame = getFrameForButton()
        let origin = titleFrame.offsetBy(dx: 0.0, dy: titleFrame.height).origin
        let size = CGSize(width: self.bounds.width, height: buttonFrame.origin.y - titleFrame.height)
        return .init(origin: origin, size: size)
    }
    
    private func getFrameForButton() -> CGRect {
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
    
    func prepareView() {
        itemView.subviews.forEach { $0.removeFromSuperview() }
        
        let randomColor = Colors.randomColor
        
        // MARK: Title
        let title = CustomInfoLabel(frame: getFrameForTitle())
        title.font = theFont
        title.textColor = .white
        title.textAlignment = .center
        title.numberOfLines = 2
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.1
        title.text = item.title
        title.backgroundColor = randomColor.adjust(by: -20.0)
        itemView.addSubview(title)
        
        // MARK: View Between
        let frameBetween = getFrameBetween()
        if let imageName = item.imageName {
            let imageView = UIImageView(frame: frameBetween.padding(horizontal: (self.bounds.width - padding)/2, vertical: (frameBetween.height - padding)/2)!)
            imageView.tintColor = .white
            imageView.image = UIImage(systemImageWithBackupNamed: imageName)
            itemView.backgroundColor = randomColor
            itemView.addSubview(imageView)
        } else if let description = item.description {
            let descriptionLabel = UILabel(frame: frameBetween)
            descriptionLabel.textColor = .white
            descriptionLabel.textAlignment = .center
            descriptionLabel.font = theFont
            descriptionLabel.text = description
            descriptionLabel.backgroundColor = randomColor
            itemView.addSubview(descriptionLabel)
        }
        
        // MARK: Buy Button
        let button = UIButton(type: .system)
        button.frame = getFrameForButton()
        button.titleLabel?.font = theFont
        button.setTitleColor(.white, for: .normal)
        button.setTitle(item.buttonTitle, for: .normal)
        button.backgroundColor = title.backgroundColor
        button.isUserInteractionEnabled = false
        itemView.addSubview(button)
        self.addTarget()
        self.sendSubviewToBack(shadowView)
        shadowView.dropShadow()
    }
    
    // MARK: - Gestures
    
    private func addTarget() {
        switch self.item.index {
        case 0: self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(restorePurchases(_:))))
        case 1: self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presenLanguage(_:))))
        case 2: self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleSound(_:))))
        case 3: self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleFlyingMode(_:))))
        default: break
        }
    }
    
    @objc private func restorePurchases(_ sender: UITapGestureRecognizer) {
        MarketViewController.storeObserver.restore()
    }
    
    @objc private func toggleFlyingMode(_ sender: UITapGestureRecognizer) {
        UserDefaults.standard.set(!UserPreferences.flyingModeIsActive, forKey: "flyingMode")
        UserPreferences.flyingModeIsActive.toggle()
        if let collectionView = self.superview as? UICollectionView {
            collectionView.reloadItems(at: [IndexPath(item: self.item.index, section: 0)])
        }
    }
    
    @objc private func presenLanguage(_ sender: UITapGestureRecognizer) {
        let languageViewController = Constantstinopolis.getViewController(name: "Menu", withIdentifier: "LanguageMVC")
        present?(languageViewController)
    }
    
    @objc private func toggleSound(_ sender: UITapGestureRecognizer) {
        UserDefaults.standard.set(!UserPreferences.soundsIsOn, forKey: "sound")
        if let collectionView = self.superview as? UICollectionView {
            collectionView.reloadItems(at: [IndexPath(item: self.item.index, section: 0)])
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.itemView.subviews.forEach { $0.alpha = 0.7 }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.itemView.subviews.forEach { $0.alpha = 1.0 }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.itemView.subviews.forEach { $0.alpha = 1.0 }
    }
}
