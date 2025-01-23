//
//  SearchV.swift
//  Ting
//
//  Created by Sol on 1/22/25.
//

import UIKit
import SnapKit
import Then

/// 검색 화면 UI를 담당하는 뷰
class SearchView: UIView {
    
    // 🔍 검색창
    let searchBar = UISearchBar().then {
        $0.placeholder = "검색어를 입력하세요"
        $0.searchBarStyle = .minimal
        $0.backgroundColor = .clear
    }
    
    // 카테고리 목록
    let categories: [(String, [String])] = [
        ("구인/구직", ["구인", "구직"]),
        ("직무", ["개발", "기획", "디자인", "마케터", "데이터"]),
        ("시급성", ["급함", "보통", "여유로움"]),
        ("아이디어 상황", ["구체적임", "모호함", "없음"]),
        ("경험", ["처음 입문", "재직중", "휴직중", "취준중"])
    ]
    
    // 카테고리별 StackView 담을 스크롤 뷰
    let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    let contentView = UIView()
    
    // 필터 적용 버튼
    let applyFilterButton = UIButton().then {
        $0.setTitle("필터 적용하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor(hex: "#C2410C")
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
        backgroundColor = UIColor(hex: "#FFF7ED")
        
        addSubview(searchBar)
        addSubview(scrollView)
        addSubview(applyFilterButton)
        
        scrollView.addSubview(contentView)
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(applyFilterButton.snp.top).offset(-20)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }
        
        applyFilterButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-10)
            $0.leading.trailing.equalToSuperview().inset(16)
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
                $0.textColor = UIColor(hex: "#C2410C") // 카테고리 주제 글자 색상
            }
            
            let buttonStackView = UIStackView().then {
                $0.axis = .horizontal
                $0.spacing = 8
                $0.alignment = .leading
                $0.distribution = .fillProportionally
            }
            
            for item in items {
                let button = createFilterButton(title: item)
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
                $0.leading.trailing.equalToSuperview()
            }
            
            previousView = buttonStackView
        }
        
        // 마지막 요소의 하단을 contentView에 맞춤
        previousView?.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
    
    // MARK: - 필터 버튼 생성 (iOS 15 대응)
    private func createFilterButton(title: String) -> UIButton {
        let button = UIButton().then {
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(UIColor(hex: "#9A3412"), for: .normal) // ✅ 기본 글자 색상 (갈색)
            $0.layer.borderColor = UIColor(hex: "#FB923C").cgColor // ✅ 테두리 색상
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 15
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            $0.backgroundColor = UIColor(hex: "#FFFFFF") // ✅ 기본 배경색 (흰색)
            
            // iOS 15 이상에서는 UIButtonConfiguration 사용
            if #available(iOS 15.0, *) {
                var config = UIButton.Configuration.plain()
                config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
                $0.configuration = config
            } else {
                // iOS 14 이하에서는 기존 contentEdgeInsets 사용
                $0.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
            }
            
            // ✅ 버튼 클릭 시 배경색 & 글자색 변경
            $0.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        }
        
        return button
    }
    
    // MARK: - 버튼 클릭 이벤트 (배경색 & 글자색 변경)
    @objc private func filterButtonTapped(_ sender: UIButton) {
        let selectedBackgroundColor = UIColor(hex: "#C2410C") // ✅ 선택된 배경색 (주황)
        let defaultBackgroundColor = UIColor(hex: "#FFFFFF") // ✅ 기본 배경색 (흰색)
        
        let selectedTextColor = UIColor.white // ✅ 선택 시 글자 색상 (흰색)
        let defaultTextColor = UIColor(hex: "#9A3412") // ✅ 기본 글자 색상 (갈색)
        
        // 현재 상태에 따라 배경색 & 글자색 변경
        if sender.backgroundColor == defaultBackgroundColor {
            sender.backgroundColor = selectedBackgroundColor
            sender.setTitleColor(selectedTextColor, for: .normal) // ✅ 글자색 변경 (흰색)
        } else {
            sender.backgroundColor = defaultBackgroundColor
            sender.setTitleColor(defaultTextColor, for: .normal) // ✅ 글자색 변경 (갈색)
        }
    }
}
