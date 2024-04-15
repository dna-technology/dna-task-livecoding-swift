//
//  ProductsModel.swift
//  DnaTaskSwift
//
//  Created by Maciej Rudnicki on 15/04/2024.
//
import Foundation
import SwiftUI
import Combine

class ProductsModel: ObservableObject{

    let purchaseApiClient: PurchaseApiClient = PurchaseApiClient()

    @Published var cart: [String:Int64] = [:] {
        didSet {
            DispatchQueue.main.async {
                self.cart = self.cart
            }
        }
    }

    @Published var products: [Product] = [] {
        didSet {
            DispatchQueue.main.async {
                self.products = self.products
            }
        }
    }

    func getProducts() {
        Task {
            let newProducts = await purchaseApiClient.getProducts()
            DispatchQueue.main.async {
                self.products = newProducts
            }
        }
    }

    func addToCart(productID: String) {
        DispatchQueue.main.async {
            if (self.cart.keys.contains(productID)) {
                self.cart[productID] = self.cart[productID]! + 1
            } else {
                self.cart[productID] = 1
            }
        }
    }
    
    func removeFromCart(productID: String) {
        DispatchQueue.main.async {
            let count = self.cart[productID]
        
            if (count ?? 0 > 1) {
                self.cart[productID] = self.cart[productID]! - 1
            } else if (count ?? 0 == 1) {
                self.cart.removeValue(forKey: productID)
            }
        }
    }
    
    func cartItemsCount() -> Int64 {
        return cart
            .values
            .reduce(0, +)
    }
}
