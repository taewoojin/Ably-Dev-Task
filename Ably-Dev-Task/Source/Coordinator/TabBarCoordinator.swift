//
//  TabBarCoordinator.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/18.
//

import UIKit


class TabBarCoordinator: NSObject, Coordinator {
    
    // MARK: Properties
    
    var delegate: CoordinatorDidFinishDelegate?
    
    var presenter: UINavigationController
    
    var childCoordinators: [Coordinator]
    
    var tabBarController: TabBarController
    
    var tabBarItems: [TabBarItem] = TabBarItem.allCases
    
    
    // MARK: Initializing
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
        self.tabBarController = TabBarController()
    }
    
    deinit {
        debugPrint("Deinit Coordinator: \(className)")
    }
    
    func start(animated: Bool = true) {
        let viewControllers = tabBarItems.map { getTabController(item: $0) }
        tabBarController.configure(with: viewControllers)
        presenter.viewControllers = [tabBarController]
    }
    
    
    // MARK: Local Methods
    
    /// tabBarItem 설정
    func getTabController(item: TabBarItem) -> UINavigationController {
        let tabItem = UITabBarItem(
            title: item.title,
            image: item.image,
            selectedImage: item.selectedImage
        )
        tabItem.tag = item.rawValue
        tabItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let navigationController = UINavigationController()
        navigationController.navigationBar.isTranslucent = false
        navigationController.tabBarItem = tabItem
        
        let coordinator = item.getCoordinator(presenter: navigationController)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start(animated: true)
        return navigationController
    }
    
}
