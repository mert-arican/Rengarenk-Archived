//
//  PowerUpButton.swift
//  Flying Letters
//
//  Created by Mert Arıcan on 21.10.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

class PowerUpButton: UIButton {
    private var coolLayer: CAGradientLayer!
    
    func dop() {
        coolLayer = CAGradientLayer()
        coolLayer.removeFromSuperlayer()
        let clr = Colors.correctClr.withAlphaComponent(0.0).cgColor
        let l = coolLayer!
        l.type = .radial
        l.colors = [
            self.backgroundColor?.adjust(by: -20)?.cgColor ?? clr,
            self.backgroundColor?.adjust(by: -20)?.cgColor ?? clr,
            self.backgroundColor?.cgColor ?? UIColor.clear.cgColor
        ]
        l.locations = [0, 0.4, 0.7, 1]
        l.startPoint = CGPoint(x: 0.5, y: 0.5)
        l.endPoint = CGPoint(x: 0.8, y: 0.8)
        l.frame = self.bounds
        l.cornerRadius = self.layer.cornerRadius
        self.layer.addSublayer(l)
        self.layer.zPosition = 1000
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.clipsToBounds = true
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        self.subviews.forEach { $0.removeFromSuperview() }
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        dop()
        let symbolRect = self.bounds.padding(6.0)!
        let symbolView = SealSymbolView(frame: symbolRect)
        self.addSubview(symbolView)
    }
}
