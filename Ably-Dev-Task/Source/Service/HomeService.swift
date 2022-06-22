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
    
    let wishRepository: WishRepository
    
    
    init(
        repository: HomeRepositoryProtocol = HomeRepository(),
        wishRepository: WishRepository = WishRepository(manager: RealmDataManager())
    ) {
        self.repository = repository
        self.wishRepository = wishRepository
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
            wishRepository.save(goods)
            single(.success(true))
            
//            do {
//                try wishRepository.save(goods)
//                single(.success(true))
//            } catch {
//                single(.failure(error))
//            }
            
            return Disposables.create()
        }
    }
    
    func unbookmark(with goods: Goods) -> Single<Bool> {
        return Single.create { single in
            wishRepository.delete(goods)
            single(.success(true))
            
            return Disposables.create()
        }
    }
    
    func fetchBookmarkedGoodsList() -> Single<[Goods]> {
        return Single.create { single in
//            let wishGoods = wishRepository.fetchValue(WishGoods.self, predicate: nil, sorted: nil)
            wishRepository.fetch(WishGoods.self, predicate: nil, sorted: nil) { wishGoods in
                let goods = wishGoods.map { Goods.mapFromPersistenceObject($0) }
                single(.success(goods))
            }
            
            return Disposables.create()
        }
    }
    
}
