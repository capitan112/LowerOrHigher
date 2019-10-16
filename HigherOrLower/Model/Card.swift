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
    
    func cardTitle() -> String {
        return value + " " + convertStringToSuit(string: suit).rawValue
    }
    
    private func convertStringToSuit(string: String) -> Suit {
        var suit: Suit!
        
        switch string {
        case "hearts":
            suit =  Suit.Heart
        case "diamonds":
            suit =  Suit.Diamond
        case "spades":
            suit =  Suit.Spade
        case "clubs":
            suit = Suit.Club
        default:
            break
        }
        
        return suit
    }
    
}

enum Suit: String {
    case Heart = "♥️"
    case Diamond = "♦️"
    case Spade = "♠️"
    case Club = "♣️"
}
