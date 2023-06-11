//
//  ProductFetcher.swift
//  Rengarenk
//
//  Created by Mert Arıcan on 25.01.2021.
//  Copyright © 2021 Mert Arıcan. All rights reserved.
//

import Foundation
import StoreKit

class ProductFetcher: NSObject, SKProductsRequestDelegate {
    static var shared = ProductFetcher()
    
    static func fetchProducts() {
        MarketItem.prepareAllItems()
        let request = SKProductsRequest(productIdentifiers: MarketItem.allIdentifiers)
        request.delegate = shared
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        var priceInfo = [String:String]()
        response.products.forEach { priceInfo[$0.productIdentifier] = $0.regularPrice ?? "" }
        MarketViewController.priceInfo = priceInfo
    }
}

extension SKProduct {
    /// - returns: The cost of the product formatted in the local currency.
    var regularPrice: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price)
    }
}
