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
    func fetchCards()
    func shuffleCards()
}

protocol CardsDataStore {
    var shuffledCards: [Card]? { get set }
}

class Presenter: CardsPresenterProtocol, CardsDataStore {
    var dataFetcherService: DataFetcherProtocol?
    var viewController: CardsDisplayLogic?
    internal var cards: [Card]?
    var shuffledCards: [Card]?

    func fetchCards() {
        dataFetcherService?.fetchCardsInfo(completion: { [unowned self] cards in
            self.cards = cards
            self.shuffleCards()
        })
    }
    
    func shuffleCards() {
        shuffledCards = cards?.shuffled()
        self.viewController?.updateCardView()
    }
}
