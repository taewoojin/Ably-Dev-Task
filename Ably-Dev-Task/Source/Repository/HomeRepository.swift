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
//            .do(onSuccess: { response in
//                print("fetchGood=====", String(data: response.data, encoding: .utf8))
//            })
            .flatMap { response in
                
                guard let jsonObject = try? JSONSerialization.jsonObject(with: response.data, options: []) as? [String:Any] else {
                    throw MoyaError.jsonMapping(response)
                }
                
                let object = jsonObject["goods"]
                guard let goodsData = try? JSONSerialization.data(withJSONObject: object) else {
                    throw MoyaError.jsonMapping(response)
                }
                
                guard let goods = try? JSONDecoder().decode([Goods].self, from: goodsData) else {
                    throw MoyaError.jsonMapping(response)
                }
                
                return .just(goods)
            }
//            .map([Goods].self)
    }
    
}
