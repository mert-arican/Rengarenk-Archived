//
//  NewInfoViewController.swift
//  Rengarenk
//
//  Created by Mert Arıcan on 20.01.2021.
//  Copyright © 2021 Mert Arıcan. All rights reserved.
//

import UIKit

class NewInfoViewController: UIViewController, HomeScreenProtocol, UICollectionViewDataSource, UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var surroundingView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var topView: UILabel!
    
    private var _title = LocalizedTitles.info
    private var height = CGFloat()
    
    var imageMaybe: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.numberOfPages = InfoItem.allItems.count
        pageControl.isUserInteractionEnabled = false
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.register(NewInfoItemCollectionViewCell.self, forCellWithReuseIdentifier: "InfoItemCell")
        InfoItem.allInfoDescriptions = LocalizedTexts.infoDescriptions
        imageView.backgroundColor = theColor
        imageView.image = imageMaybe ?? UIImage(uncachedjpg: "0")
        surroundingView.getCommonCornerRadius()
        surroundingView.clipsToBounds = true
        closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backHome(_:))))
    }
    
    private var viewAppeared = false
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !viewAppeared {
            addTitle(
                title: _title,
                in: surroundingView,
                withSideLength: isPad ? 55.0 : 40.0,
                withSpacing: 3.0,
                to: view,
                height: &height,
                toAdd: true
            )
            var mixedColors = Colors.getMixedColorsFromColorWheel(of: _title.joined().count)
            surroundingView.backgroundColor = Colors.getMixedColors(of: 1, except: mixedColors+[#colorLiteral(red: 0.9411380291, green: 0.09814669937, blue: 0.2134164572, alpha: 1)]).first ?? .gray
            topView.backgroundColor = surroundingView.backgroundColor?.adjust(by: -20.0)
            for fly in self.view.subviews.compactMap({ $0 as? LetterView }) {
                fly.moveBy(dx: -surroundingView.frame.minX)
                fly.setBackground(mixedColors.removeLast())
            }
        }
        closeButton.setImage(UIImage(systemImageWithBackupNamed: "xmark.circle"), for: .normal)
        surroundingView.sendSubviewToBack(topView)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewAppeared = true
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
    
    // MARK: - CollectionView Layout
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return InfoItem.allItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoItemCell", for: indexPath)
        if let cell = cell as? NewInfoItemCollectionViewCell {
            cell.getCommonCornerRadius()
            cell.item = InfoItem.allItems[indexPath.item]
        }
        return cell
    }
    
    // MARK: - Gestures
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    @objc private func backHome(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.presentingViewController?.dismiss(animated: true)
        }
    }
}
