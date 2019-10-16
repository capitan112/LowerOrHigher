//
//  CardView.swift
//  HigherOrLower
//
//  Created by Oleksiy Chebotarov on 16/10/2019.
//  Copyright © 2019 Oleksiy Chebotarov. All rights reserved.
//

import UIKit

class CardView: UIView {
    @IBOutlet var leftUpSuit: UILabel!
    @IBOutlet var rightDownSuit: UILabel!
    @IBOutlet var centerRank: UILabel!

    override func draw(_: CGRect) {
        setupLayerView()
    }

    func setupLayerView() {
        layer.cornerRadius = 20
        layer.masksToBounds = true
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
    }

    func setupCardView(with card: Card) {
        leftUpSuit.text = card.getCardSymbol()
        rightDownSuit.text = card.getCardSymbol()

        if isRedSuit(card: card) {
            centerRank.textColor = UIColor.red
        } else {
            centerRank.textColor = UIColor.black
        }
        centerRank.text = card.value
    }

    func isRedSuit(card: Card) -> Bool {
        return card.suit == "hearts" || card.suit == "diamonds"
    }
}
