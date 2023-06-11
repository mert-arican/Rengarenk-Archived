//
//  NewInfoItemCollectionViewCell.swift
//  Rengarenk
//
//  Created by Mert Arıcan on 20.01.2021.
//  Copyright © 2021 Mert Arıcan. All rights reserved.
//

import UIKit

class NewInfoItemCollectionViewCell: UICollectionViewCell {
    var item: InfoItem! { didSet { self.prepareView() } }
    
    private func prepareView() {
        self.subviews.forEach { $0.removeFromSuperview() }
        let label = UILabel(frame: self.bounds.padding(horizontal: 7.0) ?? self.bounds)
        label.text = item.description
        label.font = theFont
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.05
        self.addSubview(label)
    }
}
