//
//  TemplateViewController.swift
//  Flying Letters
//
//  Created by Mert Arıcan on 3.11.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController, HomeScreenProtocol {
    // MARK:- IBOutlets and IBActions
    @IBOutlet private weak var safeArea: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var classicButton: UIButton!
    @IBOutlet private weak var buttonsArea: UIView!
    @IBOutlet private weak var buttonsHeight: NSLayoutConstraint!
    
    // MARK: - Title and ViewController Lifecycle
    
    private var _title = isPad ? ["RENGARENK"] : ["RENGA", "RENK"]
    private var height = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Constantstinopolis.loadCategories()
        ProductFetcher.fetchProducts()
//        imageView.image = UIImage(uncachedjpg: "0")
        imageView.backgroundColor = theColor
        classicButton.backgroundColor = Colors.getMixedColors(of: 1, except: [#colorLiteral(red: 0.08393948525, green: 0.4489227533, blue: 0.9299840331, alpha: 1), #colorLiteral(red: 0.2405773699, green: 0.7062084079, blue: 1, alpha: 1), #colorLiteral(red: 0.5148210526, green: 0.455485642, blue: 0.6614447236, alpha: 1), #colorLiteral(red: 0.6042832136, green: 0.5346438885, blue: 0.7763594985, alpha: 1), #colorLiteral(red: 0.9411380291, green: 0.09814669937, blue: 0.2134164572, alpha: 1), #colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1)]).first ?? Colors.randomColor
        classicButton.addTarget(self, action: #selector(presentGame(_:)), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !viewAppeared {
            isPro = self.view.bounds.area > 1000000
            var mixedColors = Colors.getMixedColorsFromColorWheel(of: 9, forHome: true)
            addTitle(
                title: _title,
                in: safeArea,
                withSideLength: HomeScreenConstants.titleSquareLength,
                withSpacing: HomeScreenConstants.titleSpacing,
                to: view,
                height: &height,
                toAdd: true
            )
            for fly in self.view.subviews.compactMap({ $0 as? LetterView }) {
                fly.setBackground(mixedColors.removeLast())
            }
            classicButton.titleLabel?.numberOfLines = 2
            classicButton.titleLabel?.textAlignment = .center
            classicButton.getCommonCornerRadius()
            classicButton.dropShadow()
            addButtons()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        classicButton.setTitle("\(LocalizedTexts.level)\n\(Constantstinopolis.gameState.categoryIndex)", for: .normal)
    }
    
    private var viewAppeared = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewAppeared = true
        isPro = self.view.bounds.area > 1000000
        print(Constantstinopolis.appState.octupledCategoryRewards, "YO")
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
    
    // MARK: - Utility functions
    
    private func addButtons() {
        var buttonPlaceholders = [AnswerCellView]()
        let answerArea = AnswerArea(frame: buttonsArea.frame)
        var mixedColors = Colors.getMixedColorsFromColorWheel(of: HomeScreenConstants.menuButtons.count)
        answerArea.isUserInteractionEnabled = false
        self.view.subviews.compactMap { $0 as? AnswerArea }.forEach { $0.removeFromSuperview() }
        self.view.addSubview(answerArea)
        answerArea.designForHome(
            length: HomeScreenConstants.buttonLength,
            origin: nil,
            spacing: HomeScreenConstants.menuButtonSpacing,
            answer: HomeScreenConstants.buttonShortcuts
        )
        answerArea.answerCells.forEach { buttonPlaceholders.append($0) }
        self.view.subviews.compactMap { $0 as? SurroundingButton }.forEach { $0.removeFromSuperview() }
        for (index, placeholder) in buttonPlaceholders.enumerated() {
            let button = SurroundingButton(frame: placeholder.frame)
            button.name = HomeScreenConstants.menuButtons[index]
            button.vcIdentifier = HomeScreenConstants.menuControllerIdentifiers[index]
            let imageView = UIImageView(frame: button.bounds.padding(button.bounds.width/4)!)
            imageView.tintColor = .white
            imageView.image = UIImage(systemImageWithBackupNamed: HomeScreenConstants.assets[button.name]!)
            button.addSubview(imageView)
            button.getCommonCornerRadius()
            button.backgroundColor = mixedColors.popLast()
            button.dropShadow()
            button.addTarget(self, action: #selector(presentMenuItem(_:)), for: .touchUpInside)
            placeholder.removeFromSuperview()
            view.addSubview(button)
        }
    }
    
    // MARK: - Gestures
    
    @objc private func presentMenuItem(_ sender: SurroundingButton) {
        let viewController = Constantstinopolis.getViewController(name: "Menu", withIdentifier: sender.vcIdentifier!)
        self.present(viewController, animated: true)
    }
    
    @objc private func presentGame(_ sender: UIButton) {
        let gameViewController = Constantstinopolis.getViewController(withIdentifier: "PlayVC")
        if Constantstinopolis.categoryIndex >= Constantstinopolis.categories.count {
            present(Constantstinopolis.presentLevelsCompletedAlert(handler: {}), animated: true)
        } else {
            self.present(gameViewController, animated: true)
        }
    }
}
