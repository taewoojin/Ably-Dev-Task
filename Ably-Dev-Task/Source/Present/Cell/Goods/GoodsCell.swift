//
//  GoodsCell.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/18.
//

import UIKit

import RxSwift


class GoodsCell: BaseGoodsCell {
    
    // MARK: Properties
    
    weak var viewModel: HomeViewModel?
    
    var goods: Goods?
    
    
    // MARK: Setup
    
    private func setupBinding() {
        guard let viewModel = self.viewModel else { return }
        
        wishButton.rx.tap
            .map { [weak self] in self?.goods }
            .filterNil()
            .map { $0.isBookmark ? .unbookmark($0) : .bookmark($0) }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
        
        viewModel.currentStore
            .map { $0.bookmarkedGoodsList }
            .distinctUntilChanged()
            .map { [unowned self] in $0.filter({ $0.id == self.goods!.id }).first }
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] goods in
                guard let _ = goods else {
                    self?.wishButton.setImage(UIImage(systemName: "heart"), for: .normal)
                    self?.wishButton.tintColor = .white
                    return
                }
                
                self?.wishButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                self?.wishButton.tintColor = UIColor(named: "main")
            })
            .disposed(by: disposeBag)
    }
    
    func configure(with item: Goods, viewModel: HomeViewModel?) {
        self.goods = item
        self.viewModel = viewModel
        setupBinding()
        
        let discountRate = CGFloat.discountRate(actualPrice: item.actualPrice, price: item.price)
        discountRateLabel.isHidden = discountRate <= 0
        discountRateLabel.text = "\(discountRate)%"
        
        priceLabel.text = "\(item.price.withCommas())원"
        nameLabel.text = item.name
        
        imageView.loadImage(urlString: item.image)
        
        newBadgeLabel.isHidden = !item.isNew
        
        buyingCountLabel.isHidden = item.sellCount < 10
        buyingCountLabel.text = "\(item.sellCount.withCommas())개 구매중"
        
        if item.isBookmark {
            wishButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            wishButton.tintColor = UIColor(named: "main")
        } else {
            wishButton.setImage(UIImage(systemName: "heart"), for: .normal)
            wishButton.tintColor = .white
        }
        
    }

}
