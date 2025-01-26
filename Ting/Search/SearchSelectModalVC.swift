//
//  SearchSelectModalVC.swift
//  Ting
//
//  Created by t2023-m0033 on 1/26/25.
//

import UIKit

final class SearchSelectModalVC: UIViewController {
    
    // 카테고리 선택 모달
    private let modalView = SearchSelectModal()
    
    override func loadView() {
        view = modalView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }
    
    private func setupActions() {
        // 카테고리 버튼 액션 설정
        modalView.categoryButtons.forEach { button in
            button.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        }
        
        // 필터 적용 버튼 액션
        modalView.applyFilterButton.addTarget(self, action: #selector(applyFilterTapped), for: .touchUpInside)
    }
    
    // 카테고리버튼 배경색 & 글자색 변경
    @objc private func categoryButtonTapped(_ sender: CustomTag) {
        sender.isSelected.toggle()
        /// TODO - 선택된 카테고리 데이터 담기
        ///
        print(sender.titleLabel?.text ?? "")
    }
    
    // 적용버튼
    @objc private func applyFilterTapped() {
        print("필터 적용 버튼 클릭됨")
        /// TODO - 선택된 카테고리 데이터 넘기기 (searchView로)
        
        dismiss(animated: true)
    }
    
}
