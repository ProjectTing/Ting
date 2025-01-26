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
        /// TODO - 셀 : 메인뷰 셀 등록하기,
        /// 셀 클릭 시 화면이동 -> 게시글 상세화면
        /// 글쓰기 버튼 -> 게시글 작성뷰
        /// 구인/구직 두개로 나눠야함, 파일명
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
