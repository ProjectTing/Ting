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
    
    private let scrollView = UIScrollView().then {
        $0.alwaysBounceVertical = true
        $0.showsVerticalScrollIndicator = true
    }
    
    private let contentView = UIView()
    
    lazy var findListSection = LabelAndTagSection(title: "찾고싶은 게시판", tagTitles: ["팀원 모집", "팀 합류"], isDuplicable: true)

    lazy var positionSection = LabelAndTagSection(postType: .joinTeam, sectionType: .position, isDuplicable: true)
    
    lazy var meetingStyleSection = LabelAndTagSection(postType: .joinTeam, sectionType: .meetingStyle)
    
    // 필터 적용 버튼
    let applyFilterButton = UIButton(type: .system).then {
        $0.setTitle("필터 적용하기", for: .normal)
        $0.tintColor = .white
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
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
        self.backgroundColor = .background
        
        addSubviews(scrollView, applyFilterButton)
        scrollView.addSubview(contentView)

        contentView.addSubviews(
            findListSection, 
            positionSection, 
            meetingStyleSection
            )  
        
        scrollView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(applyFilterButton.snp.top).offset(-20)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }

        findListSection.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().inset(16)
        }
        
        positionSection.snp.makeConstraints {
            $0.top.equalTo(findListSection.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(16)
        }

        meetingStyleSection.snp.makeConstraints {
            $0.top.equalTo(positionSection.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        applyFilterButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(50)
        }
    }
}

