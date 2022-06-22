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

    var banners: [Banner] = []
    
    
    // MARK: Initializing
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAttributes()
        setupLayout()
        setupBinding()
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
        scrollView.rx.didScroll
            .map { [unowned self] in Int(round(self.scrollView.contentOffset.x / UIScreen.main.bounds.width)) + 1 }
            .filter { $0 > 0 && $0 <= self.banners.count }
            .map { "\($0)/\(self.banners.count)" }
            .bind(to: pagingLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func configure(with items: [Banner]) {
        self.banners = items
        
        for item in items {
            let imageView = UIImageView()
            imageView.loadImage(urlString: item.image)
            
            stackView.addArrangedSubview(imageView)
            imageView.snp.makeConstraints {
                $0.width.equalTo(scrollView.snp.width)
                $0.height.equalTo(scrollView.snp.height)
            }
        }
        
        pagingLabel.text = "1/\(items.count)"
    }
    
}
