//
//  SearchVC.swift
//  Ting
//
//  Created by 이재건 on 1/21/25.
//

import UIKit

/// 검색 및 필터 화면을 관리하는 뷰컨트롤러
class SearchVC: UIViewController {
    
    private let searchView = SearchView()
    
    // MARK: - View Lifecycle
    override func loadView() {
        self.view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }
    
    // MARK: - 버튼 액션 설정
    private func setupActions() {
        searchView.applyFilterButton.addTarget(self, action: #selector(applyFilterTapped), for: .touchUpInside)
    }
    
    @objc private func applyFilterTapped() {
        print("필터 적용 버튼 클릭됨")
        // 필터 적용 기능 추가 가능
    }
}
