//
//  PurchaseApiClient.swift
//  DnaTaskSwift
//
//  Created by Maciej Rudnicki on 15/04/2024.
//

import Foundation

/**
 * This is a mock implementation.
 * For the purposes of this task we simply pretend there is an API we are using.
 *
 * Not to complicate things too much we've added condition that the purchase confirmation will fail
 * when total sum of purchase exceeds 100.00.
 */
class PurchaseApiClient {
     
        let productList = [
            Product(productID: "12345", name: "Big soda",maxAmount: 123, unitNetValue: 2.99, unitValueCurrency: "EUR", tax: 0.22),
            Product(productID: "12346", name: "Medium soda", maxAmount: 30, unitNetValue: 1.95, unitValueCurrency: "EUR", tax: 0.22),
            Product(productID: "12347", name: "Small soda",maxAmount: 1000, unitNetValue: 1.25, unitValueCurrency: "EUR", tax: 0.22),
            Product(productID: "12348", name: "Chips",maxAmount: 2000, unitNetValue: 4.33, unitValueCurrency: "EUR", tax: 0.22),
            Product(productID: "12349", name: "Snack bar", maxAmount: 0, unitNetValue: 10.99, unitValueCurrency: "EUR", tax: 0.23),
        ]

    func getProducts() async -> [Product] {
        usleep(3000)
        return productList
    }

    func initiatePurchaseTransaction(purchaseRequest: PurchaseRequest) async -> PurchaseResponse {
        usleep(2500)
        if purchaseRequest.order.isEmpty {
            return PurchaseResponse(order: purchaseRequest.order, transactionID: UUID().uuidString, transactionStatus: .FAILED)
        }

        do {
            var totalPrice: Double = 0
            for cartProduct in purchaseRequest.order {
                guard let orderedProduct = productList.first(where: { $0.productID == cartProduct.productID }) else {
                    throw PurchaseError(message: "Product not found")
                }

                if cartProduct.amount <= 0 {
                    throw PurchaseError(message: "Not allowed to order non-positive number of items")
                }

                if cartProduct.amount > orderedProduct.maxAmount {
                    throw PurchaseError(message: "Not allowed to order more than maxAmount")
                }

                totalPrice += Double(cartProduct.amount) * orderedProduct.unitNetValue * (1.0 + orderedProduct.tax)
            }

            return PurchaseResponse(order: purchaseRequest.order, transactionID: UUID().uuidString, transactionStatus: .INITIATED)
        } catch {
            return PurchaseResponse(order: purchaseRequest.order, transactionID: UUID().uuidString, transactionStatus: .FAILED)
        }
    }

    func confirm(purchaseRequest: PurchaseConfirmRequest) async -> PurchaseStatusResponse {
        usleep(2500)
        if purchaseRequest.order.isEmpty {
            return PurchaseStatusResponse(transactionID: purchaseRequest.transactionID, status: .FAILED)
        }

        do {
            var sum: Double = 0
            for cartProduct in purchaseRequest.order {
                guard let orderedProduct = productList.first(where: { $0.productID == cartProduct.productID }) else {
                    throw PurchaseError(message: "Product not found")
                }

                if cartProduct.amount <= 0 {
                    throw PurchaseError(message: "Not allowed to order non-positive number of items")
                }

                sum += Double(cartProduct.amount) * orderedProduct.unitNetValue * (1.0 + orderedProduct.tax)
            }

            if sum > 100.0 {
                return PurchaseStatusResponse(transactionID: purchaseRequest.transactionID, status: .FAILED)
            }

            return PurchaseStatusResponse(transactionID: purchaseRequest.transactionID, status: .INITIATED)
        } catch {
            return PurchaseStatusResponse(transactionID: purchaseRequest.transactionID, status: .FAILED)
        }
    }


    func cancel(purchaseRequest: PurchaseCancelRequest) async -> PurchaseStatusResponse {
        usleep(2500)
        return PurchaseStatusResponse(transactionID: purchaseRequest.transactionID, status: .CANCELLED)
    }

}

/**
 * productID - globally unique product identifier
 * name - display name
 * maxAmount - available quantity of the product
 * unitNetValue - net value of a single item
 * unitValueCurrency - currency name
 * tax - tax to be added to the net value
 */
class Product: Hashable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.productID == rhs.productID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(productID)        
    }
    
    var productID: String
    var name: String
    var maxAmount: Int64
    var unitNetValue: Double
    var unitValueCurrency: String
    var tax: Double
    
    init(productID: String, name: String, maxAmount: Int64, unitNetValue: Double, unitValueCurrency: String, tax: Double) {
        self.productID = productID
        self.name = name
        self.maxAmount = maxAmount
        self.unitNetValue = unitNetValue
        self.unitValueCurrency = unitValueCurrency
        self.tax = tax
    }

    func toString() -> String {
        return String(format: "%s [ %.2f %s ]", name, unitNetValue * (1.0 + tax), unitValueCurrency)
    }
}

class CartProduct: Hashable {
    
    static func == (lhs: CartProduct, rhs: CartProduct) -> Bool {
        return lhs.productID == rhs.productID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(productID)
    }

    var productID: String
    var amount: Int64
    
    init(productID: String, amount: Int64) {
        self.productID = productID
        self.amount = amount
    }
}

struct PurchaseError: Error {
    var message: String
}
