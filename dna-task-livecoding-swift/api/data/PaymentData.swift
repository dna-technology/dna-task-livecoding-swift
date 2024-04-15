//
//  PaymentData.swift
//  DnaTaskSwift
//
//  Created by Maciej Rudnicki on 15/04/2024.
//

import Foundation


struct PaymentRequest {
    var transactionID: String
    var amount: Double
    var currency: String
    var cardToken: String
}

struct PaymentResponse {
    var transactionID: String
    var status: PaymentStatus
}

enum PaymentStatus {
    case success
    case failed
}
