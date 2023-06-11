//
//  MarketItemCollectionViewCell.swift
//  Flying Letters
//
//  Created by Mert Arıcan on 3.11.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

class MarketItemCollectionViewCell: UICollectionViewCell {
    var item: MarketItem! { didSet { prepareView() } }
    var regularPrice: String? { MarketViewController.priceInfo[item.productIdentifier] }
    // MARK: - Preparing view
    
    private static let h: CGFloat = CGFloat(4)/CGFloat(21)
    private static let k: CGFloat = CGFloat(1)/CGFloat(7)
    private static let measures = [(0, k), (k, h), (k+h, h), (k+(2*h), h), (k+(3*h), 2*k)]
    
    private var placeholders = [CGRect]()
    
    private lazy var itemView = self.getContentView()
    private lazy var shadowView = self.getContentView()
    
    private func getPlaceholders() {
        placeholders = []
        let width = self.bounds.width
        for measure in MarketItemCollectionViewCell.measures {
            let origin = CGPoint(x: 0.0, y: width*measure.0)
            let size = CGSize(width: self.bounds.width, height: width*measure.1)
            let placeholderRect = CGRect(origin: origin, size: size)
            placeholders.append(placeholderRect)
        }
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
        let darker = randomColor.adjust(by: -20)
        itemView.backgroundColor = randomColor
        getPlaceholders()
        
        if let placeholder = placeholders.first {
            let titleLabel = MarketLabel(frame: placeholder.padding(0)!)
            titleLabel.text = item.title
            titleLabel.backgroundColor = darker
            itemView.addSubview(titleLabel)
        }
        
        if item.isConsumable {
            let descriptions = MarketItem.getDescriptionForConsumableEffect(effect: item.consumableEffect!)
            for (index, description) in descriptions.enumerated() {
                let placeholder = placeholders[index+1]
                let label = MarketLabel(frame: placeholder.padding(5.0)!)
                label.text = description
                itemView.addSubview(label)
            }
        } else {
            if item.title == LocalizedTexts.octupleTitle {
                let label = MarketLabel(frame: placeholders[2].padding(horizontal: 5.0)!)
                label.text = LocalizedTexts.octupleDescription
                itemView.addSubview(label)
            }
        }
        
        if let placeholder = placeholders.last {
            let buyButton = UIButton(type: .system)
            buyButton.frame = placeholder
            let title = regularPrice ?? LocalizedTexts.buy
            buyButton.setTitle(title, for: .normal)
            buyButton.titleLabel?.font = theFont
            buyButton.setTitleColor(.white, for: .normal)
            buyButton.isUserInteractionEnabled = false
            buyButton.backgroundColor = darker
            itemView.addSubview(buyButton)
        }
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(act(_:))))
        self.sendSubviewToBack(shadowView)
        shadowView.dropShadow()
    }
    
    // MARK: - Gestures
    
    @objc func act(_ sender: UITapGestureRecognizer) {
        if let productIdentifier = (sender.view as? MarketItemCollectionViewCell)?.item.productIdentifier {
            MarketViewController.storeObserver.buyProduct(withProductIdentifier: productIdentifier)
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

class MarketLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textColor = .white
        self.textAlignment = .center
        self.font = theFont.withSize(DesignConstants.staticFontSize)
        self.text = description
        self.textColor = .white
        
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.05
        self.numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIImage {
    convenience init?(systemImageWithBackupNamed name: String) {
        if #available(iOS 13.0, *) {
            self.init(systemName: name)
        } else {
            self.init(named: name)
        }
    }
}
