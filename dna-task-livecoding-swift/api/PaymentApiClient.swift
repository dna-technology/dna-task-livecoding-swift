//
//  PaymentApiClient.swift
//  DnaTaskSwift
//
//  Created by Maciej Rudnicki on 15/04/2024.
//

import Foundation


/**
 * This is a mock implementation.
 * For the purposes of this task we simply pretend there is an API we are using.
 *
 * For ease of testing it has some hardcoded rules:
 * 1. Executing payments with currency different from `EUR` will fail
 * 2. Executing payments with amount < 20.00 will fail
 * 3. Reverting payment with amount < 1.00 will fail
 */
public class PaymentApiClient {
    /**
     * Call this method to execute payment on the account connected with provided card token
     */
    func pay(paymentRequest: PaymentRequest) async -> PaymentResponse {
        usleep(2500)

        return if (paymentRequest.currency == "EUR" && paymentRequest.amount >= 20.00 ) {
            PaymentResponse(transactionID: paymentRequest.transactionID, status: .success)
        } else {
            PaymentResponse(transactionID: paymentRequest.transactionID, status: .failed)
        }
    }

    /**
     * Method meant for reverting payment when transaction could not be completed by the merchant.
      */
    func revert(paymentRequest: PaymentRequest) async -> PaymentResponse {
        usleep(5000)
        return if (paymentRequest.amount >= 1.00 ) {
            PaymentResponse(transactionID: paymentRequest.transactionID, status: .success)
        } else {
            PaymentResponse(transactionID: paymentRequest.transactionID, status: .failed)
        }
    }
}
