//
//  WishRepository.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/21.
//

import Foundation


protocol WishRepositoryProtocol {
    func getItems(predicate: NSPredicate?, sort: Sorted?, completion: (([Goods]) -> Void))
    func getItems(predicate: NSPredicate?, sort: Sorted?) -> [Goods]
    func save(_ goods: Goods)
    func delete(_ goods: Goods)
}

class WishRepository: BaseRepository<Goods> {}

extension WishRepository: WishRepositoryProtocol {
    
    func getItems(predicate: NSPredicate? = nil, sort: Sorted? = nil, completion: (([Goods]) -> Void)) {
        super.fetch(WishGoods.self, predicate: predicate, sorted: sort) { goods in
            completion(goods.map { Goods.mapFromPersistenceObject($0) })
        }
    }
    
    func getItems(predicate: NSPredicate? = nil, sort: Sorted? = nil) -> [Goods] {
        let items = super.fetchValue(WishGoods.self, predicate: predicate, sorted: sort)
        return items.map { Goods.mapFromPersistenceObject($0) }
    }
    
    func save(_ goods: Goods) {
        do {
            try super.save(object: goods.mapToPersistenceObject())
        } catch {
            print("error in method(saveClothes):  \(error.localizedDescription)")
        }
    }
    
    func delete(_ goods: Goods) {
        do {
            try super.delete(
                WishGoods.self,
                object: goods.mapToPersistenceObject(),
                predicate: NSPredicate(format: "id = %d", goods.id)
            )
            
        } catch {
            print("error in method(saveClothes):  \(error.localizedDescription)")
        }
    }
    
}
