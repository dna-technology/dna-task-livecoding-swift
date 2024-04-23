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

    @Published var cart: [CartProduct] = [] {
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
            if (self.cart.map{ $0.productID }.contains(productID)) {
                let cartProduct = self.cart.first{ $0.productID == productID }
                if(cartProduct != nil) {
                    cartProduct!.amount = cartProduct!.amount + 1
                }
            } else {
                self.cart.append(CartProduct(productID: productID, amount: 1))
            }
        }
    }
    
    func removeFromCart(productID: String) {
        DispatchQueue.main.async {
            let cartProduct = self.cart.first{ $0.productID == productID }
            if(cartProduct != nil) {
                let count = cartProduct?.amount
                
                if (count ?? 0 > 1) {
                    cartProduct!.amount = cartProduct!.amount - 1
                } else if (count ?? 0 == 1) {
                    self.cart.removeAll{ $0.productID == productID }
                }
            }
        }
    }
    
    func cartItemsCount() -> Int64 {
        return cart
            .map{ $0.amount}
            .reduce(0, +)
    }
}
