//
//  BaseGoodsCell.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/22.
//

import UIKit

import RxSwift


class BaseGoodsCell: UICollectionViewCell {

    // MARK: UI
    
    lazy var containerStackView = UIStackView(arrangedSubviews: [imageWrapperView, contentStackView])
    
    lazy var contentStackView = UIStackView(arrangedSubviews: [priceStcakView, nameLabel, optionStackView])
    
    lazy var priceStcakView = UIStackView(arrangedSubviews: [discountRateLabel, priceLabel])
    
    lazy var optionStackView = UIStackView(arrangedSubviews: [newBadgeLabel, buyingCountLabel])
    
    let imageWrapperView = UIView()
    
    let imageView = UIImageView()
    
    let discountRateLabel = UILabel()
    
    let priceLabel = UILabel()
    
    let nameLabel = UILabel()
    
    let newBadgeLabel = PaddingLabel(top: 2, right: 3, bottom: 2, left: 3)
    
    let buyingCountLabel = UILabel()
    
    let wishButton = UIButton()
    
    
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
    
    
    // MARK: Life Cycle Views
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    
    // MARK: Setup
    
    func setupAttributes() {
        containerStackView.axis = .horizontal
        containerStackView.spacing = 10
        containerStackView.alignment = .top
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.backgroundColor = .systemGray2
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 5
        contentStackView.alignment = .leading
        contentStackView.setCustomSpacing(15, after: nameLabel)
        
        priceStcakView.spacing = 4
        priceStcakView.alignment = .center
        
        optionStackView.alignment = .center
        optionStackView.spacing = 4
        
        discountRateLabel.font = .preferredFont(forTextStyle: .headline)
        discountRateLabel.textColor = UIColor(named: "main")
        
        priceLabel.font = .preferredFont(forTextStyle: .headline)
        priceLabel.textColor = UIColor(named: "text_primary")
        
        nameLabel.font = .preferredFont(forTextStyle: .subheadline)
        nameLabel.textColor = UIColor(named: "text_secondary")
        nameLabel.numberOfLines = 0
        
        newBadgeLabel.text = "NEW"
        newBadgeLabel.font = .preferredFont(forTextStyle: .caption2)
        newBadgeLabel.layer.borderColor = UIColor.black.cgColor
        newBadgeLabel.layer.borderWidth = 1
        newBadgeLabel.layer.cornerRadius = 2
        newBadgeLabel.layer.masksToBounds = true
        
        buyingCountLabel.font = .preferredFont(forTextStyle: .caption1)
        buyingCountLabel.textColor = UIColor(named: "text_secondary")
        
        wishButton.setImage(UIImage(systemName: "heart"), for: .normal)
        wishButton.tintColor = .white
    }
    
    private func setupLayout() {
        contentView.addSubview(containerStackView)
        containerStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        imageWrapperView.snp.makeConstraints {
            $0.width.height.equalTo(100)
        }
        
        imageWrapperView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageWrapperView.addSubview(wishButton)
        wishButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(10)
        }
        
    }

}
