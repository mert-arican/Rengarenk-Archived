//
//  GameplayViewController.swift
//  Color Coded
//
//  Created by Mert Arıcan on 10.11.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

class GameplayViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    // MARK: - IBOutlets and IBActions
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var questionView: QuestionView!
    @IBOutlet private weak var powerUpButton: PowerUpButton!
    @IBOutlet private weak var playArea: PlayArea!
    @IBOutlet private weak var answerArea: AnswerArea!
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBAction private func back(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    // MARK: - Model
    
    private var model: RengarenkModel!
    private var question: String { model.question }
    private var answer: [String] { model.currentWord.components(separatedBy: " ") }
    private var birdSimurgh: Bool { model.birdSimurgh }
    
    // MARK: - Game Dynamics
    
    private func match(letterView: LetterView, answerCell: AnswerCellView, isJoker: Bool) {
        if isJoker {
            if let cell = answerArea.answerCells.first(where: { $0.matchedFlyingLetter == letterView }), cell != answerCell {
                cell.isHidden = false
                cell.matchedFlyingLetter?.matchedAnswerCell = nil
                cell.matchedFlyingLetter = nil
            }
        }
        letterView.letter.isJoker = isJoker
        answerArea.isUserInteractionEnabled = true
        guard (answerCell.matchedFlyingLetter != letterView) else { if isJoker { letterView.showJoker() }; return }
        var needsCheck = false
        letterView.superview?.bringSubviewToFront(letterView)
        letterView.lastFrame = letterView.frame
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: AnimationConstants.letterMove + (isJoker ? AnimationConstants.jokerDuration : 0.0),
            delay: 0.0,
            options: [.curveEaseInOut],
            animations: {
                self.letterBehavior?.removeItem(letterView)
                letterView.matchedAnswerCell = answerCell
                answerCell.matchedFlyingLetter = letterView
                letterView.showJoker()
                let scale = answerCell.bounds.width / letterView.bounds.width
                letterView.transform = CGAffineTransform.init(scaleX: scale, y: scale)
                letterView.frame.origin = answerCell.frame.origin
                needsCheck = self.playArea.matchedLetters.count == self.answerArea.answerCells.count
        }) { _ in
            letterView.matchedAnswerCell?.isHidden = true
            if needsCheck { self.checkGivenAnswer() }
        }
    }
    
    func detach(letterView: LetterView) {
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: AnimationConstants.letterMove,
            delay: 0.0,
            options: .curveEaseInOut,
            animations: {
                letterView.matchedAnswerCell?.isHidden = false
                letterView.matchedAnswerCell?.matchedFlyingLetter = nil
                letterView.matchedAnswerCell = nil
                letterView.transform = .identity
                letterView.frame.origin = letterView.lastFrame.origin
        }) { _ in
            self.letterBehavior?.addItem(letterView)
        }
    }
    
    private var categoryReward: PowerUp?
    
    private func checkGivenAnswer() {
        if self.model.categoryCompleted && self.presentedViewController == nil {
            categoryReward = Constantstinopolis.appState.getRewardAfterCategoryEnd(); self.presentNextVC()
        } else if self.model.isCorrectAnswer {
            self.model.setNewWord()
            self.updateAfterCorrectAnswer(answer: self.answer, afterCorrectAnswer: true)
        }
    }
    
    private func setNewAnswer() {
        updateColorOfTop()
        answerArea.setNewAnswer(answer: answer)
        let alreadyRevealedLetters = model.givenAnswerSoFar.compactMap { $0 }.filter({ $0.isJoker })
        let alreadeRevealedAnswerCells = alreadyRevealedLetters.map {
            answerArea.answerCells[model.givenAnswerSoFar.firstIndex(of: $0)!]
        }
        let all = Array(zip(alreadyRevealedLetters, alreadeRevealedAnswerCells))
        playArea.setNewLetters(letters: model.flyingLetters, reveals: all)
    }
    
    // MARK: - "Update after..." functions
    
    private func updateViewFromModel() {
        // 1) handle releases
        // 2) givenAnswer for each: flying letter frame = answer cell frame
        for fly in playArea.matchedLetters {
            if model.flyingLetters.contains(fly.letter) {
                detach(letterView: fly)
            }
        }
        for (index, letter) in model.givenAnswerSoFar.enumerated() {
            guard letter != nil else { continue }
            if let fly = playArea.letterViews.first (where: { $0.letter == letter }) {
                match(letterView: fly, answerCell: answerArea.answerCells[index], isJoker: letter!.isJoker)
            } else { fatalError("Couldn't find flying one.") }
        }
    }
    
    private func updateAfterCorrectAnswer(answer: [String], afterCorrectAnswer: Bool) {
        answerArea.setNewAnswer(answer: answer, afterCorrectAnswer: afterCorrectAnswer)
        playArea.clearAfterCorrectAnswer()
        self.previewLabel.text = LocalizedTexts.correct
        self.previewLabel.backgroundColor = Colors.correctClr
        self.playArea.matchedLetters.forEach { $0.setBackground(Colors.correctClr) }
        Timer.scheduledTimer(withTimeInterval: AnimationConstants.correctAnswer, repeats: false, block: { [weak self] _ in
            guard let self = self else { return }
            self.updateColorOfTop()
            self.previewLabel.text = nil
        })
    }
    
    private func updateAfterRotation() {
        answerArea.updateAfterRotation()
        playArea.updateAfterRotation()
        self.view.bringSubviewToFront(questionView)
        self.questionView.updateQuestionLabel()
        self.nextView?.moveToCenter()
    }
    
    private func updateColorOfTop() {
        self.backButton.backgroundColor = Colors.currentColor
        self.questionView.backgroundColor = Colors.currentColor
        self.powerUpButton.backgroundColor = Colors.currentColor
        self.previewLabel.backgroundColor = Colors.currentColor
        self.updatePreviewLabel()
        self.powerUpButton.dop()
    }
    
    // MARK: - Simurgh
    
    @IBOutlet private weak var darkKnight: UIView!
    @IBOutlet private weak var darkKnigh2: UIView!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    @IBAction private func cancelSimurgh(_ sender: UIButton) { simurgh() }
    
    private func simurgh() { self.model.toggleSimurgh() ; updateSimurgh() }
    
    private func updateSimurgh() {
        cancelButton.backgroundColor = Colors.currentColor
        descriptionLabel.backgroundColor = Colors.currentColor
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.3,
            delay: 0.0,
            options: .curveEaseInOut,
            animations: {
                self.darkKnight.isHidden = !self.birdSimurgh
                self.darkKnigh2.isHidden = !self.birdSimurgh
                self.answerArea.answerCells.forEach {
                    $0.isUserInteractionEnabled = self.birdSimurgh
                    $0.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    $0.layer.borderWidth = self.birdSimurgh ? 3.0 : 0.0
                }
        })
    }
    
    // MARK: - Presenting and preparing views
    
    private var nextView: NextView!
    
    private func presentNextVC(shouldTryPresentingIntersititial: Bool=true) {
        hideAndSeek(hide: true)
        let point = self.view.centerOfBounds.offsetBy(dx: -100/2, dy: -(self.view.bounds.height/2))
        let factor: CGFloat = isPad ? 3.5 : 5.0
        let length = min(self.view.bounds.width, self.view.bounds.height)
        nextView = NextView(frame: .init(origin: point, size: .init(squareWith: length*(factor)/7.0)))
        nextView.reward = self.categoryReward
        nextView.prepareView()
        self.view.addSubview(nextView)
        self.nextView.moveToCenter()
        nextView.nextCategory = { [weak self] in self?.nextCategory() }
        nextView.alpha = 0.0
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.4,
            delay: 0.0,
            options: .curveEaseInOut,
            animations: {
                self.nextView.alpha = 1.0
            }) { _ in self.playArea.letterViews.forEach { $0.isHidden = true } }
    }
    
    // MARK: - View Controller Lifecycle
    
    private func addGesturesAndBlindCommunication() {
        playArea.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        playArea.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan(_:))))
        
        playArea.letterBehavior = self.letterBehavior
        answerArea.letterBehavior = self.letterBehavior
        answerArea.shiftAfterCorrectAnswer = playArea.shiftLettersAfterCorrectAnswer
        
        questionView.initialize() { [weak self] in return self?.question ?? "" }
        playArea.handleFirstTouch = { [weak self] letterView in self?.firstTouchArray = [letterView] }
        answerArea.showAlertView = { [weak self] toShow in self?.alertView.isHidden = !toShow }
        answerArea.alertViewIsHidden = { [weak self] in self?.alertView.isHidden ?? true }
        answerArea.touchFlyingLetter = { [weak self] letterView in self?.touchFlyingLetter(letterView: letterView) }
        answerArea.tapForCell = { [unowned self] in UITapGestureRecognizer(target: self, action: #selector(self.touchAnswerCell(_:))) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appWide_answerIsCorrectCancelTouches = true
        self.model = RengarenkModel(state: Constantstinopolis.gameState)
        self.getBehavior()
        self.updateColorOfTop()
        self.addGesturesAndBlindCommunication()
        self.imageView.backgroundColor = theColor
//        self.imageView.image = UIImage(uncachedjpg: "\(Constantstinopolis.gameState.categoryIndex / 10)")
        
        backButton.setImage(UIImage(systemImageWithBackupNamed: "chevron.left.circle"), for: .normal)
        cancelButton.setImage(UIImage(systemImageWithBackupNamed: "xmark.circle"), for: .normal)
        
        backButton.getCommonCornerRadius()
        powerUpButton.getCommonCornerRadius()
        cancelButton.getCommonCornerRadius()
        descriptionLabel.getCommonCornerRadius()
        descriptionLabel.text = LocalizedTexts.simurghInstruction
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !didAppear {
            backButton.dropShadow()
            powerUpButton.dropShadow()
            questionView.initializeScroll()
        }
    }
    
    private var didAppear = false
    private var fromGrandBazaar = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !fromGrandBazaar {
            setNewAnswer()
            playArea.updateCollisionArea()
            playArea.addOrRemoveLettersToBehavior(toAdd: true)
            Timer.scheduledTimer(withTimeInterval: AnimationConstants.next+AnimationConstants.letterMove, repeats: false) { _ in
                if !self.didAppear && self.model.isInitialGame {
                    let infoVC = Constantstinopolis.getViewController(name: "Menu", withIdentifier: "InfoMVC") as? NewInfoViewController
                    guard infoVC != nil else { return }
                    infoVC!.imageMaybe = self.view.snapshot
                    self.present(infoVC!, animated: true)
                    self.fromGrandBazaar = true
                }
                self.didAppear = true
            }
        } else { fromGrandBazaar = false }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in self.updateAfterRotation() })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.playArea.addOrRemoveLettersToBehavior(toAdd: false)
    }
    
    // MARK: - Preview and User Interaction
    
    @IBOutlet private weak var previewLabel: CustomLabel!
    @IBOutlet private weak var alertView: UIView! { didSet { alertView.alpha = 0.6 } }
    
    private var firstTouchArray = [LetterView]()
    private var previewArray = [String]()
    
    private var panned = [LetterView]() {
        didSet {
            guard model.currentCategoryIndex < Constantstinopolis.categories.count else { return }
            var text = beginPreview()
            for letterView in panned {
                if let index = text.firstIndex(of: "*") {
                    text[index] = letterView.letter.character
                    continue
                }
                var spaceCount = text.filter { $0 == " " }.count
                
                if model.breakPoints.contains(text.count) {
                    text.append(" "); spaceCount += 1
                }
                
                text.append(letterView.letter.character)
                
                while model.jokerLetterIndices.contains(text.count - spaceCount) {
                    if model.breakPoints.contains(text.count) { text.append(" ") ; spaceCount += 1 }
                    text.append(model.givenAnswerSoFar[text.count-spaceCount]!.character)
                }
            }
            previewLabel.text = text.joined()
            updatePreviewLabel()
        }
    }
    
    @discardableResult
    private func beginPreview() -> [String] {
        self.previewArray = []
        var lastIndex = self.model.givenAnswerSoFar.lastIndex(where: { $0 != nil && !$0!.isJoker }) ?? -1
        while lastIndex+1 < model.givenAnswerSoFar.count && ((model.givenAnswerSoFar[lastIndex+1]?.isJoker) ?? false) { lastIndex += 1 }
        var spaceCount = previewArray.filter { $0 == " " }.count
        if lastIndex > -1 {
            for index in 0...lastIndex {
                if model.breakPoints.contains(index+spaceCount) { previewArray.append(" "); spaceCount += 1 }
                previewArray.append(model.givenAnswerSoFar[index]?.character ?? "*")
            }
        }
        previewLabel.text = previewArray.joined()
        updatePreviewLabel()
        return previewArray
    }
    
    // MARK: - Gestures for play areas
    
    @objc private func tap(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        self.playArea.unmatchedLetters.forEach {
            if $0.frame.contains(sender.location(in: $0.superview!)) {
                self.touchFlyingLetter(letterView: $0)
                GameSound.playTouch()
                $0.showDeselection()
            }
        }
    }
    
    @objc private func pan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            self.beginPreview()
            if let first = firstTouchArray.first, !panned.contains(first), model.flyingLetters.contains(first.letter) {
                GameSound.playTouch() ; panned.append(first) ; firstTouchArray = []
            }
        case .changed:
            if self.answerArea.frame.contains(sender.location(in: answerArea.superview!)) {
                alertView.isHidden = false
            } else {
                if !alertView.isHidden { alertView.isHidden = true }
                self.playArea.unmatchedLetters.filter { $0.letter.answerID == appWide_currentAnswerID }.forEach {
                    if $0.frame.contains(sender.location(in: $0.superview!)) {
                        $0.showSelection()
                        if !panned.contains($0) { GameSound.playTouch() ; panned.append($0) }
                    }
                }
            }
        case .ended:
            if self.answerArea.frame.contains(sender.location(in: answerArea.superview!)) {
                panned = [] ; alertView.isHidden = true
            }
            self.playArea.unmatchedLetters.filter { $0.letter.answerID == appWide_currentAnswerID }.forEach {
                $0.showDeselection()
                if $0.frame.contains(sender.location(in: $0.superview!)) {
                    if !panned.contains($0) { GameSound.playTouch() ; panned.append($0) }
                }
            }
            panned.forEach { touchFlyingLetter(letterView: $0) }
            panned = [] ; self.previewLabel.text = nil ; self.updatePreviewLabel()
        default:
            firstTouchArray = [] ; panned = [] ; self.previewLabel.text = nil ; self.updatePreviewLabel()
        }
    }
    
    private func touchFlyingLetter(letterView: LetterView) {
        guard !appWide_answerIsCorrectCancelTouches && !birdSimurgh
            && letterView.backgroundColor == Colors[appWide_currentAnswerID] else { return }
        if letterView.isFixed { model.deselectLetter(letterView.letter) }
        else { model.selectLetter(letterView.letter) }
        letterView.alpha = 1.0
        updateViewFromModel()
    }
    
    private func updatePreviewLabel() {
        if self.previewLabel.text == nil || self.previewLabel.text == "" {
            self.previewLabel.backgroundColor = .clear
        } else {
            self.previewLabel.backgroundColor = Colors.currentColor
        }
        previewLabel.getCommonCornerRadius()
    }
    
    @objc private func touchAnswerCell(_ sender: UITapGestureRecognizer? = nil) {
        if let cell = sender!.view as? AnswerCellView, cell.matchedFlyingLetter == nil
            || (cell.matchedFlyingLetter != nil && !cell.matchedFlyingLetter!.isJoker) {
            if let index = answerArea.answerCells.firstIndex(of: cell) {
                model.simurgh(index) ; updateViewFromModel() ; updateSimurgh()
            } else {
                fatalError("no cell!")
            }
        }
    }
    
    @objc private func nextCategory(_ sender: UIButton? = nil) {
        if model.currentCategoryIndex >= Constantstinopolis.categories.count {
            present(Constantstinopolis.presentLevelsCompletedAlert(
                handler: { [weak self] in self?.presentingViewController?.dismiss(animated: true) }),
                    animated: true
            ); return
        }
        self.model.setNewCategory()
        setNewAnswer()
        questionView.updateQuestionLabel()
        hideAndSeek(hide: false) ; self.nextView.isHidden = true
        playArea.clearAfterCorrectAnswer()
        
//        self.imageView.image = UIImage(uncachedjpg: "\(Constantstinopolis.gameState.categoryIndex / 10)")
    }
    
    // Helper function for presenting 'next' scene.
    private func hideAndSeek(hide: Bool) {
        topView.subviews.forEach { $0.alpha = hide ? 0.0 : 1.0 }
    }
    
    // MARK: - Dynamic Behavior
    
    private var animator: UIDynamicAnimator?
    private(set) var letterBehavior: LetterBehavior?
    
    private func getBehavior() {
        guard !UserPreferences.flyingModeIsActive else { return }
        animator = UIDynamicAnimator(referenceView: self.view)
        letterBehavior = LetterBehavior(in: animator!)
        letterBehavior?.playArea = self.playArea
    }
    
    // MARK: - PowerViewController presentation preparation
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    private func presentGrandBazaar() {
        let marketViewController = Constantstinopolis.getViewController(name: "Menu", withIdentifier: "MarketVC")
        self.present(marketViewController, animated: true) { self.fromGrandBazaar = true }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "powerPop" && model.categoryCompleted { return false }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destionation = segue.destination as? PowerViewController {
            destionation.popoverPresentationController?.delegate = self
            destionation.allPowers = model.allPowers
            destionation.resignationHandler = { [unowned self] name in
                guard !appWide_answerIsCorrectCancelTouches && !self.birdSimurgh else { return }
                switch name {
                case LocalizedTexts.fortune: self.model.fortune()
                case LocalizedTexts.simurgh: self.simurgh()
                case LocalizedTexts.apocalypse: self.model.apocalypse()
                case LocalizedTexts.grandBazaar: self.presentGrandBazaar()
                default: break
                }
                self.updateViewFromModel()
            }
        }
    }
}
