//
//  AnswerArea.swift
//  Flying Letters
//
//  Created by Mert Arıcan on 8.10.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

class AnswerArea: UIView {
    private var answer = [String]()
    
    // MARK: - Public API
    
    private(set) var answerCells: [AnswerCellView] = []
    var tapForCell: (()->UITapGestureRecognizer)?
    var shiftAfterCorrectAnswer: (()->())?
    weak var letterBehavior: LetterBehavior?
    var touchFlyingLetter: ((LetterView)->())? {
        didSet {
            self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan(_:))))
            self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        }
    }
    var alertViewIsHidden: (()->Bool)?
    var showAlertView: ((Bool)->())?
    
    func setNewAnswer(answer: [String], afterCorrectAnswer: Bool = false) {
        // It can be either after correct answer or initial situation.
        self.answer = answer
        determineUnitLengthForAnswerCells()
        adjustAnswerForAnswerCellLayout()
        
        if CGFloat(numberOfLines) * unitLengthForAnswerCells > bounds.height {
            unitLengthForAnswerCells = (bounds.height - (CGFloat((numberOfLines - 1)) * spacing)) / CGFloat(numberOfLines)
        }
        
        if afterCorrectAnswer {
            // self.answerCells.forEach { $0.matchedFlyingLetter?.showCorrect() }
            shiftAfterCorrectAnswer?()
            Timer.scheduledTimer(withTimeInterval: AnimationConstants.correctAnswer, repeats: false) { (_) in
                guard self.superview != nil else { return }
                self.addOrRotateAnswerCells()
            }
        } else {
            self.addOrRotateAnswerCells()
        }
    }
    
    func updateAfterRotation() {
        determineUnitLengthForAnswerCells()
        adjustAnswerForAnswerCellLayout()
        if CGFloat(numberOfLines) * unitLengthForAnswerCells > bounds.height {
            unitLengthForAnswerCells = (bounds.height - (CGFloat((numberOfLines - 1)) * spacing)) / CGFloat(numberOfLines)
        }
        addOrRotateAnswerCells(forRotation: true)
    }
    
    @discardableResult
    func designForHome(length: CGFloat, origin: CGPoint?, spacing: CGFloat, answer: [String]) -> CGFloat {
        // Set title for specified length if it doesn't fit then set title with smaller size
        self.answer = answer
        self.spacing = spacing
        self.originForTitle = origin
        self.standartLengthForAnswerCells = length
        self.unitLengthForAnswerCells = length
        self.adjustAnswerForAnswerCellLayout()
        if getHorizontalOffset(forLine: 0) < 0 { // If it is out of bounds...
            determineUnitLengthForAnswerCells()
            adjustAnswerForAnswerCellLayout()
        }
        addOrRotateAnswerCells()
        return answerCells.last!.frame.maxY
    }
    
    // MARK: - Adjusting the length of the answer cells.
    
    private var spacing: CGFloat = DesignConstants.spacing
    private var unitLengthForAnswerCells = CGFloat()
    private lazy var standartLengthForAnswerCells: CGFloat = DesignConstants.standartSizeForAnswerCell
    
    private var standartNumberOfLetters: Int {
        let totalWidth = self.superview!.bounds.width
        return Int((totalWidth + spacing) / (standartLengthForAnswerCells + spacing))
    }
    
    private var maximumNumberOfLettersInOneLine: Int {
        let biggestWordLenght = answer.max { $0.count < $1.count }?.count ?? 0
        return max(biggestWordLenght, standartNumberOfLetters)
    }
    
    private func determineUnitLengthForAnswerCells() {
        let _maximumNumberOfLettersInOneLine = CGFloat(maximumNumberOfLettersInOneLine)
        let totalFillableWidth = self.bounds.width - ((_maximumNumberOfLettersInOneLine+1) * spacing)
        let lengthNominee = totalFillableWidth / _maximumNumberOfLettersInOneLine
        self.unitLengthForAnswerCells = lengthNominee
    }
    
    private func adjustAnswerForAnswerCellLayout() {
        guard answer.count > 0 else { return }
        proportionallyDistributedAnswer = proportionallyDistribute(words: answer)
        answerAsLetters = proportionallyDistributedAnswer.map { word in word.map { String($0) } }
    }
    
    private var unitSizeForAnswerCells: CGSize {
        CGSize(width: unitLengthForAnswerCells, height: unitLengthForAnswerCells)
    }
    
    // MARK: -  Data source
    
    private var proportionallyDistributedAnswer = [String]()
    private var answerAsLetters = [[String]]()
    
    private var numberOfLines: Int {
        proportionallyDistributedAnswer.count
    }
    
    private func numberOfLetters(at line: Int) -> Int {
        proportionallyDistributedAnswer[line].count
    }
    
    // MARK: - Layout for answer cells
    
    private func getHorizontalOffset(forLine line: Int) -> CGFloat {
        let totalWidth = self.bounds.width
        let numberOfLetters = CGFloat(self.numberOfLetters(at: line))
        let totalUsedWidth = (numberOfLetters * unitLengthForAnswerCells) + (spacing * (numberOfLetters - 1))
        return (totalWidth - totalUsedWidth) / 2.0
    }
    
    private func getVerticalOffset(forLine line: Int) -> CGFloat {
        return CGFloat(line) * (unitLengthForAnswerCells + spacing)
    }
    
    private func getFrameForCell(atIndex index: Int, withHorizontalOffset horizontalOffset: CGFloat, withVerticalOffset verticalOffset: CGFloat, accordingTo origin: CGPoint) -> CGRect {
        let _horizontalOffset = (((CGFloat(index) * unitLengthForAnswerCells)) + ((CGFloat(index)) * spacing)) + horizontalOffset
        let position = origin.offsetBy(dx: _horizontalOffset, dy: verticalOffset)
        let frame = self.convert(CGRect(origin: position, size: unitSizeForAnswerCells), to: superview)
        return frame
    }
    
    private var originForTitle: CGPoint? // Special var for creating titles in home pages.
    
    private var originForAnswerCells: CGPoint {
        if originForTitle != nil { return originForTitle! }
        let totalUsedHeight = (CGFloat(numberOfLines) * (unitLengthForAnswerCells + spacing)) - spacing
        return CGPoint(x: 0.0, y: (self.bounds.maxY - totalUsedHeight))// /2.0)
    }
    
    // MARK: - Answer cells
    
    private func addOrRotateAnswerCells(forRotation: Bool = false) {
        var outerIndex = 0 ; let origin = originForAnswerCells
        if !forRotation { removeAllAnswerCells() }
        for line in 0..<numberOfLines {
            let horizontalOffset = getHorizontalOffset(forLine: line)
            let verticalOffset = getVerticalOffset(forLine: line)
            for index in 0..<numberOfLetters(at: line) {
                guard answerAsLetters[line][index] != " " else { continue }
                let frameForCell = getFrameForCell(atIndex: index, withHorizontalOffset: horizontalOffset, withVerticalOffset: verticalOffset, accordingTo: origin)
                if forRotation && answerCells.count > outerIndex {
                    answerCells[outerIndex].frame = frameForCell
                } else {
                    let cell = AnswerCellView(frame: frameForCell)
                    self.superview?.addSubview(cell)
                    self.answerCells.append(cell)
                    self.clipsToBounds = false
                    if let tap = tapForCell { cell.addGestureRecognizer(tap()) }
                    cell.index = outerIndex
                }
                outerIndex += 1
            }
        }
    }
    
    private func removeAllAnswerCells() {
        answerCells.forEach {
            $0.removeFromSuperview()
        }
        answerCells = []
    }
    
    // MARK: - Gestures
    
    private var matchedLetterViews: [LetterView] {
        return self.answerCells.compactMap { $0.matchedFlyingLetter }
    }
    private var firstTouchArray = [LetterView]() // Needed to handle if pan gesture starts on the letter.
    private var panned = [LetterView]()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.location(in: self.superview)
            self.matchedLetterViews.forEach {
                if $0.frame.contains(point) {
                    $0.showSelection()
                    self.firstTouchArray = [$0]
                }
            }
        }
    }
    
    @objc private func tap(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        matchedLetterViews.forEach {
            if $0.frame.contains(sender.location(in: $0.superview!)) {
                self.touchFlyingLetter?($0)
                $0.showDeselection()
            }
        }
    }
    
    @objc private func pan(_ sender: UIPanGestureRecognizer) {
        let playArea = self.superview!.subviews.filter { $0 as? PlayArea != nil }.first
        switch sender.state {
        case .began:
            if let first = firstTouchArray.first, !firstTouchArray.contains(first), self.matchedLetterViews.contains(first) {
                panned.append(first) ; firstTouchArray = []
            }
        case .changed:
            if playArea != nil, playArea!.frame.contains(sender.location(in: self.superview!)) {
                showAlertView?(true)
            } else {
                if !(alertViewIsHidden?() ?? true) { showAlertView?(false) }
                self.matchedLetterViews.filter { $0.letter.answerID == appWide_currentAnswerID }.forEach {
                    if $0.frame.contains(sender.location(in: $0.superview!)) {
                        $0.showSelection()
                        if !panned.contains($0) { panned.append($0) }
                    }
                }
            }
        case .ended:
            if playArea != nil, playArea!.frame.contains(sender.location(in: self.superview!)) {
                panned = [] ; showAlertView?(false)
            }
            self.matchedLetterViews.filter { $0.letter.answerID == appWide_currentAnswerID }.forEach {
                $0.showDeselection()
                if $0.frame.contains(sender.location(in: $0.superview!)) {
                    if !panned.contains($0) { panned.append($0) }
                }
            }
            panned.forEach { touchFlyingLetter?($0) } ; panned = []
        default:
            firstTouchArray = [] ; panned = []
        }
    }
}

extension AnswerArea {
    fileprivate func proportionallyDistribute(words: [String], depth: Int?=nil) -> [String] {
        assert(words.count > 0, "words.count smaller than zero!")
        let maximumNumberOfLettersInOneLine = self.maximumNumberOfLettersInOneLine
        let depth = depth == nil ? 0 : depth!
        if depth == 0 && (words.contains { $0.count > maximumNumberOfLettersInOneLine }) { return [] }
        var withNew = [String]()
        var withoutNew = [String]()
        if words.indices.last! >= depth+1 && words[depth].count + words[depth+1].count+1 <= maximumNumberOfLettersInOneLine {
            let newString = "\(words[depth] + " " + words[depth+1])"
            var newWords = words
            newWords.remove(at: depth+1)
            newWords[depth] = newString
            withNew = proportionallyDistribute(words: newWords, depth: depth)
        }
        if words.indices.last! >= depth+1 {
            withoutNew = proportionallyDistribute(words: words, depth: depth+1)
        }
        if withNew == [] && withoutNew == [] { return words }
        if withNew == [] && withoutNew != [] { return withoutNew }
        if withoutNew == [] && withNew != [] { return withNew }
        if withNew.count == withoutNew.count { return
            measureAppropriateness(withNew) < measureAppropriateness(withoutNew) ?
                withNew : withoutNew
        }
        return withNew.count < withoutNew.count ? withNew : withoutNew
    }
    
    private func measureAppropriateness(_ words: [String]) -> Int {
        var sum = 0
        for index in 0..<(words.indices.last!) {
            sum += abs(words[index].count - words[index+1].count)
        }
        return sum
    }
}
