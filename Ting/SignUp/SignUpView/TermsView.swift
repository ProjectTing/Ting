//
//  TermsView.swift
//  Ting
//
//  Created by t2023-m105 on 1/24/25.
//

import UIKit
import SnapKit
import Then

/// 이용약관 모달 창 UI를 담당하는 뷰
class TermsView: UIView {
    
    // "모두 동의합니다" 버튼
    let allAgreeButton = UIButton().then {
        var config = UIButton.Configuration.plain() // 기본 스타일
        
        // 체크 마크 아이콘 및 텍스트 설정 (초기 상태는 비활성화된 체크 아이콘)
        let titleText = " 모두 동의합니다"
        let image = UIImage(systemName: "checkmark.circle")  // 초기 상태는 비활성화된 체크 아이콘

        config.image = image
        config.baseForegroundColor = UIColor.accent  // 아이콘 색상
        config.attributedTitle = AttributedString(titleText, attributes: AttributeContainer([
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.black
        ]))

        // 텍스트와 아이콘 위치 미세 조정
        config.imagePadding = 5
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 10)

        $0.configuration = config

        // 버튼 테두리 스타일
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
    }
    
    // 약관 리스트 테이블뷰
    let tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
    }
    
    // "다음" 버튼
    let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        $0.backgroundColor = .accent
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
        
        addSubview(allAgreeButton)
        addSubview(tableView)
        addSubview(nextButton)
        
        allAgreeButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(allAgreeButton.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(200)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
    }
}
