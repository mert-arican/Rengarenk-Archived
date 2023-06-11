//
//  FlyingLettersModel.swift
//  Flying Letters
//
//  Created by Mert Arıcan on 7.10.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import Foundation

struct RengarenkModel {
    // MARK: - Public API
    var question: String { category.question }
    var currentWord: String { allUnsolvedWords.first! }
    var currentCategoryIndex: Int { state.categoryIndex }
    private(set) var givenAnswerSoFar = [Letter?]() // This represents the answer cells, respecting the order of the cells.
    private(set) var flyingLetters = [Letter]() // This represents the moving flying letters in view.
    
    init(state: GameState) {
        self.state = state
        setNewCategory()
    }
    
    mutating func setNewCategory() {
        Colors.prepareColors()
        categoryCompleted = false
        setAllLetters()
        updateCurrentAnswerIDAfterLoad()
        setNewWord()
    }
    
    private mutating func updateCurrentAnswerIDAfterLoad() {
        let count = Set(self.alreadySolvedIndices).count
        for index in flyingLetters.indices {
            flyingLetters[index].answerID += count
        }
    }
    
    mutating func setNewWord() {
        removedWord = nil
        appWide_currentAnswerID = _currentAnswerID
        setGivenAnswer()
    }
    
    mutating func selectLetter(_ letter: Letter) {
        guard givenAnswerSoFar.filter({ $0 != nil }).count < _currentAnswer.count else { return }
        if flyingLetters.contains(letter) {
            givenAnswerSoFar.replaceFirst(nil, with: letter)
            flyingLetters.removeFirstAppearance(letter)
            if isCorrectAnswer { updateAfterCorrectAnswer() }
            if categoryCompleted { state.categoryCompleted() }
        } else {
            fatalError("letter couldn't be found in allLetters.")
        }
    }
    
    mutating func deselectLetter(_ letter: Letter? = nil, at index: Int? = nil) {
        if let letter = ((index != nil) ? givenAnswerSoFar[index!] : letter) {
            guard !letter.isJoker else { return }
            givenAnswerSoFar.replaceFirst(letter, with: nil)
            flyingLetters.uniquelyAppend(letter)
        }
    }
    
    var isCorrectAnswer: Bool {
        guard removedWord == nil else { return true }
        let givenAnswer = givenAnswerSoFar.compactMap { $0?.character }.joined()
        guard givenAnswer.count == _currentAnswer.count else { return false }
        return allUnsolvedWords.map { $0.onlyLetters }.contains(givenAnswer)
    }
    
    private(set) var categoryCompleted: Bool = false
    
    // MARK: - Private implementations
    
    private var state: GameState
    private var category: WordCategory { Constantstinopolis.categories[state.categoryIndex] }
    private var alreadySolvedIndices: [Int] { state.alreadySolvedIndices }
    private var allWords: [String] { category.answers }
    private var allUnsolvedWords: [String] { allWords.indices.filter { !alreadySolvedIndices.contains($0) }.map { allWords[$0] } }
    
    private mutating func setAllLetters() {
        var index = 0 ; self.flyingLetters = []
        for (answerID, answer) in self.allUnsolvedWords.enumerated() {
            for letter in answer { if letter == " " { continue }
                self.flyingLetters.append(Letter(index: index, answerID: answerID, character: String(letter)))
                index += 1
            }
        }
    }
    
    private mutating func setGivenAnswer() {
        givenAnswerSoFar = []
        for _ in _currentAnswer.indices { givenAnswerSoFar.append(nil) }
        jokerLetterIndices.forEach { revealLetter(at: $0, with: .fortune, afterLoad: true) }
    }
    
    private mutating func updateAfterCorrectAnswer() {
        appWide_answerIsCorrectCancelTouches = true
        let givenAnswer = self.givenAnswerSoFar.compactMap { $0?.character }.joined()
        allUnsolvedWords.forEach {
            if $0.onlyLetters == givenAnswer {
                state.updateAfterCorrectAnswer(allWords.map { $0.onlyLetters }.firstIndex(of: givenAnswer)!)
                removedWord = givenAnswer
            }
        }
        if allUnsolvedWords.count == 0 { categoryCompleted = true }
    }
    
    private var removedWord: String?
    
    // MARK: - PowerUps
    
    // Use this var for powerUps.
    private var _currentAnswer: String {
        return currentWord.filter { $0 != " " }
    }
    
    var breakPoints: [Int] {
        var all = [Int]()
        for (index, letter) in self.currentWord.enumerated() {
            if letter == " " { all.append(index) }
        }
        return all
    }
    
    private var _currentAnswerID: Int {
        var all = Array(0...10)
        alreadySolvedIndices.forEach { all.removeFirstAppearance($0) }
        return all.first ?? 0
    }
    
    private var nonJokerLetterIndices: [Int] {
        givenAnswerSoFar.indices.filter { !jokerLetterIndices.contains($0) }
    }
    
    var jokerLetterIndices: [Int] { state.currentlyRevealedIndices }
    
    private mutating func revealLetter(at index: Int, with powerUp: PowerUp, afterLoad: Bool = false) {
        let desiredLetterString = String(_currentAnswer.list[index])
        if givenAnswerSoFar[index] != nil { deselectLetter(givenAnswerSoFar[index]) }
        
        
        let desiredLetter =
            flyingLetters.first(where: { $0.character == desiredLetterString && $0.answerID == _currentAnswerID })
                ??
            givenAnswerSoFar.compactMap { $0 }.first { !$0.isJoker && $0.character == desiredLetterString && $0.answerID == _currentAnswerID }
        
        guard desiredLetter != nil else { fatalError("Couldn't find desired letter!") }
        givenAnswerSoFar.replaceFirst(desiredLetter, with: nil)
        givenAnswerSoFar[index] = desiredLetter
        givenAnswerSoFar[index]?.isJoker = true
        flyingLetters.removeFirstAppearance(desiredLetter!)
        guard !afterLoad else { return }
        state.updateAfterLetterReveal(revealedIndex: index, powerUp: powerUp)
        if isCorrectAnswer { updateAfterCorrectAnswer() }
        if categoryCompleted { state.categoryCompleted() }
    }
    
    // MARK: - Public API for PowerUps
    
    var allPowers: [Int] { [state.fortuneCount, state.simurghCount, state.apocalypseCount] }
    
    // MARK: - Fortune
    
    mutating func fortune() {
        guard state.fortuneCount > 0 else { return }
        if let random = nonJokerLetterIndices.randomElement() { revealLetter(at: random, with: .fortune) }
    }
    
    // MARK: - Simurgh
    
    private(set) var birdSimurgh = false
    
    mutating func toggleSimurgh() {
        if birdSimurgh { birdSimurgh.toggle() }
        else { if state.simurghCount > 0 { birdSimurgh.toggle() } }
    }
    
    mutating func simurgh(_ index: Int) {
        guard state.simurghCount > 0
            && self.birdSimurgh
            && !jokerLetterIndices.contains(index) else { return }
        revealLetter(at: index, with: .simurgh);
        birdSimurgh = false
    }
    
    // MARK: - Apocalypse
    
    mutating func apocalypse() {
        guard self.state.apocalypseCount > 0 else { return }
        givenAnswerSoFar.forEach { deselectLetter($0) }
        nonJokerLetterIndices.forEach { revealLetter(at: $0, with: .apocalypse) }
        state.updateAfterApocalypse()
    }
    
    var isInitialGame: Bool { currentCategoryIndex == 0 && alreadySolvedIndices.count == 0 }
}
