//
//  HomeService.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/18.
//

import Foundation

import Moya
import RxMoya
import RxCocoa
import RxSwift


protocol HomeServiceProtocol {
    
    func fetchHomeData() -> Single<HomeData?>
    
    func fetchGoods(with lastId: Int) -> Single<[Goods]>
}


struct HomeService: HomeServiceProtocol {
    
    let repository: HomeRepositoryProtocol
    
    
    init(repository: HomeRepositoryProtocol = HomeRepository()) {
        self.repository = repository
    }
    
    func fetchHomeData() -> Single<HomeData?> {
        return repository
            .fetchHomeData()
            .map { $0 }
            .catchAndReturn(nil)
    }
    
    func fetchGoods(with lastId: Int) -> Single<[Goods]> {
        return repository
            .fetchGoods(with: lastId)
            .map { $0 }
            .catchAndReturn([])
    }
    
}
