//
//  StoreObserver.swift
//  Rengarenk
//
//  Created by Mert Arıcan on 25.01.2021.
//  Copyright © 2021 Mert Arıcan. All rights reserved.
//

import Foundation
import StoreKit

class StoreObserver: NSObject, SKRequestDelegate, SKPaymentTransactionObserver {
    weak var delegate: UIViewController?
    
    var isAuthorizedForPayments: Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                MarketItem.productBought(withProductID: transaction.payment.productIdentifier)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                if (transaction.error as? SKError)?.code != .paymentCancelled {
                    DispatchQueue.main.async { [weak self] in
                        self?.storeObserverDidReceiveMessage(transaction.error?.localizedDescription)
                    }
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
                MarketItem.productBought(withProductID: productIdentifier)
                SKPaymentQueue.default().finishTransaction(transaction)
                restoreSuccessful()
            default: break
            }
        }
    }
    
    func storeObserverDidReceiveMessage(_ message: String?) {
        guard let error = message else { return }
        let alert = UIAlertController(
            title: LocalizedTexts.error,
            message: error,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: LocalizedTexts.okay,
            style: .default,
            handler: nil
            )
        )
        self.delegate?.present(alert, animated: true)
    }
    
    func restoreSuccessful() {
        guard self.delegate?.presentedViewController == nil else { return }
        let alert = UIAlertController(
            title: LocalizedTexts.restoredSuccessfully,
            message: LocalizedTexts.restoredSuccessfully,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: LocalizedTexts.okay,
            style: .default,
            handler: nil
            )
        )
        self.delegate?.present(alert, animated: true)
    }
    
    func buyProduct(withProductIdentifier productIdentifier: String) {
        guard isAuthorizedForPayments && MarketItem.allIdentifiers.contains(productIdentifier) else { return }
        let payment = SKMutablePayment()
        payment.productIdentifier = productIdentifier
        SKPaymentQueue.default().add(payment)
    }
    
    func restore() { SKPaymentQueue.default().restoreCompletedTransactions() }
}
