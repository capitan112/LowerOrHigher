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
    func setupScore(score: ScoreCounter)
    func hideBetButton()
    func showBetButton()
}

class CardGameViewController: UIViewController, CardsDisplayLogic {
    @IBOutlet var playedCardView: CardView!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var livesLabel: UILabel!

    @IBOutlet var lowerButton: UIButton!
    @IBOutlet var higherButton: UIButton!
    @IBOutlet var startNewGameButton: UIButton!
    @IBOutlet var gameOverLabel: UILabel!

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
        showBetButton()
        presenter?.fetchCards()
    }

    // MARK: - Protocol methods

    func hideBetButton() {
        performUIUpdatesOnMain {
            self.lowerButton.isHidden = true
            self.higherButton.isHidden = true
            self.startNewGameButton.isHidden = false
            self.gameOverLabel.isHidden = false
        }
    }

    func showBetButton() {
        performUIUpdatesOnMain {
            self.lowerButton.isHidden = false
            self.higherButton.isHidden = false
            self.startNewGameButton.isHidden = true
            self.gameOverLabel.isHidden = true
        }
    }

    func setupScore(score: ScoreCounter) {
        scoreLabel.text = "Score: " + score.getScore()
        livesLabel.text = "Lives: " + score.getLives()
    }

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
            self.playedCardView.setupCardView(with: card)
        }
    }

    fileprivate func compareCards(lowerCard: Card, higherCard: Card) {
        presenter?.compareCards(lowerCard: lowerCard, higherCard: higherCard)
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
        if cardsDeckNotEmpty() {
            guard let card = self.presenter?.shuffledCards?.removeLast() else {
                return
            }

            presentCard(card: card)

            guard let previousCard = previousCard else {
                return
            }

            compareCards(lowerCard: card, higherCard: previousCard)
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

            compareCards(lowerCard: previousCard, higherCard: card)
            setupPreviousCard(card)

        } else {
            presenter?.gameOver()
        }
    }

    @IBAction func startNewGameButtonPressed(_: Any) {
        presenter?.startNewGame()
    }
}
