//
//  HomeScreenProtocol.swift
//  Flying Letters
//
//  Created by Mert Arıcan on 3.11.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

protocol HomeScreenProtocol: AnyObject {
    func addTitle(title: [String], in safeArea: UIView, withSideLength sideLength: CGFloat, withSpacing spacing: CGFloat, to view: UIView, height: inout CGFloat, toAdd: Bool)
}

extension HomeScreenProtocol {
    func addTitle(title: [String], in safeArea: UIView, withSideLength sideLength: CGFloat, withSpacing spacing: CGFloat, to view: UIView, height: inout CGFloat, toAdd: Bool) {
        let origin = safeArea.frame.origin.offsetBy(dx: DesignConstants.titleOffset/2.0, dy: spacing)
        let titleArea = AnswerArea(frame: .init(origin: view.bounds.origin, size: .init(width: view.bounds.width - DesignConstants.titleOffset, height: view.bounds.height)))
        view.subviews.compactMap { $0 as? AnswerArea }.forEach { $0.removeFromSuperview() }
        view.addSubview(titleArea) ; titleArea.isHidden = true
        height = titleArea.designForHome(length: sideLength, origin: origin, spacing: spacing, answer: title)
        if !toAdd {
            // If this function call is used only for detecting size, not for actually adding title (used for collection view headers)
            titleArea.removeFromSuperview()
            titleArea.answerCells.forEach { $0.removeFromSuperview() }
            return
        }
        let titleChars = title.joined().map { String($0) }
        titleArea.answerCells.forEach { $0.isHidden = true }
        view.subviews.compactMap { $0 as? LetterView }.forEach { $0.removeFromSuperview() }
        for (index, cell) in titleArea.answerCells.enumerated() {
            let fly = LetterView(frame: cell.frame)
            DesignConstants.scaleForFlies = cell.bounds.width / DesignConstants.standartSizeForLetter.width
            fly.letter = Letter(index: index, character: titleChars[index])
            fly.drawContents()
            fly.moveBy(dx: 0.0, dy: spacing)
            view.addSubview(fly)
            cell.removeFromSuperview()
        }
    }
}
