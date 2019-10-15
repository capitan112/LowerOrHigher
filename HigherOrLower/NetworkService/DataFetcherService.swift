//
//  DataFetcherService.swift
//  HigherOrLower
//
//  Created by Oleksiy Chebotarov on 15/10/2019.
//  Copyright © 2019 Oleksiy Chebotarov. All rights reserved.
//

import Foundation
import UIKit

protocol DataFetcherProtocol {
    func fetchCardsInfo(completion: @escaping ([Card]?) -> Void)
}

class DataFetcherService: DataFetcherProtocol {
    let cardsUrlString = "https://cards.davidneal.io/api/cards"

    var networkDataFetcher: NetworkDataFetcherProtocol

    init(networkDataFetcher: NetworkDataFetcher = NetworkDataFetcher()) {
        self.networkDataFetcher = networkDataFetcher
    }

    func fetchCardsInfo(completion: @escaping ([Card]?) -> Void) {
        networkDataFetcher.fetchGenericJSONData(urlString: cardsUrlString, response: completion)
    }
}
