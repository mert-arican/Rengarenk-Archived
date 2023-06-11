//
//  SettingsCollectionViewController.swift
//  Rengarenk
//
//  Created by Mert Arıcan on 18.11.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, HomeScreenProtocol, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // MARK: - IBOutlets
    @IBOutlet private weak var safeArea: UIView!
    @IBOutlet private weak var notch: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var bottomBarView: TemplateView!
    @IBOutlet private weak var buttonImage: UIImageView!
    
    // MARK: - Title and ViewController Lifecycle
    
    private var _title: [String] = LocalizedTitles.settings
    private var height = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = theColor
        MarketViewController.storeObserver.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView?.register(SettingsCollectionViewCell.self, forCellWithReuseIdentifier: "SettingsItemCell")
        bottomBarView.backgroundColor = Colors.randomColor
        bottomBarView.getCommonCornerRadius()
        bottomBarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backHome(_:))))
        buttonImage.image = UIImage(systemImageWithBackupNamed: "house.fill")
        buttonImage.tintColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !didAppear {
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .bottom, animated: false)
            bottomBarView.dropStaticShadow()
        }
    }
    
    private var didAppear = false
    
    override func viewWillAppear(_ animated: Bool) {
        // Run-time language change.
        super.viewWillAppear(animated)
        if didAppear {
            if _title != LocalizedTitles.settings {
                _title = LocalizedTitles.settings
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        didAppear = true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
    
    // MARK: - CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SettingsItem.allItems.count
    }
    
    // MARK: - HeaderView
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        addTitle(
            title: _title,
            in: safeArea,
            withSideLength: HomeScreenConstants.titleSquareLength,
            withSpacing: HomeScreenConstants.titleSpacing,
            to: self.view,
            height: &height,
            toAdd: false
        )
        return .init(width: collectionView.bounds.width, height: self.height - notch.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath)
        header.subviews.forEach { $0.removeFromSuperview() }
        addTitle(
            title: _title,
            in: safeArea,
            withSideLength: HomeScreenConstants.titleSquareLength,
            withSpacing: HomeScreenConstants.titleSpacing,
            to: header,
            height: &height,
            toAdd: true
        )
        var mixedColors = Colors.getMixedColorsFromColorWheel(of: _title.joined().count)
        for fly in header.subviews.compactMap({ $0 as? LetterView }) {
            fly.setBackground(mixedColors.removeLast())
        }
        header.clipsToBounds = false
        header.subviews.forEach { $0.moveBy(dx: 0.0, dy: -notch.bounds.height) }
        return header
    }
    
    // MARK: - CollectionView Layout
    
    private let spacing: CGFloat = 60.0
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = isPad ? 2 : 1
        let spacingBetweenCells: CGFloat = self.spacing
        
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
        if let collection = self.collectionView {
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: width)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SettingsItemCell", for: indexPath)
        if let cell = cell as? SettingsCollectionViewCell {
            cell.getCommonCornerRadius()
            cell.item = SettingsItem.allItems[indexPath.item]
            cell.present = { [weak self] viewController in self?.present(viewController, animated: true) }
        }
        return cell
    }
    
    // MARK: - Gestures
    
    @objc private func backHome(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.presentingViewController?.dismiss(animated: true)
        }
    }
}
