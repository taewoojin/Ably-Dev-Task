//
//  WishlistService.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/22.
//

import Foundation

import Moya
import RxMoya
import RxCocoa
import RxSwift


protocol WishlistServiceProtocol {
    func fetchWishlist() -> Single<[Goods]>
}


struct WishlistService: WishlistServiceProtocol {
    
    let repository: WishGoodsRepository
    
    
    init(repository: WishGoodsRepository = WishGoodsRepository(manager: RealmDataManager())) {
        self.repository = repository
    }
    
    func fetchWishlist() -> Single<[Goods]> {
        return Single.create { single in
            repository.fetch(
                WishGoods.self,
                predicate: nil,
                sorted: nil
            ) { wishGoods in
                let goods = wishGoods.map { Goods.mapFromPersistenceObject($0) }
                single(.success(goods))
            }
            
            return Disposables.create()
        }
    }
    
}
