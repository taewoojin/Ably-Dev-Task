//
//  WishListCoordinator.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/18.
//

import UIKit


class WishListCoordinator: Coordinator {
    
    // MARK: Properties
    
    var delegate: CoordinatorDidFinishDelegate?
    
    var presenter: UINavigationController
    
    var childCoordinators: [Coordinator]
    
    
    // MARK: Initializing
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }
    
    func start(animated: Bool = true) {
        let viewController = WishListViewController().then {
            $0.coordinator = self
            $0.coordinatorDelegate = self
        }
        presenter.pushViewController(viewController, animated: animated)
    }
    
}
