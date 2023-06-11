//
//  QuestionView.swift
//  Rengarenk
//
//  Created by Mert Arıcan on 9.12.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

class CommonLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.textColor = .white
        self.textAlignment = .center
        self.clipsToBounds = true
        self.getCommonCornerRadius()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class QuestionView: UIView {
    var scrollView = UIScrollView()
    var questionLabel = CommonLabel()
    var question: (()->String)?
    
    func initializeScroll() {
        
        // MARK: - Caution: Should called after geometry is valid.
        self.getCommonCornerRadius()
        self.dropShadow()
        scrollView.frame = self.bounds
        self.addSubview(scrollView)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        questionLabel.frame = scrollView.bounds
        questionLabel.text = question?()
        scrollView.addSubview(questionLabel)
        questionLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        updateQuestionLabel()
    }
    
    func initialize(question: @escaping ()->(String)) {
        // Can be called any time.
        self.clipsToBounds = true
        self.backgroundColor = Colors.currentColor
        self.question = question
        questionLabel.font = theFont.withSize(DesignConstants.questionFontSize)
    }
    
    func updateQuestionLabel() {
        self.dropShadow()
        scrollView.contentOffset = .zero
        scrollView.frame = self.bounds
        questionLabel.frame = scrollView.bounds
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        questionLabel.numberOfLines = 0
        questionLabel.text = question?()
        questionLabel.sizeToFit()
        questionLabel.frame.size = .init(width: scrollView.bounds.width, height: max(questionLabel.bounds.height, scrollView.bounds.height))
        scrollView.contentSize = .init(width: scrollView.bounds.width, height: questionLabel.bounds.height)
    }
}
