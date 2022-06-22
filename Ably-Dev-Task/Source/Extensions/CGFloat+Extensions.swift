//
//  CGFloat+Extensions.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/22.
//

import Foundation
import UIKit


extension CGFloat {
    
    static func discountRate(actualPrice: Int, price: Int) -> Int {
        let discountRate = (CGFloat(actualPrice - price) / CGFloat(actualPrice)) * 100
        return Int(discountRate.rounded())
    }
}
