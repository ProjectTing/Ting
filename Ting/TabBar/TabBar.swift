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
        self.delegate = self
    }
    
    // MARK: - TabBar 설정
    private func setupTabBar() {
        let appearance = UITabBarAppearance().then {
            $0.configureWithOpaqueBackground()
            $0.backgroundColor = .background
        }
        
        tabBar.do {
            $0.standardAppearance = appearance
            $0.tintColor = .primaries
            $0.backgroundColor = .background
        }
    }
    
    // MARK: - ViewControllers 설정
    private func setupViewControllers() {
        let main = UINavigationController(rootViewController: MainVC()).then {
            $0.tabBarItem = UITabBarItem(
                title: "홈",
                image: UIImage(systemName: "house"),
                selectedImage: UIImage(systemName: "house.fill")
            )
        }
        
        let member = UINavigationController(rootViewController: PostListVC(type: .recruitMember)).then {
            $0.tabBarItem = UITabBarItem(
                title: "팀원 모집",
                image: UIImage(systemName: "person.badge.plus"),
                selectedImage: UIImage(systemName: "person.badge.plus.fill")
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

extension TabBar: UITabBarControllerDelegate {
    /// 탭바 선택시 메서드
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        /// 마이페이지일 경우 회원인지 체크
        if let nav = viewController as? UINavigationController,
           nav.viewControllers.first is MyPageMainVC {
            guard self.loginCheck() else {
                return false
            }
        }
        return true
    }
}
