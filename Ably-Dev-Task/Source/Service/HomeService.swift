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
    
    func bookmark(with goods: Goods) -> Single<Bool>
    
    func unbookmark(with goods: Goods) -> Single<Bool>
    
    func fetchBookmarkedGoodsList() -> Single<[Goods]>
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
    
    func bookmark(with goods: Goods) -> Single<Bool> {
        return Single.create { single in
            wishGoodsRepository.add(goods)
            single(.success(true))
            
//            do {
//                try wishGoodsRepository.save(goods)
//                single(.success(true))
//            } catch {
//                single(.failure(error))
//            }
            
            return Disposables.create()
        }
    }
    
    func unbookmark(with goods: Goods) -> Single<Bool> {
        return Single.create { single in
            wishGoodsRepository.delete(goods)
            single(.success(true))
            
            return Disposables.create()
        }
    }
    
    func fetchBookmarkedGoodsList() -> Single<[Goods]> {
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
