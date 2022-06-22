//
//  Goods.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/18.
//

import Foundation

import RealmSwift


protocol MappableProtocol {
    associatedtype PersistenceType: Storable
    
    func mapToPersistenceObject() -> PersistenceType
    static func mapFromPersistenceObject(_ object: PersistenceType) -> Self
}


struct Goods: Codable, Hashable {
    var id: Int
    let name: String
    let image: String
    let actualPrice: Int
    let price: Int
    let isNew: Bool
    let sellCount: Int
    var isBookmark: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id, name, image, price
        case actualPrice = "actual_price"
        case isNew = "is_new"
        case sellCount = "sell_count"
    }
    
}

extension Goods: MappableProtocol {
    
    func mapToPersistenceObject() -> WishGoods {
        let model = WishGoods()
        model.id = id
        model.name = name
        model.image = image
        model.actualPrice = actualPrice
        model.price = price
        model.isNew = isNew
        model.sellCount = sellCount
        model.isBookmark = isBookmark
        return model
    }
    
    static func mapFromPersistenceObject(_ object: WishGoods) -> Goods {
        return Goods(
            id: object.id,
            name: object.name,
            image: object.image,
            actualPrice: object.actualPrice,
            price: object.price,
            isNew: object.isNew,
            sellCount: object.sellCount,
            isBookmark: object.isBookmark
        )
    }
    
}
