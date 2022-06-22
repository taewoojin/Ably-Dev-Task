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
    
    let bookmarkButton = UIButton()
    
    
    // MARK: Properties
    
    var disposeBag = DisposeBag()
    
    weak var viewModel: HomeViewModel?
    
    var goods: Goods?
    
    
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
        
        bookmarkButton.setImage(UIImage(systemName: "heart"), for: .normal)
        bookmarkButton.tintColor = .white
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
        
        imageWrapperView.addSubview(bookmarkButton)
        bookmarkButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(10)
        }
        
    }
    
    private func setupBinding() {
        guard let viewModel = self.viewModel else { return }
        
        bookmarkButton.rx.tap
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
                    self?.bookmarkButton.setImage(UIImage(systemName: "heart"), for: .normal)
                    self?.bookmarkButton.tintColor = .white
                    return
                }
                
                self?.bookmarkButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                self?.bookmarkButton.tintColor = UIColor(named: "main")
            })
            .disposed(by: disposeBag)
    }
    
    func configure(with item: Goods, viewModel: HomeViewModel?) {
        self.goods = item
        self.viewModel = viewModel
        setupBinding()
        
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
        
        if item.isBookmark {
            bookmarkButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            bookmarkButton.tintColor = UIColor(named: "main")
        } else {
            bookmarkButton.setImage(UIImage(systemName: "heart"), for: .normal)
            bookmarkButton.tintColor = .white
        }
        
    }

}
