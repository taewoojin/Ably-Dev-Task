//
//  WishListViewController.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/18.
//

import UIKit


class WishListViewController: BaseViewController {
    
    enum Section: Hashable {
        case goods
    }
    
    enum Item: Hashable {
//        case goods(Goods)
        case goods(UIColor)
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
    
    let colors: [UIColor] = [.red, .green, .blue, .black]
    
    
    // MARK: Life Cycle Views

    override func viewDidLoad() {
        super.viewDidLoad()

        configureDataSource()
        datasource?.apply(snapshot(), animatingDifferences: false)
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        navigationItem.title = "좋아요"
        
        collectionView.delegate = self
//        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.setCollectionViewLayout(createLayout(), animated: true)
        collectionView.register(GoodsCell.self, forCellWithReuseIdentifier: GoodsCell.typeName)
        
//        collectionView.register(
//            SeparatorView.self,
//            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
//            withReuseIdentifier: SeparatorView.typeName
//        )
        
    }
    
    override func setupLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    
    // MARK: Setup DataSource
    
    private func configureDataSource() {
        datasource = Datasource(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .goods(let item):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: GoodsCell.typeName,
                    for: indexPath
                ) as? GoodsCell else {
                    fatalError("Failed to load a cell")
                }
//                cell.configure(with: item)
                return cell
            }
        }
    }

    private func snapshot() -> Snapshot {
        var snapshot = Snapshot()
        
//        guard let data = viewModel.store.homeData else {
//            return snapshot
//        }

        snapshot.appendSections(sections)
        snapshot.appendItems(colors.map { Item.goods($0) }, toSection: sections[0])
        return snapshot
    }

}


// MARK: Setup UICollectionViewLayout

extension WishListViewController {
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [unowned self] index, env in
            return self.sectionFor(index: index, environment: env)
        }
        return layout
    }
    
    func sectionFor(index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let section = datasource!.snapshot().sectionIdentifiers[index]
        
        switch section {
        case .goods: return createTutorialSection()
        }
    }
    
    private func createTutorialSection() -> NSCollectionLayoutSection {
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
        section.interGroupSpacing = 15
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        return section
    }
}


// MARK: - UICollectionViewDelegate

extension WishListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
