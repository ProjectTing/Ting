//
//  TabBar.swift
//  Ting
//
//  Created by 이재건 on 1/24/25.
//

import UIKit

import SnapKit
import Then


class TabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewControllers()
    }
    
    // MARK: - TabBar 설정
    private func setupTabBar() {
        let appearance = UITabBarAppearance().then {
            $0.configureWithOpaqueBackground()
            $0.backgroundColor = UIColor(hexCode: "FFF7ED")
        }
        
        tabBar.do {
            $0.standardAppearance = appearance
            $0.tintColor = UIColor(hexCode: "C2410C")
            $0.backgroundColor = UIColor(hexCode: "FFF7ED")
        }
    }
    
    // MARK: - ViewControllers 설정
    private func setupViewControllers() {
        let firstVC = UINavigationController(rootViewController: MainVC()).then {
            $0.tabBarItem = UITabBarItem(
                title: "홈",
                image: UIImage(systemName: "star"),
                selectedImage: UIImage(systemName: "star.fill")
            )
        }
        
        let secondVC = UINavigationController(rootViewController: SearchVC()).then {
            $0.tabBarItem = UITabBarItem(
                title: "구인페이지",
                image: UIImage(systemName: "star"),
                selectedImage: UIImage(systemName: "star.fill")
            )
        }
        
        let thirdVC = UINavigationController(rootViewController: MainVC()).then {
            $0.tabBarItem = UITabBarItem(
                title: "구직페이지",
                image: UIImage(systemName: "star"),
                selectedImage: UIImage(systemName: "star.fill")
            )
        }
        
        let fourthVC = UINavigationController(rootViewController: SearchVC()).then {
            $0.tabBarItem = UITabBarItem(
                title: "마이페이지",
                image: UIImage(systemName: "star"),
                selectedImage: UIImage(systemName: "star.fill")
            )
        }
        
        setViewControllers([firstVC, secondVC, thirdVC, fourthVC], animated: true)
    }
}
