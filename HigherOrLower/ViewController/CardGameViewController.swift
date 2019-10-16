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
}

class CardGameViewController: UIViewController, CardsDisplayLogic {
    
    @IBOutlet weak var playedCardView: CardView!
    var presenter: (CardsPresenterProtocol & CardsDataStore)?

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
        performUIUpdatesOnMain {
            if self.cardsDeckNotEmpty() {
                if let card = self.presenter?.shuffledCards?.removeLast() {
                    self.playedCardView.setupCardView(card: card)
                }
            } else {
                print("game over")

            }
            
        }
    }

    func hideLoadingIndicator() {
        hideIndicator()
    }

    private func cardsDeckNotEmpty() -> Bool {
        return self.presenter?.shuffledCards?.count ?? 0 > 0
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
    
    
    @IBAction func loverButtonPressed(_ sender: Any) {
        self.updateCardView()
    }
    
    @IBAction func higherButonPressed(_ sender: Any) {
        self.updateCardView()
    }
}
