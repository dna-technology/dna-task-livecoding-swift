//
//  PurchaseData.swift
//  DnaTaskSwift
//
//  Created by Maciej Rudnicki on 15/04/2024.
//

import Foundation

struct PurchaseRequest{ var order: [String:Int64]}

struct PurchaseResponse{
    var order: [String:Int64]
    var transactionID: String
    var transactionStatus: TransactionStatus}

struct PurchaseConfirmRequest{
    var order: [String:Int64]
    var transactionID: String
}

    struct PurchaseCancelRequest{ var transactionID: String}

struct PurchaseStatusResponse{
    var transactionID: String
    var status: TransactionStatus
}

enum TransactionStatus {
    case INITIATED
    case CONFIRMED
    case CANCELLED
    case FAILED
}

