//
//  BannerCell.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/18.
//

import UIKit

import RxSwift
import SDWebImage


class BannerCell: UICollectionViewCell {

    // MARK: UI
    
    let scrollView = UIScrollView()
    
    let stackView = UIStackView()
    
    let pagingLabel = PaddingLabel(top: 4, right: 15, bottom: 4, left: 15)
    
    
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
        _ = stackView.arrangedSubviews.map { $0.removeFromSuperview() }
    }
    
    
    // MARK: Setup
    
    private func setupAttributes() {
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        
        pagingLabel.text = "1/3"
        pagingLabel.textColor = .white
        pagingLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        pagingLabel.layer.cornerRadius = 11
        pagingLabel.layer.masksToBounds = true
        pagingLabel.font = .preferredFont(forTextStyle: .caption1)
        
    }
    
    private func setupLayout() {
        contentView.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.addSubview(pagingLabel)
        pagingLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func setupBinding() {
        
    }
    
    func configure(with items: [Banner]) {
        for item in items {
            let imageView = UIImageView()
            
            imageView.sd_imageIndicator?.startAnimatingIndicator()
            
            // TODO: SDWebImageRetryFailed (RETRY 옵션 추가)
            imageView.sd_setImage(with: URL(string: item.image)) { image, error, type, url in
                if error != nil {
                    // TODO: 로드 실패 로직
                }
                
                imageView.sd_imageIndicator?.stopAnimatingIndicator()
            }
            
            stackView.addArrangedSubview(imageView)
            imageView.snp.makeConstraints {
                $0.width.equalTo(scrollView.snp.width)
                $0.height.equalTo(scrollView.snp.height)
            }
        }
    }
    
}
