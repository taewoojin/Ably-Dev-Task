//
//  WishListViewController.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/18.
//

import UIKit
import RxSwift


class WishListViewController: BaseViewController {
    
    enum Section: Hashable {
        case goods
    }
    
    enum Item: Hashable {
        case goods(Goods)
    }
    
    typealias Datasource = UICollectionViewDiffableDataSource<Section, Item>
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    
    // MARK: UI
    
    let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    )
    
    
    // MARK: Properties
    
    weak var coordinator: WishListCoordinator?
    
    var datasource: Datasource?
    
    let sections: [Section] = [.goods]
    
    let viewModel: WishlistViewModel
    
    
    // MARK: Initializing
    
    init(viewModel: WishlistViewModel = WishlistViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Setup
    
    override func setupAttributes() {
        super.setupAttributes()
        
        navigationItem.title = "좋아요"
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.setCollectionViewLayout(createLayout(), animated: true)
        collectionView.register(WishGoodsCell.self, forCellWithReuseIdentifier: WishGoodsCell.typeName)
    }
    
    override func setupLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setupLifeCycleBinding() {
        rx.viewWillAppear
            .map { _ in .fetchWishlist }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
        
        rx.viewDidLoad
            .subscribe(onNext: { [weak self] in
                self?.configureDataSource()
            })
            .disposed(by: disposeBag)
    }
    
    override func setupBinding() {
        viewModel.currentStore
            .map { $0.wishlist }
            .distinctUntilChanged()
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] list in
                guard let `self` = self else { return }
                self.datasource?.apply(self.snapshot(goodsList: list), animatingDifferences: false)
            })
            .disposed(by: disposeBag)
    }
    
    
    // MARK: Setup DataSource
    
    private func configureDataSource() {
        datasource = Datasource(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .goods(let item):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: WishGoodsCell.typeName,
                    for: indexPath
                ) as? WishGoodsCell else {
                    fatalError("Failed to load a cell")
                }
                
                cell.configure(with: item)
                return cell
            }
        }
    }

    private func snapshot(goodsList: [Goods]) -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        snapshot.appendItems(goodsList.map { Item.goods($0) }, toSection: sections[0])
        return snapshot
    }

}


// MARK: - Setup UICollectionViewCompositionalLayout

extension WishListViewController {
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = SeparatorCollectionFlowLayout { [unowned self] index, env in
            guard let datasource = self.datasource else {
                fatalError("datasource value is nil")
            }
            
            let section = datasource.snapshot().sectionIdentifiers[index]
            switch section {
            case .goods: return createGoodsSection()
            }
        }
        return layout
    }
    
    private func createGoodsSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(150)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(150)
            ),
            subitem: item,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0)
        
        return section
    }
}
