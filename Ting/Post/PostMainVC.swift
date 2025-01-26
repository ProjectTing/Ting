//
//  PostMainVC.swift
//  Ting
//
//  Created by 이재건 on 1/21/25.
//

import UIKit
import SnapKit

final class PostMainVC: UIViewController {
    
    private let postMainView = PostMainView()
    
    override func loadView() {
        self.view = postMainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNaviBar()
    }
    
    // 네비바 생성
    private func setUpNaviBar() {
        title = "ㅇㅇ게시판"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = nil
        
        navigationController?.navigationBar.tintColor = .brownText
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "글쓰기")
    }
    
}
