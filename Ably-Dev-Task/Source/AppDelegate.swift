//
//  AppDelegate.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/18.
//

import UIKit

import SDWebImage
import SnapKit
import Then


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Properties
    
    var window: UIWindow?
    
    let rootView: UINavigationController = UINavigationController().then {
        $0.setNavigationBarHidden(true, animated: false)
    }
    
    lazy var tabBarCoordinator = TabBarCoordinator(presenter: rootView)
    
    lazy var homeCoordinator = HomeCoordinator(presenter: rootView)
    

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = rootView
        self.window?.makeKeyAndVisible()
        
        tabBarCoordinator.start()
        applyAppearance()
        
        // TODO: SDWebImageManager 설정
        SDWebImageDownloader.shared.config.downloadTimeout = 60
        
        return true
    }
    
    private func applyAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .systemGray6
        
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
    }

}

