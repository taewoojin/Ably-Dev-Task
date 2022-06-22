//
//  TabBarController.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/18.
//

import UIKit

import RxSwift


enum TabBarItem: Int, CaseIterable {
    case home
    case wishList
    
    var title: String {
        switch self {
        case .home: return "홈"
        case .wishList: return "좋아요"
        }
    }
    
    var image: UIImage {
        switch self {
        case .home: return UIImage(systemName: "house")!
        case .wishList: return UIImage(systemName: "heart")!
        }
    }
    
    var selectedImage: UIImage {
        switch self {
        case .home: return UIImage(systemName: "house.fill")!
        case .wishList: return UIImage(systemName: "heart.fill")!
        }
    }
    
    func getCoordinator(presenter: UINavigationController) -> Coordinator {
        switch self {
        case .home: return HomeCoordinator(presenter: presenter)
        case .wishList: return WishListCoordinator(presenter: presenter)
        }
    }
    
}


class TabBarController: UITabBarController {

    // MARK: Properties
    
    var disposeBag = DisposeBag()
    
    var feedbackGenerator: UIImpactFeedbackGenerator?
    
    var tabBarItems: [TabBarItem] = TabBarItem.allCases
    
    
    // MARK: Life Cycle Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator?.prepare()
    }
    
    /// tabBarController 설정
    func configure(with tabControllers: [UINavigationController]) {
        delegate = self
        setViewControllers(tabControllers, animated: true)
        selectedIndex = 0
        tabBar.backgroundColor = UIColor(named: "tabView")
        tabBar.tintColor = UIColor(named: "tabItem")
    }
    
}


// MARK: - UITabBarControllerDelegate

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(
        _ tabBarController: UITabBarController,
        didSelect viewController: UIViewController
    ) {
        feedbackGenerator?.impactOccurred()
    }
}
