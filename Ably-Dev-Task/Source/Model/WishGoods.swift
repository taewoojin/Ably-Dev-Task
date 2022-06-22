//
//  WishGoods.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/21.
//

import Foundation

import RealmSwift


class WishGoods: Object, Codable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var image: String
    @Persisted var actualPrice: Int
    @Persisted var price: Int
    @Persisted var isNew: Bool
    @Persisted var sellCount: Int
    @Persisted var isBookmark: Bool
}
