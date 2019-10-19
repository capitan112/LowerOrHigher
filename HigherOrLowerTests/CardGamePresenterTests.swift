//
//  HigherOrLowerTests.swift
//  HigherOrLowerTests
//
//  Created by Oleksiy Chebotarov on 15/10/2019.
//  Copyright © 2019 Oleksiy Chebotarov. All rights reserved.
//

@testable import HigherOrLower
import XCTest

var cardGamePresenter: CardGamePresenter!

class HigherOrLowerTests: XCTestCase {
    override func setUp() {
        cardGamePresenter = CardGamePresenter()
    }

    override func tearDown() {
        cardGamePresenter = nil
        super.tearDown()
    }

    func testShuffleCardsShouldProvideShufledDeck() {
//        Given
        
//        When
        cardGamePresenter.shuffleCards()
        let firstCard = Card(value: "A", suit: "spades")
//        Then
        if let firtShuffledCard = cardGamePresenter.shuffledCards?[0] {
            XCTAssertNotEqual(firtShuffledCard, firstCard)
        }
       
    }

    func testFetchCards() {
        //        Given
        cardGamePresenter.dataFetcherService = DataFetcherService()
        let exp = expectation(description: "Completion block called for full deck")
        
        //        When
        cardGamePresenter.dataFetcherService?.fetchCardsInfo(completion: { cards in
            cardGamePresenter.cards = cards
            exp.fulfill()
        })
        
        //        Then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(cardGamePresenter.cards?.count, 52)
        
        let Aspades = Card(value: "A", suit: "spades")
        XCTAssertEqual(cardGamePresenter.cards?[0], Aspades)
        
        let twoSpades = Card(value: "2", suit: "spades")
        XCTAssertEqual(cardGamePresenter.cards?[1], twoSpades)
        
        XCTAssertEqual(cardGamePresenter.cards?.count, 52, "Presenter should load 52 cards to deck")
        
    }
}
