//
//  BaseViewController.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/18.
//

import UIKit

import RxSwift


class BaseViewController: UIViewController {
    
    // MARK: Properties
    
    lazy private(set) var className: String = {
        return type(of: self).description().components(separatedBy: ".").last ?? ""
    }()
    
    weak var coordinatorDelegate: CoordinatorDidFinishDelegate?
    
    var disposeBag = DisposeBag()
    
    
    // MARK: Layout Constraints
    
    private(set) var didSetupConstraints = false
    
    
    // MARK: Initializing
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupLifeCycleBinding()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupLifeCycleBinding()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLifeCycleBinding()
    }
    
    deinit {
        coordinatorDelegate?.didFinishCoordinator()
        debugPrint("DEINIT: \(self.className)")
    }
    
    
    // MARK: Life Cycle Views
    
    override func viewDidLoad() {
        setupAttributes()
        setupLayout()
        setupLocalization()
        setupBinding()
        setData()
        self.view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if !self.didSetupConstraints {
            self.setupConstraints()
            self.didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    
    // MARK: Setup
    
    func setupLayout() {
        // Override Layout
    }
    
    func setupConstraints() {
        // Override Constraints
    }
    
    func setupAttributes() {
        // Override Attributes
    }
    
    func setupLocalization() {
        // Override Localization
    }
    
    func setupLifeCycleBinding() {
        // Override Binding for Lify Cycle Views
    }
    
    func setupBinding() {
        // Override Binding
    }
    
    func setData() {
        // Override Set Data
    }
    
    
    // MARK: Local Methods
    
}

