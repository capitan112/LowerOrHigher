//
//  Card.swift
//  HigherOrLower
//
//  Created by Oleksiy Chebotarov on 15/10/2019.
//  Copyright © 2019 Oleksiy Chebotarov. All rights reserved.
//

import Foundation

struct Card: Decodable {
    var value: String
    var suit: String
    private let ranks = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]

    func getCardSymbol() -> String {
        return convertToSuit(from: suit).rawValue
    }

    fileprivate func convertToSuit(from string: String) -> Suit {
        var suit: Suit!

        switch string {
        case "hearts":
            suit = Suit.Heart
        case "diamonds":
            suit = Suit.Diamond
        case "spades":
            suit = Suit.Spade
        case "clubs":
            suit = Suit.Club
        default:
            break
        }

        return suit
    }

    func getCardRank() -> Int {
        return ranks.firstIndex(of: value) ?? 0
    }
}

enum Suit: String {
    case Heart = "♥️"
    case Diamond = "♦️"
    case Spade = "♠️"
    case Club = "♣️"
}
