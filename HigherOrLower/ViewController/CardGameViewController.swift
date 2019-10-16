//
//  ViewController.swift
//  HigherOrLower
//
//  Created by Oleksiy Chebotarov on 15/10/2019.
//  Copyright © 2019 Oleksiy Chebotarov. All rights reserved.
//

import UIKit

protocol CardsDisplayLogic: class {
    func updateCardView()
    func hideLoadingIndicator()
    func updateScore(score: ScoreCounter)
    func hideBetButtons()
    func showBetButtons()
}

class CardGameViewController: UIViewController, CardsDisplayLogic {
    @IBOutlet var playedCardView: CardView!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var livesLabel: UILabel!
    @IBOutlet var lowerButton: UIButton!
    @IBOutlet var higherButton: UIButton!
    @IBOutlet var startNewGameButton: UIButton!
    @IBOutlet var gameOverLabel: UILabel!

    var gamePresenter: (CardsPresenterProtocol & CardsDataStore)?

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
        gamePresenter = CardGamePresenter()
        gamePresenter?.viewController = viewController
        gamePresenter?.dataFetcherService = DataFetcherService()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }

    private func config() {
        showIndicator()
        showBetButtons()
        gamePresenter?.fetchCards()
    }

    // MARK: - Protocol methods

    func hideBetButtons() {
        performUIUpdatesOnMain {
            self.lowerButton.isHidden = true
            self.higherButton.isHidden = true
            self.startNewGameButton.isHidden = false
            self.gameOverLabel.isHidden = false
        }
    }

    func showBetButtons() {
        performUIUpdatesOnMain {
            self.lowerButton.isHidden = false
            self.higherButton.isHidden = false
            self.startNewGameButton.isHidden = true
            self.gameOverLabel.isHidden = true
        }
    }

    func updateScore(score: ScoreCounter) {
        scoreLabel.text = "Score: " + score.getScore()
        livesLabel.text = "Lives: " + score.getLives()
    }

    func updateCardView() {
        guard let card = gamePresenter?.getCard() else {
            return
        }

        presentCard(card: card)
        gamePresenter?.setupPreviousCard(card)
    }

    fileprivate func presentCard(card: Card) {
        performUIUpdatesOnMain {
            self.playedCardView.setupCardView(with: card)
        }
    }

    fileprivate func compareCards(lowerCard: Card, higherCard: Card) {
        gamePresenter?.compareCards(lowerCard: lowerCard, higherCard: higherCard)
    }

    func hideLoadingIndicator() {
        hideIndicator()
    }

    // MARK: - Show/hide indicator

    fileprivate func showIndicator() {
        performUIUpdatesOnMain {
            LoadingIndicatorView.show()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }

    fileprivate func hideIndicator() {
        performUIUpdatesOnMain {
            LoadingIndicatorView.hide()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }

    @IBAction func loverButtonPressed(_: Any) {
        guard let card = gamePresenter?.getCard() else {
            return
        }

        presentCard(card: card)
        guard let previousCard = gamePresenter?.previousCard else {
            return
        }

        compareCards(lowerCard: card, higherCard: previousCard)
        gamePresenter?.setupPreviousCard(card)
    }

    @IBAction func higherButonPressed(_: Any) {
        guard let card = gamePresenter?.getCard() else {
            return
        }

        presentCard(card: card)

        guard let previousCard = gamePresenter?.previousCard else {
            return
        }

        compareCards(lowerCard: previousCard, higherCard: card)
        gamePresenter?.setupPreviousCard(card)
    }

    @IBAction func startNewGameButtonPressed(_: Any) {
        gamePresenter?.startNewGame()
    }
}
