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
    var viewController: DisplayLogic? { get set }
}

protocol CardsDataStore {
    
}

class Presenter: CardsPresenterProtocol, CardsDataStore {
    
    var dataFetcherService: DataFetcherProtocol?
    var viewController: DisplayLogic?
    
}
