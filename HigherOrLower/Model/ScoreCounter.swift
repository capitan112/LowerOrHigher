//
//  Score.swift
//  HigherOrLower
//
//  Created by Oleksiy Chebotarov on 16/10/2019.
//  Copyright © 2019 Oleksiy Chebotarov. All rights reserved.
//

import Foundation

class ScoreCounter {
    fileprivate let defaultLives = 3
    fileprivate var score: Int
    fileprivate var lives: Int

    init() {
        score = 0
        lives = defaultLives
    }

    func decreaseLives() {
        lives -= 1
    }

    func increaseScore() {
        score += 1
    }

    func getScore() -> Int {
        return score
    }

    func getLives() -> Int {
        return lives
    }
}
