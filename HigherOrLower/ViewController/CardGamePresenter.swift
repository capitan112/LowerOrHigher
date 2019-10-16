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
}

protocol CardsDataStore {
    var shuffledCards: [Card]? { get set }
}

class Presenter: CardsPresenterProtocol, CardsDataStore {
    var dataFetcherService: DataFetcherProtocol?
    var viewController: CardsDisplayLogic?
    internal var cards: [Card]?
    var shuffledCards: [Card]?
    var scoreCounter: ScoreCounter!

    func fetchCards() {
        scoreCounter = ScoreCounter()
        dataFetcherService?.fetchCardsInfo(completion: { [unowned self] cards in
            self.cards = cards
            self.shuffleCards()
            self.updateUI()
        })

        setUpScore()
    }

    fileprivate func setUpScore() {
        viewController?.setupScore(score: scoreCounter)
    }

    func shuffleCards() {
        shuffledCards = cards?.shuffled()
    }

    func updateUI() {
        viewController?.hideLoadingIndicator()
        viewController?.updateCardView()
    }

    func compareCards(lowerCard: Card, higherCard: Card) {
        if higherCardBigger(lowerCard: lowerCard, higherCard: higherCard) {
            increaseScore()
        } else {
            if livesIsNotOver() {
                decreaseLives()
            } else {
                gameOver()
            }
        }

        setUpScore()
    }

    fileprivate func increaseScore() {
        scoreCounter.increaseScore()
    }
    
    fileprivate func decreaseLives() {
        scoreCounter.decreaseLives()
    }

    fileprivate func higherCardBigger(lowerCard: Card, higherCard: Card) -> Bool {
        return higherCard.getCardRank() >= lowerCard.getCardRank()
    }

    fileprivate func livesIsNotOver() -> Bool {
        return scoreCounter.getLives() > 0
    }

    func gameOver() {
        viewController?.hideBetButton()
    }

    func startNewGame() {
        scoreCounter = ScoreCounter()
        setUpScore()
        shuffleCards()
        updateUI()
        viewController?.showBetButton()
    }
}
