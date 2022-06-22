//
//  HomeRepository.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/18.
//


import Foundation

import Moya
import RxCocoa
import RxMoya
import RxSwift


protocol HomeRepositoryProtocol {
    func fetchHomeData() -> Single<Result<HomeData, Error>>
    
    func fetchGoods(with lastId: Int) -> Single<Result<[Goods], Error>>
}


class HomeRepository: HomeRepositoryProtocol {
    
    let provider: MoyaProvider<HomeRouter>
    
    
    init(provider: MoyaProvider<HomeRouter> = MoyaProvider<HomeRouter>()) {
        self.provider = provider
    }
    
    func fetchHomeData() -> Single<Result<HomeData, Error>> {
        return provider.rx
            .request(.fetchHomeData)
            .asResult(HomeData.self)
    }
    
    func fetchGoods(with lastId: Int) -> Single<Result<[Goods], Error>> {
        return provider.rx
            .request(.fetchGoods(lastId: lastId))
            .asResult([Goods].self, key: "goods")
    }
    
}
