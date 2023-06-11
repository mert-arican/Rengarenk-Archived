//
//  SealSymbolView.swift
//  Rengarenk
//
//  Created by Mert Arıcan on 4.12.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

class SealSymbolView: UIView {
    private lazy var k: CGFloat = { self.bounds.width / 19.8 }()
    private static let factors: [(CGFloat, CGFloat)] = [(0.0, 9.9), (2.9, 6.9), (2.9, 2.9), (6.9, 2.9), (9.9, 0.0)]
    
    private func getPoints() -> [CGPoint] {
        var all = SealSymbolView.factors.map { CGPoint(x: $0.0*k, y: $0.1*k) }
        let tmp = all.reversed() as [CGPoint] ; let tmp2 = all
        all.append(contentsOf: tmp.map { CGPoint(x: (9.9*k)+((9.9*k)-$0.x), y: $0.y) })
        all.append(contentsOf: tmp2.map { CGPoint(x: (9.9*k)+((9.9*k)-$0.x), y: (9.9*k)+((9.9*k)-$0.y)) })
        all.append(contentsOf: tmp.map { CGPoint(x: $0.x, y: (9.9*k) + ((9.9*k)-$0.y)) })
        return all
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = false
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {
        let points = getPoints()
        let path = UIBezierPath()
        path.move(to: points[0])
        for i in 1...points.indices.last! {
            path.addLine(to: points[i])
        }
        path.lineWidth = 1.6
        #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).setStroke()
        path.stroke()
    }
}
