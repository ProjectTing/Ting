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
            let fontAttributes = [NSAttributedString.Key.font: UIFont(name: "Gemini Moon", size: 12)!]
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
        let main = UINavigationController(rootViewController: MainVC()).then {
            $0.tabBarItem = UITabBarItem(
                title: "홈",
                image: UIImage(systemName: "star"),
                selectedImage: UIImage(systemName: "star.fill")
            )
        }
        
        let member = UINavigationController(rootViewController: PostListVC(type: .findMember)).then {
            $0.tabBarItem = UITabBarItem(
                title: "팀원구함",
                image: UIImage(systemName: "star"),
                selectedImage: UIImage(systemName: "star.fill")
            )
        }
        
        let project = UINavigationController(rootViewController: PostListVC(type: .findTeam)).then {
            $0.tabBarItem = UITabBarItem(
                title: "팀구함",
                image: UIImage(systemName: "star"),
                selectedImage: UIImage(systemName: "star.fill")
            )
        }
        
        let myPage = UINavigationController(rootViewController: MyPageMainVC()).then {
            $0.tabBarItem = UITabBarItem(
                title: "마이페이지",
                image: UIImage(systemName: "star"),
                selectedImage: UIImage(systemName: "star.fill")
            )
        }
        
        setViewControllers([main, member, project, myPage], animated: true)
    }
}
