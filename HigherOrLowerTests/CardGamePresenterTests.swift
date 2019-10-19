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
        cardGamePresenter.dataFetcherService = DataFetcherService()
    }

    override func tearDown() {
        cardGamePresenter = nil
        super.tearDown()
    }

    fileprivate func getDeck() {
        let exp = expectation(description: "Completion block called for full deck")
        
        cardGamePresenter.dataFetcherService?.fetchCardsInfo(completion: { deck in
            cardGamePresenter.originDeck = deck
            exp.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    fileprivate func shuffleDeck() {
        cardGamePresenter.shuffleCards()
    }
    
    func testShuffleCardsShouldProvideShuffledDeck() {
        getDeck()
        shuffleDeck()

//        Then
        guard let shuffledDeck = cardGamePresenter.shuffledDeck else {
            XCTFail("shuffledDeck is not exist")
            return
        }
        
        guard let originDeck = cardGamePresenter.originDeck else {
            XCTFail()
            XCTFail("originDeck is not exist")
            return
        }
        
        
        var equalCards = 0
        
        for (shuffledCard, originCard) in zip(shuffledDeck, originDeck) {
            if shuffledCard == originCard {
                equalCards += 1
            }
        }
        
        XCTAssertNotEqual(equalCards, originDeck.count, "Shuffed card should be equal origin deck")
    }

    func testFetchCardsShouldReturnFullDeck() {
        getDeck()
        
        XCTAssertEqual(cardGamePresenter.originDeck?.count, 52)
        
        let Aspades = Card(value: "A", suit: "spades")
        XCTAssertEqual(cardGamePresenter.originDeck?[0], Aspades)
        
        let twoSpades = Card(value: "2", suit: "spades")
        XCTAssertEqual(cardGamePresenter.originDeck?[1], twoSpades)
        
        XCTAssertEqual(cardGamePresenter.originDeck?.count, 52, "Presenter should load 52 cards to deck")
    }
    
    
    func testGetCardShouldReturnCards() {
        getDeck()
        shuffleDeck()
        
        guard let card = cardGamePresenter.getCard() else {
            XCTFail("card shoudl esist after getCard() method")
            return
        }
        
        XCTAssertNotNil(card)
    }
    
    func testGetCardShouldReturnLastCard() {
        getDeck()
        shuffleDeck()
        let lastShuffledDeckIndex = (cardGamePresenter.shuffledDeck?.count ?? 0) - 1 
        
        for _  in 0..<lastShuffledDeckIndex {
            _ = cardGamePresenter.getCard()
        }
        
        guard let card = cardGamePresenter.getCard() else {
            XCTFail("card shoudl esist after getCard() method")
            return
        }
        
        XCTAssertNotNil(card)
        
        guard let deck = cardGamePresenter.shuffledDeck else {
            XCTFail("shuffled deck should exist")
            return
        }
        
        let cardsInShuffledDeck = deck.count
        XCTAssertTrue(cardsInShuffledDeck == 0, "Shuffled deck should be empty")
    }
}
