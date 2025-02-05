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
    
    var selectedTagsTitles: [String] = []
    
    override func loadView() {
        view = modalView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTagButtonActions()
    }
    
    private func setupTagButtonActions() {
        // 카테고리 버튼 액션 설정
        let allSections = [
            modalView.findListSection,
            modalView.positionSection,
            modalView.meetingStyleSection
        ]
        
        for section in allSections {
            for button in section.getTagButtons() {
                button.addTarget(self, action: #selector(tagButtonTapped), for: .touchUpInside)
            }
        }
        
        // 필터 적용 버튼 액션
        modalView.applyFilterButton.addTarget(self, action: #selector(applyFilterTapped), for: .touchUpInside)
    }
    
    // 카테고리버튼 배경색 & 글자색 변경
    @objc private func tagButtonTapped(_ sender: CustomTag) {
        // 버튼이 속한 스택뷰와 섹션 찾기
        guard let stackView = sender.superview as? UIStackView,
              let section = sender.superview?.superview as? LabelAndTagStackView else { return }
        
        if !section.isDuplicable {
            // 단일 선택인 경우 같은 스택뷰 내의 다른 버튼들 선택 해제
            stackView.arrangedSubviews.forEach { view in
                if let button = view as? CustomTag, button != sender {
                    button.isSelected = false
                }
            }
        }
        
        sender.isSelected.toggle()
        
        // 선택된 태그 관리
        if sender.isSelected {
            // 선택된 태그 추가
            selectedTagsTitles.append(sender.titleLabel?.text ?? "")
        } else {
            // 선택 해제되면 배열에서 삭제
            selectedTagsTitles.removeAll { $0 == sender.titleLabel?.text }
        }
    }
    
    // 적용버튼
    @objc private func applyFilterTapped() {
        print("태그들: \(selectedTagsTitles)")
        /// TODO - 선택된 카테고리 데이터 넘기기 (searchView로)
        
        dismiss(animated: true)
    }
    
}
