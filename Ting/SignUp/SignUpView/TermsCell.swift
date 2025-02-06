//
//  TermsCell.swift
//  Ting
//
//  Created by t2023-m105 on 1/25/25.
//

import UIKit
import SnapKit
import Then

/// 약관 동의 항목을 위한 테이블뷰 셀
class TermsCell: UITableViewCell {
    
    // 체크 아이콘 (사용자가 누르면 토글됨)
    private let checkIcon = UIImageView().then {
        $0.image = UIImage(systemName: "checkmark.circle.fill")
        $0.tintColor = .gray // 기본 비활성화 색상
        $0.isUserInteractionEnabled = true // 사용자 터치 가능하도록 설정
    }
    
    // 약관 텍스트
    private let termLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .black
    }
    
    // 화살표 아이콘 (약관 보기 버튼)
    private let arrowIcon = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.right")
        $0.tintColor = UIColor.lightGray
    }
    
    // 현재 체크 상태 저장
    private var isChecked = false {
        didSet {
            checkIcon.tintColor = isChecked ? UIColor.accent : .gray
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupTapGesture() // 체크 아이콘에 클릭 이벤트 추가
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UI 구성
    private func setupUI() {
        selectionStyle = .none
        
        contentView.backgroundColor = .ivoryWhite
        contentView.addSubview(checkIcon)
        contentView.addSubview(termLabel)
        contentView.addSubview(arrowIcon)
        
        checkIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
        
        termLabel.snp.makeConstraints {
            $0.leading.equalTo(checkIcon.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
        }
        
        arrowIcon.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(15)
        }
    }
    
    // 셀 데이터 설정 (초기 상태 설정)
    func configure(text: String, isRequired: Bool, isChecked: Bool) {
        termLabel.text = text
        self.isChecked = isChecked // 초기 상태 설정

        // 특정 텍스트에 대해 화살표 숨기기
        arrowIcon.isHidden = (text == "(필수) 만 14세 이상입니다")
    }
    
    // 체크 아이콘에 클릭 이벤트 추가
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleCheck))
        checkIcon.addGestureRecognizer(tapGesture)
    }
    
    // 체크 상태 변경 (토글)
    @objc private func toggleCheck() {
        isChecked.toggle()
    }
}
