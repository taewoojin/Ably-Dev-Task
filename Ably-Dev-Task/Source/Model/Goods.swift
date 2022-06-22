//
//  Goods.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/18.
//

import Foundation


struct Goods: Codable, Hashable {
    var id: Int
    let name: String
    let image: String
    let actualPrice: Int
    let price: Int
    let isNew: Bool
    let sellCount: Int
    var isWish: Bool = false
    
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
        model.isWish = isWish
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
            isWish: object.isWish
        )
    }
    
}
