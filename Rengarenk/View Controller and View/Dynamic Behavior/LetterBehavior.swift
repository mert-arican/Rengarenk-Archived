//
//  LetterBehavior.swift
//  CleanBook
//
//  Created by Mert Arıcan on 12.09.2020.
//  Copyright © 2020 Mert Arıcan. All rights reserved.
//

import UIKit

class LetterBehavior: UIDynamicBehavior {
    private lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    private lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = false
        behavior.elasticity = 1.0
        behavior.density = 0.4
        behavior.resistance = 0.0
        return behavior
    }()
    
    private lazy var lazyItemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.isAnchored = true
        return behavior
    }()
    
    private func push(_ item: UIDynamicItem, keepOnMoving: Bool=false) {
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        push.angle = CGFloat.random(in: 0...(.pi*2)) // (CGFloat.pi*2).arc4random
        push.magnitude = (0.1 * item.bounds.size.width) / 150.0
        push.action = { [unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }
    
    weak var playArea: PlayArea?
    private(set) weak var timer: Timer?
    private var flyingLetters: [LetterView]? { playArea?.unmatchedLetters }
    
    func addItem(_ item: UIDynamicItem, isDynamic:Bool=true) {
        guard flyingLetters != nil && (flyingLetters!.count > 0 || !isDynamic) else { return }
        collisionBehavior.addItem(item)
        if isDynamic {
            itemBehavior.addItem(item)
            self.push(item)
        } else {
            lazyItemBehavior.addItem(item)
        }
    }
    
    func removeItem(_ item: UIDynamicItem, isDynamic:Bool=true) {
        collisionBehavior.removeItem(item)
        if isDynamic { itemBehavior.removeItem(item) }
        else { lazyItemBehavior.removeItem(item) }
    }
    
    func actions() {
        if let _ = self.dynamicAnimator?.referenceView {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_) in
                self.flyingLetters?.forEach {
                    if (((self.playArea?.frame.intersection($0.frame))?.area ?? -1) < $0.frame.area*9/10) {
                        self.removeItem($0)
                        $0.frame.origin = self.playArea?.randomPosition(withTakingCareOfSize: $0.bounds.size) ?? .zero // TO DO
                        self.addItem($0)
                    }
                }
            }
        }
    }
    
    func removeAllItems() {
        self.collisionBehavior.items.forEach { self.collisionBehavior.removeItem($0) }
        self.itemBehavior.items.forEach { self.itemBehavior.removeItem($0) }
        self.lazyItemBehavior.items.forEach { self.lazyItemBehavior.removeItem($0) }
    }
    
    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
        addChildBehavior(lazyItemBehavior)
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] timer in
            print("Time")
            guard let self = self else { timer.invalidate(); return }
            for item in self.flyingLetters ?? [] { self.push(item, keepOnMoving: true) }
            self.actions()
        }
    }
}
