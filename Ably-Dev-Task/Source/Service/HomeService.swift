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
    func fetchHomeData() -> Single<Result<HomeData, Error>>
    
    func fetchGoods(with lastId: Int) -> Single<Result<[Goods], Error>>
    
    func addWishlist(with goods: Goods) -> Single<Bool>
    
    func removeWishlist(with goods: Goods) -> Single<Bool>
    
    func fetchWishlist() -> Single<[Goods]>
}


struct HomeService: HomeServiceProtocol {
    
    let repository: HomeRepositoryProtocol
    
    let wishGoodsRepository: WishGoodsRepository
    
    
    init(
        repository: HomeRepositoryProtocol = HomeRepository(),
        wishGoodsRepository: WishGoodsRepository = WishGoodsRepository(manager: RealmDataManager())
    ) {
        self.repository = repository
        self.wishGoodsRepository = wishGoodsRepository
    }
    
    func fetchHomeData() -> Single<Result<HomeData, Error>> {
        return repository.fetchHomeData()
    }
    
    func fetchGoods(with lastId: Int) -> Single<Result<[Goods], Error>> {
        return repository.fetchGoods(with: lastId)
    }
    
    func addWishlist(with goods: Goods) -> Single<Bool> {
        return Single.create { single in
            wishGoodsRepository.add(goods)
            single(.success(true))
            return Disposables.create()
        }
    }
    
    func removeWishlist(with goods: Goods) -> Single<Bool> {
        return Single.create { single in
            wishGoodsRepository.delete(goods)
            single(.success(true))
            return Disposables.create()
        }
    }
    
    func fetchWishlist() -> Single<[Goods]> {
        return Single.create { single in
            wishGoodsRepository.fetch(
                WishGoods.self,
                predicate: nil,
                sorted: Sorted(key: "id", ascending: true)
            ) { wishGoods in
                let goods = wishGoods.map { Goods.mapFromPersistenceObject($0) }
                single(.success(goods))
            }
            
            return Disposables.create()
        }
    }
    
}
