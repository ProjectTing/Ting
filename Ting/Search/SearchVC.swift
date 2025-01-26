//
//  SearchVC.swift
//  Ting
//
//  Created by 이재건 on 1/21/25.
//

import UIKit

/// 검색 및 카테고리 모달을 관리하는 뷰컨트롤러
final class SearchVC: UIViewController {
    
    // 검색 뷰
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
        searchView.categorySelectButton.addTarget(self, action: #selector(categorySelectButtonTapped), for: .touchUpInside)
    }     
    
    @objc private func categorySelectButtonTapped() {
        let modalVC = SearchSelectModalVC()
        if let sheet = modalVC.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        present(modalVC, animated: true)
    }
}
