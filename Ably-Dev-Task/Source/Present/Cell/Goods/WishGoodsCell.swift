//
//  WishGoodsCell.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/22.
//

import Foundation
import UIKit


class WishGoodsCell: BaseGoodsCell {
    
    // MARK: Setup
    
    override func setupAttributes() {
        super.setupAttributes()
        wishButton.isHidden = true
    }
    
    func configure(with item: Goods) {
        let discountRate = CGFloat.discountRate(actualPrice: item.actualPrice, price: item.price)
        discountRateLabel.isHidden = discountRate <= 0
        discountRateLabel.text = "\(discountRate)%"
        
        priceLabel.text = "\(item.price.withCommas())원"
        nameLabel.text = item.name
        
        imageView.loadImage(urlString: item.image)
        
        newBadgeLabel.isHidden = !item.isNew
        
        buyingCountLabel.isHidden = item.sellCount < 10
        buyingCountLabel.text = "\(item.sellCount.withCommas())개 구매중"
    }
}
