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
            self.hideIndicator()
            if let card = self.presenter?.shuffledCards?[0] {
                self.playedCardView.setupCardView(card: card)
            }
            
        }
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
    
    @IBAction func changeCardButton(_ sender: Any) {
        presenter?.shuffleCards()
    }
    
}
