//
//  LabelAndTagSection.swift
//  Ting
//
//  Created by Watson22_YJ on 1/29/25.
//

import UIKit
import SnapKit
import Then

protocol LabelAndTagSectionDelegate: AnyObject {
    func selectedButton(in view: LabelAndTagSection, button: CustomTag)
}

/// 커스텀뷰 (타이틀 + 커스텀태그스택) - 게시글 작성, 검색
final class LabelAndTagSection: UIView {
    
    weak var delegate: LabelAndTagSectionDelegate?
    
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.textColor = .deepCocoa
    }
    
    let buttonStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillProportionally
    }
    // 버튼 담을 배열
    var buttons: [CustomTag] = []
    
    // 중복선택 가능 여부
    let isDuplicable: Bool
    
    // 섹션타입 enum
    var sectionType: SectionType?
    
    // 선택된 버튼들의 타이틀 반환
    var selectedTitles: [String] {
        buttons.filter { $0.isSelected }.compactMap { $0.titleLabel?.text }
    }
    
    init(postType: PostType, sectionType: SectionType, isDuplicable: Bool = false) {
        self.isDuplicable = isDuplicable
        self.sectionType = sectionType
        super.init(frame: .zero)
        setupUI(labelTitle: sectionType.title(postType: postType),
                buttonTitles: sectionType.tagTitles(postType: postType)
        )
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
            buttons.append(button)
            buttonStack.addArrangedSubview(button)
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
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
    
    // 버튼 탭 처리
    @objc private func buttonTapped(_ sender: CustomTag) {
        if !isDuplicable {
            // 단일 선택인 경우 다른 버튼들 선택 해제
            buttons.forEach { button in
                if button != sender && button.isSelected {
                    button.isSelected = false
                }
            }
        }
        // 현재 버튼 상태 토글
        sender.isSelected.toggle()
        // 상태 변화에 따라 다른 델리게이트 메서드 호출
        if sender.isSelected {
            delegate?.selectedButton(in: self, button: sender)
        }
    }
}

extension LabelAndTagSection {
    func setSelectedTag(titles: [String]) {
        // 기존에 선택된 태그들 초기화
        buttons.forEach { tag in
            tag.isSelected = false
            tag.backgroundColor = .white
        }
        
        // 전달받은 titles에 해당하는 태그들 선택 상태로 변경
        buttons.forEach { tag in
            if titles.contains(tag.titleLabel?.text ?? "") {
                tag.isSelected = true
                tag.backgroundColor = .secondary.withAlphaComponent(0.1)
            }
        }
    }
}
