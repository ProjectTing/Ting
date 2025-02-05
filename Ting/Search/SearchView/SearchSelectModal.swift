//
//  SearchSelectModal.swift
//  Ting
//
//  Created by t2023-m0033 on 1/26/25.
//

import UIKit
import SnapKit
import Then

/// 검색 카테고리 설정 모달
final class SearchSelectModal: UIView {
    
    // 카테고리 목록
    let categories: [(String, [String])] = [
        ("게시글 구분", ["팀원 모집", "팀 합류"]),
        ("직무", ["개발", "기획", "디자인", "마케터", "데이터"]),
        ("시급성", ["급함", "보통", "여유로움"]),
        ("아이디어 상황", ["구체적임", "모호함", "없음"]),
        ("경험", ["처음 입문", "재직중", "휴직중", "취준중"])
    ]
    
    // 카테고리별 StackView 담을 스크롤 뷰
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = true
    }
    
    private let contentView = UIView()
    
    // 모든 카테고리 버튼을 담을 배열
    var categoryButtons: [UIButton] = []
    
    // 필터 적용 버튼
    let applyFilterButton = UIButton(type: .system).then {
        $0.setTitle("필터 적용하기", for: .normal)
        $0.tintColor = .white
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular)
        $0.backgroundColor = .primary
        $0.layer.cornerRadius = 10
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI 설정
    private func setupUI() {
        backgroundColor = .background
        
        addSubview(scrollView)
        addSubview(applyFilterButton)
        
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(applyFilterButton.snp.top).offset(-20)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }
        
        applyFilterButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(280)
            $0.height.equalTo(50)
        }
        
        setupCategoryButtons()
    }
    
    // MARK: - 카테고리 버튼 동적 생성
    private func setupCategoryButtons() {
        var previousView: UIView? = nil
        
        for (category, items) in categories {
            let categoryLabel = UILabel().then {
                $0.text = category
                $0.font = UIFont.boldSystemFont(ofSize: 16)
                $0.textColor = .deepCocoa // 카테고리 주제 글자 색상
            }
            
            let buttonStackView = UIStackView().then {
                $0.axis = .horizontal
                $0.spacing = 8
                $0.distribution = .fillProportionally
            }
            
            for str in items {
                let button = createCategoryButtons(title: str)
                categoryButtons.append(button)
                buttonStackView.addArrangedSubview(button)
            }
            
            contentView.addSubview(categoryLabel)
            contentView.addSubview(buttonStackView)
            
            categoryLabel.snp.makeConstraints {
                $0.top.equalTo(previousView?.snp.bottom ?? contentView.snp.top).offset(20)
                $0.leading.equalToSuperview()
            }
            
            buttonStackView.snp.makeConstraints {
                $0.top.equalTo(categoryLabel.snp.bottom).offset(10)
                $0.leading.equalToSuperview()
            }
            
            previousView = buttonStackView
        }
        
        // 마지막 요소의 하단을 contentView에 맞춤
        previousView?.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
    
    // MARK: - 카테고리 버튼 생성
    private func createCategoryButtons(title: String) -> UIButton {
        let button = CustomTag(
            title: title,
            /// TODO - 글씨, 테두리 색상 고민
            titleColor: .primary,
            strokeColor: .secondary,
            backgroundColor: .white,
            isButton: true
        )
        return button
    }
}

