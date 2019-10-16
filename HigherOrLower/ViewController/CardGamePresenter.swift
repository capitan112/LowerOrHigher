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
    func compareCards(leftCard: Card, rightCard: Card)
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
        })
        
        setUpScore()
        
    }

    func setUpScore() {
        viewController?.setupScore(score: scoreCounter)
    }
    
    func shuffleCards() {
        shuffledCards = cards?.shuffled()
        viewController?.hideLoadingIndicator()
        viewController?.updateCardView()
    }

    func compareCards(leftCard: Card, rightCard: Card) {
        if rightCard.getCardRank() >= leftCard.getCardRank() {
            scoreCounter.increaseScore()
        } else {
            if scoreCounter.getLives() > 0 {
                scoreCounter.decreaseLives()
            } else {
                gameOver()
            }
        }
        
        setUpScore()
    }

    func gameOver() {
        viewController?.hideBetButton()
    }
    
    func startNewGame() {
        scoreCounter = ScoreCounter()
        setUpScore()
        shuffleCards()
        viewController?.showBetButton()
    }
}
