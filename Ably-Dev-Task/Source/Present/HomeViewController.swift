//
//  HomeViewController.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/18.
//

import UIKit

class HomeViewController: BaseViewController {
    
    // MARK: UI
    
    let label = UILabel()
    
    
    // MARK: Properties
    
    weak var coordinator: HomeCoordinator?
    
    
    
    // MARK: Life Cycle Views

    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.title = "홈"
    }
    
    override func setupAttributes() {
        super.setupAttributes()
        
        label.text = "Home"
        label.textColor = .red
    }
    
    override func setupLayout() {
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    

}
