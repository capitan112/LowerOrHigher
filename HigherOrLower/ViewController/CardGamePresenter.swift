//
//  CardGamePresenter.swift
//  HigherOrLower
//
//  Created by Oleksiy Chebotarov on 15/10/2019.
//  Copyright © 2019 Oleksiy Chebotarov. All rights reserved.
//

import Foundation

protocol CardsPresenterProtocol {
    var dataFetcherService: DataFetcherProtocol? { get set }
    var viewController: CardsDisplayLogic? { get set }
    
    func compareCards(lowerCard: Card, higherCard: Card)
    func fetchCards()
    func shuffleCards()
    func gameOver()
    func startNewGame()
    func getCard() -> Card?
    func setupPreviousCard(_ card: Card)
}

protocol CardsDataStore {
    var shuffledDeck: [Card]? { get set }
    var previousCard: Card? { get set }
}

class CardGamePresenter: CardsPresenterProtocol, CardsDataStore {
    var dataFetcherService: DataFetcherProtocol?
    var viewController: CardsDisplayLogic?
    internal var originDeck: [Card]?
    var shuffledDeck: [Card]?
    var scoreCounter: ScoreCounter!
    var previousCard: Card?

    func fetchCards() {
        scoreCounter = ScoreCounter()
        dataFetcherService?.fetchCardsInfo(completion: { [unowned self] deck in
            self.originDeck = deck
            self.shuffleCards()
            self.updateUI()
        })

        updateScore()
    }

    fileprivate func updateScore() {
        viewController?.updateScore(score: scoreCounter)
    }

    func shuffleCards() {
        shuffledDeck = originDeck?.shuffled()
    }

    func updateUI() {
        viewController?.hideLoadingIndicator()
        viewController?.updateCardView()
    }

    func getCard() -> Card? {
        if cardsDeckNotEmpty() {
            guard let card = shuffledDeck?.removeLast() else {
                return nil
            }
            
            return card
        } else {
            gameOver()
            return nil
        }
    }
    
    func setupPreviousCard(_ card: Card) {
        previousCard = card
    }

    fileprivate func cardsDeckNotEmpty() -> Bool {
        return shuffledDeck?.count ?? 0 > 0
    }

    func compareCards(lowerCard: Card, higherCard: Card) {
        if higherCardIsBigger(lowerCard: lowerCard, higherCard: higherCard) {
            increaseScore()
        } else {
            decreaseLives()
        }

        if livesIsOver() {
            gameOver()
        }

        updateScore()
    }

    fileprivate func increaseScore() {
        scoreCounter.increaseScore()
    }

    fileprivate func decreaseLives() {
        scoreCounter.decreaseLives()
    }

    fileprivate func higherCardIsBigger(lowerCard: Card, higherCard: Card) -> Bool {
        return higherCard.getCardRank() >= lowerCard.getCardRank()
    }

    fileprivate func livesIsOver() -> Bool {
        return scoreCounter.getLives() < 1
    }

    func gameOver() {
        updateScore()
        viewController?.hideBetButtons()
    }

    func startNewGame() {
        scoreCounter = ScoreCounter()
        updateScore()
        shuffleCards()
        updateUI()
        viewController?.showBetButtons()
    }
}
