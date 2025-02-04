//
//  LabelAndTagStackView.swift
//  Ting
//
//  Created by Watson22_YJ on 1/29/25.
//

import UIKit
import SnapKit
import Then

/// 커스텀뷰 (타이틀 + 커스텀태그스택) - 게시글 작성, 검색
final class LabelAndTagStackView: UIView {
    
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.textColor = .deepCocoa
    }
    
    let buttonStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillProportionally
    }
    
    let isDuplicable: Bool
    
    init(title: String, tagTitles: [String], isDuplicable: Bool = false) {
        self.isDuplicable = isDuplicable
        super.init(frame: .zero)
        setupUI(labelTitle: title, buttonTitles: tagTitles)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI(labelTitle: String, buttonTitles: [String]) {
        titleLabel.text = labelTitle
        
        // 타이틀로 버튼 생성
        buttonTitles.forEach { title in
            let button = CustomTag(
                title: title,
                titleColor: .primary,
                strokeColor: .secondary,
                backgroundColor: .white,
                isButton: true
            )
            buttonStack.addArrangedSubview(button)
        }
        
        addSubviews(titleLabel, buttonStack)
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        buttonStack.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    /// TODO - 필요성 확인 후 정리 필요
    /// 현재 스택뷰에 있는 모든 CustomTag 버튼 가져오기
       func getTagButtons() -> [CustomTag] {
           return buttonStack.arrangedSubviews.compactMap { $0 as? CustomTag }
       }
    
    /// 중복 선택된 태그들 타이틀 배열로 반환
        func getSelectedTags() -> [String] {
                return getTagButtons()
                    .filter { $0.isSelected }
                    .compactMap { $0.titleLabel?.text }
            }

        /// 선택된 태그 타이틀 반환
        func getSelectedTag() -> String {
               return getSelectedTags().first ?? ""
           }
}
