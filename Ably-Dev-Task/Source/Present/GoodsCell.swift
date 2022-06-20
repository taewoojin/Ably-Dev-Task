//
//  GoodsCell.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/18.
//

import UIKit

import RxSwift
import SDWebImage


class GoodsCell: UICollectionViewCell {

    // MARK: UI
    
    lazy var containerStackView = UIStackView(arrangedSubviews: [imageView, contentStackView])
    
    lazy var contentStackView = UIStackView(arrangedSubviews: [priceStcakView, nameLabel, optionStackView])
    
    lazy var priceStcakView = UIStackView(arrangedSubviews: [discountRateLabel, priceLabel])
    
    lazy var optionStackView = UIStackView(arrangedSubviews: [newBadgeLabel, buyingCountLabel])
    
    let imageView = UIImageView()
    
    let discountRateLabel = UILabel()
    
    let priceLabel = UILabel()
    
    let nameLabel = UILabel()
    
    let newBadgeLabel = PaddingLabel(top: 2, right: 3, bottom: 2, left: 3)
    
    let buyingCountLabel = UILabel()
    
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
        
        separatorView.backgroundColor = .systemGray4
    }
    
    func setupLayout() {
        contentView.addSubview(containerStackView)
        containerStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(100)
        }
    }
    
    func configure(with item: Goods) {
        let discountRate = CGFloat(item.actualPrice - item.price) / CGFloat(item.actualPrice) * 100
        let roundedDiscountRate = Int(round(discountRate))
        discountRateLabel.isHidden = roundedDiscountRate <= 0
        discountRateLabel.text = "\(roundedDiscountRate)%"
        
        priceLabel.text = "\(item.price.withCommas())원"
        nameLabel.text = item.name
        
        imageView.sd_imageIndicator?.startAnimatingIndicator()
        
        // TODO: SDWebImageRetryFailed (RETRY 옵션 추가)
        imageView.sd_setImage(with: URL(string: item.image)) { [weak self] image, error, type, url in
            if error != nil {
                // TODO: 로드 실패 로직
            }
            
            self?.imageView.sd_imageIndicator?.stopAnimatingIndicator()
        }
        
        newBadgeLabel.isHidden = !item.isNew
        
        buyingCountLabel.isHidden = item.sellCount < 10
        buyingCountLabel.text = "\(item.sellCount.withCommas())개 구매중"
    }

}
