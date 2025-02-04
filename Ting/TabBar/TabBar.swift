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
            $0.backgroundColor = .background
        }
        
        tabBar.do {
            $0.standardAppearance = appearance
            $0.tintColor = .primary
            $0.backgroundColor = .background
        }
    }
    
    // MARK: - ViewControllers 설정
    private func setupViewControllers() {
        let main = UINavigationController(rootViewController: AddInfoVC()).then {
            $0.tabBarItem = UITabBarItem(
                title: "홈",
                image: UIImage(systemName: "house"),
                selectedImage: UIImage(systemName: "house.fill")
            )
        }
        
        let member = UINavigationController(rootViewController: PostListVC(type: .recruitMember)).then {
            $0.tabBarItem = UITabBarItem(
                title: "팀원 모집",
                image: UIImage(systemName: "person.2.badge.plus"),
                selectedImage: UIImage(systemName: "person.2.badge.plus.fill")
            )
        }
        
        let project = UINavigationController(rootViewController: PostListVC(type: .joinTeam)).then {
            $0.tabBarItem = UITabBarItem(
                title: "팀 합류",
                image: UIImage(systemName: "paperplane"),
                selectedImage: UIImage(systemName: "paperplane.fill")
            )
        }
        
        let myPage = UINavigationController(rootViewController: MyPageMainVC()).then {
            $0.tabBarItem = UITabBarItem(
                title: "마이페이지",
                image: UIImage(systemName: "person.crop.square"),
                selectedImage: UIImage(systemName: "person.crop.square.fill")
            )
        }
        
        setViewControllers([main, member, project, myPage], animated: true)
    }
}
