//
//  ViewController.swift
//  HigherOrLower
//
//  Created by Oleksiy Chebotarov on 15/10/2019.
//  Copyright © 2019 Oleksiy Chebotarov. All rights reserved.
//

import UIKit

protocol CardsDisplayLogic: class {
    var previousCard: Card? { get set }

    func updateCardView()
    func hideLoadingIndicator()
}

class CardGameViewController: UIViewController, CardsDisplayLogic {
    @IBOutlet var playedCardView: CardView!

    @IBOutlet var scoreLabel: UILabel!

    @IBOutlet var livesLabel: UILabel!
    var presenter: (CardsPresenterProtocol & CardsDataStore)?
    var previousCard: Card?

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup

    private func setup() {
        let viewController = self
        presenter = Presenter()
        presenter?.viewController = viewController
        presenter?.dataFetcherService = DataFetcherService()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }

    private func config() {
        showIndicator()
        presenter?.fetchCards()
    }

    // MARK: - Protocol methods

    func updateCardView() {
        if cardsDeckNotEmpty() {
            guard let card = self.presenter?.shuffledCards?.removeLast() else {
                return
            }

            presentCard(card: card)
            setupPreviousCard(card)

        } else {
            presenter?.gameOver()
        }
    }

    fileprivate func presentCard(card: Card) {
        performUIUpdatesOnMain {
            self.playedCardView.setupCardView(card: card)
        }
    }

    fileprivate func compareCards(leftCard: Card, rightCard: Card) {
        presenter?.compareCards(leftCard: leftCard, rightCard: rightCard)
    }

    fileprivate func setupPreviousCard(_ card: Card) {
        previousCard = card
    }

    fileprivate func cardsDeckNotEmpty() -> Bool {
        return presenter?.shuffledCards?.count ?? 0 > 0
    }

    func hideLoadingIndicator() {
        hideIndicator()
    }

    // MARK: - Show/hide indicator

    func showIndicator() {
        performUIUpdatesOnMain {
            LoadingIndicatorView.show()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }

    func hideIndicator() {
        performUIUpdatesOnMain {
            LoadingIndicatorView.hide()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }

    @IBAction func loverButtonPressed(_: Any) {
        if cardsDeckNotEmpty() {
            guard let card = self.presenter?.shuffledCards?.removeLast() else {
                return
            }

            presentCard(card: card)

            guard let previousCard = previousCard else {
                return
            }

            compareCards(leftCard: card, rightCard: previousCard)
            setupPreviousCard(card)

        } else {
            presenter?.gameOver()
        }
    }

    @IBAction func higherButonPressed(_: Any) {
        if cardsDeckNotEmpty() {
            guard let card = self.presenter?.shuffledCards?.removeLast() else {
                return
            }

            presentCard(card: card)

            guard let previousCard = previousCard else {
                return
            }

            compareCards(leftCard: previousCard, rightCard: card)
            setupPreviousCard(card)

        } else {
            presenter?.gameOver()
        }
    }
}
