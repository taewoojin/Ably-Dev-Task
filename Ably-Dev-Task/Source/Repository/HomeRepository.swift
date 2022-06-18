//
//  HomeRepository.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/18.
//


import Foundation

import Moya
import RxMoya
import RxCocoa
import RxSwift


protocol HomeRepositoryProtocol {
    
    func fetchHomeData() -> Single<HomeData>
    
    func fetchGoods(with lastId: Int) -> Single<[Goods]>
}


class HomeRepository: HomeRepositoryProtocol {
    let provider: MoyaProvider<HomeRouter>
    
    
    init(provider: MoyaProvider<HomeRouter> = MoyaProvider<HomeRouter>()) {
        self.provider = provider
    }
    
    func fetchHomeData() -> Single<HomeData> {
        return provider.rx
            .request(.fetchHomeData)
            .map(HomeData.self)
    }
    
    func fetchGoods(with lastId: Int) -> Single<[Goods]> {
        return provider.rx
            .request(.fetchGoods(lastId: lastId))
            .map([Goods].self)
    }
    
}
