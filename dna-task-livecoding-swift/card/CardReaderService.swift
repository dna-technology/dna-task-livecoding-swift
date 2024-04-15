//
//  CardReaderService.swift
//  DnaTaskSwift
//
//  Created by Maciej Rudnicki on 15/04/2024.
//

import Foundation

struct CardData {
    var token: String
}

/**
 * This is a mock implementation.
 * For the purposes of this task we simply pretend there is a service we are using.
 *
 * To simulate errors, service throws `CardReaderException` in the second half of any minute.
 */
class CardReaderService {

    func readCard() async throws -> CardData{
        let second = Calendar.current.dateComponents([.second], from: Date.now).month!

        if (second <= 30) {
            // User will need some time to use the card
            sleep(4)
            return CardData(token: UUID().uuidString)
        }

        throw CardReaderError()
    }

}

struct CardReaderError: Error {
    var message: String
    
    init() {
        message = "Could not read card data"
    }
}
