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
    
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    func setupCardView(card: Card) {
        leftUpSuit.text = card.getCardSymbol()
        rightDownSuit.text = card.getCardSymbol()
        centerRank.text = card.value
    }

}
