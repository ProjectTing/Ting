//
//  SearchSelectModalVC.swift
//  Ting
//
//  Created by t2023-m0033 on 1/26/25.
//

import UIKit

protocol SearchSelectModalDelegate: AnyObject {
    func didApplyFilter(with selectedTags: [String])
}

final class SearchSelectModalVC: UIViewController {
    
    // 카테고리 선택 모달
    private let modalView = SearchSelectModal()
    
    var selectedTagsTitles: [String] = []
    
    // 델리게이트 변수 추가
    weak var delegate: SearchSelectModalDelegate?
    
    override func loadView() {
        view = modalView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupApplyButton()
    }
    
    private func setupDelegates() {
        modalView.findListSection.delegate = self
        modalView.positionSection.delegate = self
        modalView.meetingStyleSection.delegate = self
    }
    
    func setupApplyButton() {
        modalView.applyFilterButton.addTarget(self, action: #selector(applyFilterTapped), for: .touchUpInside)
    }
    
    // 적용버튼
    @objc private func applyFilterTapped() {
        print("태그들: \(selectedTagsTitles)")
        /// TODO - 선택된 카테고리 데이터 넘기기 (searchView로)
        /// 델리게이트 메서드 호출해서 선택한 태그들을 전달
        delegate?.didApplyFilter(with: selectedTagsTitles)
        
        dismiss(animated: true)
    }
    
}

// 커스텀 섹션 버튼 delegate 프로토콜
extension SearchSelectModalVC: LabelAndTagSectionDelegate {
    func selectedButton(in view: LabelAndTagSection, button: CustomTag, isSelected: Bool) {
        // 버튼의 타이틀 가져오기
        guard let title = button.titleLabel?.text else { return }
        
        // 선택/해제 상태에 따라 배열 업데이트
        if isSelected {
            selectedTagsTitles.append(title)
        } else {
            selectedTagsTitles.removeAll { $0 == title }
        }
    }
}
