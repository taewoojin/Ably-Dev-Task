//
//  Goods.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/18.
//


struct Goods: Codable, Hashable {
    let id: Int
    let name: String
    let image: String
    let actualPrice: Int
    let price: Int
    let isNew: Bool
    let sellCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, image, price
        case actualPrice = "actual_price"
        case isNew = "is_new"
        case sellCount = "sell_count"
    }
}
