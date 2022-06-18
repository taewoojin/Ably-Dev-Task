//
//  HomeData.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/18.
//


struct HomeData: Codable, Hashable {
    let banners: [Banner]
    let goods: [Goods]
}
