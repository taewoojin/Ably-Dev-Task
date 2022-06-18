//
//  GoodsCell.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/18.
//

import UIKit

import RxSwift


class GoodsCell: UICollectionViewCell {

    // MARK: UI
    
//    let containerView = UIView()
    
    lazy var containerStackView = UIStackView(arrangedSubviews: [imageView, contentStackView])
    
    let imageView = UIImageView()
    
    lazy var contentStackView = UIStackView(arrangedSubviews: [priceStcakView, nameLabel])
    
    lazy var priceStcakView = UIStackView(arrangedSubviews: [discountRateLabel, priceLabel])
    
    let discountRateLabel = UILabel()
    
    let priceLabel = UILabel()
    
    let nameLabel = UILabel()
    
    let separatorView = UIView()
    
    
    // MARK: Properties
    
    var disposeBag = DisposeBag()
    
    
    // MARK: Initializing
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAttributes()
        setupLayout()   
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Setup
    
    private func setupAttributes() {
        containerStackView.axis = .horizontal
        containerStackView.spacing = 10
        containerStackView.alignment = .top
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.backgroundColor = .systemGray2
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 10
        contentStackView.alignment = .leading
        
        priceStcakView.axis = .horizontal
        priceStcakView.spacing = 4
        priceStcakView.alignment = .center
        
        discountRateLabel.font = .preferredFont(forTextStyle: .title2)
        discountRateLabel.textColor = UIColor(named: "main")
        discountRateLabel.text = "10%"
        
        priceLabel.font = .preferredFont(forTextStyle: .title3)
        priceLabel.textColor = UIColor(named: "text_primary")
        priceLabel.text = "8,200"
        
        nameLabel.font = .preferredFont(forTextStyle: .body)
        nameLabel.textColor = UIColor(named: "text_secondary")
        nameLabel.text = "회색 가디건"
        
        separatorView.backgroundColor = .systemGray4
    }
    
    func setupLayout() {
        contentView.addSubview(containerStackView)
        containerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
//            $0.top.leading.trailing.equalToSuperview()
        }
        
//        contentView.addSubview(separatorView)
//        separatorView.snp.makeConstraints {
//            $0.top.equalTo(containerStackView.snp.bottom)
//            $0.leading.trailing.bottom.equalToSuperview()
//            $0.height.equalTo(2)
//        }
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(100)
        }
        
        
//        containerStackView.setCustomSpacing(<#T##spacing: CGFloat##CGFloat#>, after: <#T##UIView#>)
        
    }
    
    func configure(with item: Goods) {
        
    }

}
