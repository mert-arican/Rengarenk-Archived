//
//  AnswerCellView.swift
//  Flying Letters
//
//  Created by Mert Arıcan on 7.10.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

class AnswerCellView: UIView {
    var index: Int!
    weak var matchedFlyingLetter: LetterView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Colors[appWide_currentAnswerID]
        self.isUserInteractionEnabled = false
        self.getCommonCornerRadius()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
