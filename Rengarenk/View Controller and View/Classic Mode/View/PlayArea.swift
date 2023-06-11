//
//  PlayArea.swift
//  Color Coded
//
//  Created by Mert Arıcan on 11.11.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

class PlayArea: UIView {
    private var allLetters = [Letter]()
    private lazy var grid = Grid(bounds: self.bounds, cellCount: 0)
    private(set) var letterViews = [LetterView]()
    
    // MARK: - Public API
    
    weak var letterBehavior: LetterBehavior?
    var unmatchedLetters: [LetterView] { letterViews.filter { !$0.isFixed } }
    var matchedLetters: [LetterView] { letterViews.filter { $0.isFixed } }
    var handleFirstTouch: ((LetterView) -> ())?
    
    func shiftLettersAfterCorrectAnswer() {
        let shouldGrow = !isPad
            && self.letterViews.count > DesignConstants.shrinkBarrier
            && self.unmatchedLetters.count <= DesignConstants.shrinkBarrier
        
        if UserPreferences.flyingModeIsActive && !shouldGrow {
            self.unmatchedLetters.forEach { letterOnTheTable in
                let shiftCount = self.matchedLetters.filter {
                    $0.coordinate != nil &&
                    $0.coordinate.col == letterOnTheTable.coordinate.col
                        && $0.coordinate.row < letterOnTheTable.coordinate.row
                }.count
                if shiftCount > 0 {
                    let newCoordinate = (letterOnTheTable.coordinate.row - shiftCount, letterOnTheTable.coordinate.col)
                    let newGridPos = self.grid.getGridPosition(atCoordinate: newCoordinate)
                    
                    UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: AnimationConstants.correctAnswer,
                        delay: 0.0,
                        options: .curveEaseInOut,
                        animations: {
                            letterOnTheTable.frame = self.convert(newGridPos.frame, to: self.superview)
                            letterOnTheTable.lastFrame = letterOnTheTable.frame
                            letterOnTheTable.coordinate = newGridPos.coordinate
                    })
                }
            }
        } else if shouldGrow {
            grid.setCellCount(self.unmatchedLetters.count)
            self.unmatchedLetters.forEach { fly in
                letterBehavior?.removeItem(fly)
                let gridPos = grid.gridPosition
                let rect = self.convert(gridPos.frame, to: superview)
                fly.coordinate = gridPos.coordinate
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: AnimationConstants.correctAnswer,
                    delay: 0.0,
                    options: .curveEaseOut,
                    animations: {
                        fly.removeShadow()
                        fly.frame = rect
                        UIView.transition(
                            with: fly,
                            duration: AnimationConstants.correctAnswer,
                            options: [],
                            animations: {
                            fly.updateFont()
                        })
                }
                ) { _ in
                    fly.dropShadow(cornerRadius: fly.commonCornerRadius)
                    self.letterBehavior?.addItem(fly)
                }
            }
        }
    }
    
    func clearAfterCorrectAnswer() {
        Timer.scheduledTimer(withTimeInterval: AnimationConstants.correctAnswer, repeats: false) { _ in
            appWide_answerIsCorrectCancelTouches = false
            self.matchedLetters.forEach {
                self.letterViews.removeFirstAppearance($0)
                $0.removeFromSuperview()
            }
        }
    }
    
    func setNewLetters(letters: [Letter], reveals: [(Letter, AnswerCellView)]) {
        allLetters = letters.shuffled() ; removeAllLetters()
        grid = Grid(bounds: self.bounds, cellCount: allLetters.count)
        for letter in (allLetters) {
            let gridPos = grid.gridPosition
            let rect = self.convert(gridPos.frame, to: superview)
            let randomP = self.convert(self.randomPointOutside, to: superview)
            let randomR = CGRect(origin: randomP, size: rect.size)
            let fly = LetterView(frame: randomR)
            letterViews.append(fly)
            fly.letter = letter
            fly.coordinate = gridPos.coordinate
            self.superview?.addSubview(fly)
            fly.drawContents()
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: AnimationConstants.next,
                delay: AnimationConstants.letterMove,
                options: .curveEaseOut,
                animations: { fly.frame = rect }
            ) { _ in
                self.letterBehavior?.addItem(fly)
            }
        }
        for (letter, cell) in reveals {
            let randomP = self.convert(self.randomPointOutside, to: superview)
            let randomR = CGRect(origin: randomP, size: .init(squareWith: letterViews.first?.bounds.width ?? 0.0))
            let fly = LetterView(frame: randomR)
            letterViews.append(fly)
            fly.letter = letter
            fly.matchedAnswerCell = cell
            cell.matchedFlyingLetter = fly
            self.superview?.addSubview(fly)
            fly.drawContents()
            let scale = cell.bounds.width / fly.bounds.width
            fly.transform = CGAffineTransform.init(scaleX: scale, y: scale)
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: AnimationConstants.next,
                delay: AnimationConstants.letterMove,
                options: .curveEaseOut,
                animations: { fly.frame = cell.frame; fly.showJoker() }
            )
        }
        Timer.scheduledTimer(withTimeInterval: AnimationConstants.next + AnimationConstants.letterMove, repeats: false) { _ in
            appWide_answerIsCorrectCancelTouches = false
        }
    }
    
    func updateAfterRotation() {
        updateCollisionArea()
        grid = Grid(bounds: self.bounds, cellCount: letterViews.count)
        for letter in unmatchedLetters {
            let gridPos = grid.gridPosition
            letterBehavior?.removeItem(letter)
            letter.frame = self.convert(gridPos.frame, to: superview)
            letter.lastFrame = letter.frame
            letter.updateFont()
            letter.coordinate = gridPos.coordinate
            letter.dropShadow(cornerRadius: letter.commonCornerRadius)
            letterBehavior?.addItem(letter)
        }
        for letter in matchedLetters {
            letter.bounds.size = CGSize(squareWith: grid.currentLetterLength)
            let scale = letter.matchedAnswerCell!.bounds.width / letter.bounds.width
            letter.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)
            letter.frame.origin = letter.matchedAnswerCell!.frame.origin
            let gridPos = grid.gridPosition
            letter.lastFrame = self.convert(gridPos.frame, to: superview)
            letter.coordinate = gridPos.coordinate
            letter.updateFont()
            letter.dropShadow(cornerRadius: letter.commonCornerRadius)
        }
    }
    
    private func removeAllLetters() {
        letterViews.forEach {
            letterBehavior?.removeItem($0)
            $0.removeFromSuperview()
        }
        letterViews = []
    }
    
    // MARK: - Gestures
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.location(in: self.superview)
            self.unmatchedLetters.forEach {
                if $0.frame.contains(point) && $0.backgroundColor == Colors[appWide_currentAnswerID] {
                    $0.showSelection() ; handleFirstTouch?($0)
                }
            }
        }
    }
    
    // MARK: - Dynamic Behavior
    
    private lazy var allSides: [UIView] = {
        let all = [UIView(), UIView(), UIView(), UIView()]
        all.forEach { self.superview?.addSubview($0) }
        return all
    }()
    
    func addOrRemoveLettersToBehavior(toAdd: Bool) {
        if let behavior = self.letterBehavior {
            self.unmatchedLetters.forEach {
                toAdd ? behavior.addItem($0) : behavior.removeItem($0)
            }
        }
    }
    
    func updateCollisionArea() {
        let frame = self.frame
        let bounds = self.bounds
        let k: CGFloat = 4.0
        allSides.forEach { if $0.bounds.size != .zero { self.letterBehavior?.removeItem($0, isDynamic: false) } }
        
        let org1 = frame.origin.offsetBy(dx: -k, dy: -k)
        let size1 = CGSize(width: bounds.width+2*k, height: k)
        allSides[0].frame = CGRect(origin: org1, size: size1)
        
        let org2 = frame.origin.offsetBy(dx: bounds.width)
        let size2 = CGSize(width: k, height: bounds.height+k)
        allSides[1].frame = CGRect(origin: org2, size: size2)
        
        let org3 = frame.origin.offsetBy(dy: bounds.height)
        let size3 = CGSize(width: bounds.width, height: k)
        allSides[2].frame = CGRect(origin: org3, size: size3)
        
        let org4 = frame.origin.offsetBy(dx: -k)
        let size4 = CGSize(width: k, height: bounds.height+k)
        allSides[3].frame = CGRect(origin: org4, size: size4)
        allSides.forEach { self.letterBehavior?.addItem($0, isDynamic: false) }
    }
}
