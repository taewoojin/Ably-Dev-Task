//
//  HomeViewController.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/18.
//

import UIKit

import RxSwift
import RxOptional


class HomeViewController: BaseViewController {
    
    enum Section: Hashable {
        case banner
        case goods
    }
    
    enum Item: Hashable {
        case banner([Banner])
        case goods(Goods)
    }
    
    typealias Datasource = UICollectionViewDiffableDataSource<Section, Item>
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    
    // MARK: UI
    
    let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    )
    
    var refreshControl = UIRefreshControl().then {
        $0.tintColor = .systemGray2
        $0.backgroundColor = .white
    }
    
    
    // MARK: Properties
    
    weak var coordinator: HomeCoordinator?
    
    let viewModel: HomeViewModel
    
    var datasource: Datasource?
    
    let sections: [Section] = [.banner, .goods]
    

    // MARK: Initializing
    
    init(viewModel: HomeViewModel = HomeViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Life Cycle Views

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
    }
    
    
    // MARK: Setup
    
    override func setupAttributes() {
        super.setupAttributes()
        
        navigationItem.title = "홈"
        
        collectionView.refreshControl = refreshControl
        collectionView.setCollectionViewLayout(createLayout(), animated: true)
        collectionView.register(GoodsCell.self, forCellWithReuseIdentifier: GoodsCell.typeName)
        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.typeName)
        
    }
    
    override func setupLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setupLifeCycleBinding() {
        rx.viewDidLoad
            .flatMap {
                Observable.concat(
                    .just(.fetchBookmarkedGoodsList),
                    .just(.fetchHomeData)
                )
            }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
    }
    
    override func setupBinding() {
        collectionView.rx.didEndDecelerating
            .filter { [weak self] _ in self?.viewModel.store.isRefresh ?? false }
            .map { .fetchHomeData }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
        
        collectionView.rx.willDisplayCell
            .filter { [unowned self] cell, indexPath in
                guard let goodsCount = self.viewModel.store.homeData?.goods.count else {
                    return false
                }
                return goodsCount - 2 == indexPath.item
            }
            .map { (_, _) in .fetchGoods }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .map { .refresh }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
        
        viewModel.currentStore
            .map { $0.homeData }
            .distinctUntilChanged()
            .filterNil()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                guard let `self` = self else { return }
                self.datasource?.apply(self.snapshot(with: data), animatingDifferences: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.currentStore
            .map { $0.isRefresh }
            .distinctUntilChanged()
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
    
    
    // MARK: Setup DataSource
    
    private func configureDataSource() {
        datasource = Datasource(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            switch item {
            case .banner(let items):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: BannerCell.typeName,
                    for: indexPath
                ) as? BannerCell else {
                    fatalError("Failed to load a cell")
                }
                cell.configure(with: items)
                return cell
                
            case .goods(let item):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: GoodsCell.typeName,
                    for: indexPath
                ) as? GoodsCell else {
                    fatalError("Failed to load a cell")
                }
                cell.configure(with: item, viewModel: self?.viewModel)
                return cell
                
            }
        }
    }

    private func snapshot(with homeData: HomeData) -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        snapshot.appendItems([Item.banner(homeData.banners)], toSection: sections[0])
        snapshot.appendItems(homeData.goods.map { Item.goods($0) }, toSection: sections[1])
        return snapshot
    }

}


// MARK: Setup UICollectionViewLayout

extension HomeViewController {
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = SeparatorCollectionFlowLayout { [unowned self] index, env in
            return self.sectionFor(index: index, environment: env)
        }
        return layout
    }
    
    func sectionFor(index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let section = datasource!.snapshot().sectionIdentifiers[index]
        
        switch section {
        case .banner: return createBannerSection()
        case .goods: return createGoodsSection()
        }
    }
    
    private func createBannerSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(300)
            ),
            subitem: item,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
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
