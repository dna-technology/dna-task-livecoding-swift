//
//  dna_task_livecoding_swiftTests.swift
//  dna-task-livecoding-swiftTests
//
//  Created by Maciej Rudnicki on 15/04/2024.
//

import XCTest
@testable import dna_task_livecoding_swift

final class dna_task_livecoding_swiftTests: XCTestCase {
    
    let paymentAPI = PaymentApiClient()
    
    func testWhenCorrectDataThenSuccess() async {
        // given
        let paymentRequest = PaymentRequest(
            transactionID: "Tr1",
            amount: 33.66,
            currency: "EUR",
            cardToken: "Token"
        )
        
        // when
        let paymentResponse = await paymentAPI.pay(paymentRequest: paymentRequest)

        // then
        XCTAssertEqual(paymentResponse.status, .success)
    }
    
    func testWhenIncorrectAmountThenFail() async {
        // given
        let paymentRequest = PaymentRequest(
            transactionID: "Tr1",
            amount: 19.66,
            currency: "EUR",
            cardToken: "Token"
        )
        
        // when
        let paymentResponse = await paymentAPI.pay(paymentRequest: paymentRequest)
        
        // then
        XCTAssertEqual(paymentResponse.status, .failed)
    }
    
    func testWhenIncorrectCurrencyThenFail() async {
        // given
        let paymentRequest = PaymentRequest(
            transactionID: "Tr1",
            amount: 22.66,
            currency: "PLN",
            cardToken: "Token"
        )
        
        // when
        let paymentResponse = await paymentAPI.pay(paymentRequest: paymentRequest)
        
        // then
        XCTAssertEqual(paymentResponse.status, .failed)
    }
    
    func testWhenRevertingCorrectAmountThenSuccess() async {
        // given
        let paymentRequest = PaymentRequest(
            transactionID: "Tr1",
            amount: 12.66,
            currency: "EUR",
            cardToken: "Token"
        )
        
        // when
        let paymentResponse = await paymentAPI.revert(paymentRequest: paymentRequest)
        
        // then
        XCTAssertEqual(paymentResponse.status, .success)
    }
    
    func testWhenRevertingIncorrectAmountThenFail() async {
        // given
        let paymentRequest = PaymentRequest(
            transactionID: "Tr1",
            amount: 0.66,
            currency: "EUR",
            cardToken: "Token"
        )
        
        // when
        let paymentResponse = await paymentAPI.revert(paymentRequest: paymentRequest)
        
        // then
        XCTAssertEqual(paymentResponse.status, .failed)
    }
    
}

final class dna_task_livecoding_swiftPurchaseAPITests: XCTestCase {
    
    let purchaseAPIClient = PurchaseApiClient()
    
    func testWhenGetProductsThenSuccess() async {
        // given/when
        let products = await purchaseAPIClient.getProducts()
        
        // then
        XCTAssertEqual(products.count, 5)
    }
    
    func testWhenInitiateEmptyOrderThenFail() async {
        // given
        let purchaseRequest = PurchaseRequest(order: [:])
        
        // when
        let purchaseResponse = await purchaseAPIClient.initiatePurchaseTransaction(purchaseRequest: purchaseRequest)
        
        // then
        XCTAssertEqual(purchaseResponse.transactionStatus, .FAILED)
    }
    
    func testInitiateOrderWithZeroItemsThenFail() async {
        // given
        let purchaseRequest = PurchaseRequest(order: ["12345":0])
        
        // when
        let purchaseResponse = await purchaseAPIClient.initiatePurchaseTransaction(purchaseRequest: purchaseRequest)
        
        // then
        XCTAssertEqual(purchaseResponse.transactionStatus, .FAILED)
    }
    
    func testInitiateOrderWithToManyItemsThenFail() async {
        // given
        let purchaseRequest = PurchaseRequest(order: ["12345":2001])
        
        // when
        let purchaseResponse = await purchaseAPIClient.initiatePurchaseTransaction(purchaseRequest: purchaseRequest)
        
        // then
        XCTAssertEqual(purchaseResponse.transactionStatus, .FAILED)
    }
    
    func testConfirmrderWithToManyItemsThenFail() async {
        // given
        let purchaseRequest = PurchaseConfirmRequest(order: ["12348":2001], transactionID: "Tr2")
        
        // when
        let purchaseResponse = await purchaseAPIClient.confirm(purchaseRequest: purchaseRequest)
        
        // then
        XCTAssertEqual(purchaseResponse.status, .FAILED)
    }
    
}
