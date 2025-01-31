//
//  PermissionView.swift
//  Ting
//
//  Created by Sol on 1/25/25.
//
    
import UIKit
import SnapKit
import Then

/// 첫 번째 화면 (PermissionView)
class PermissionView: UIView {

    // 제목 레이블
    let titleLabel = UILabel().then {
        $0.text = "개발자를 위한 매칭 플랫폼"
        $0.textColor = .accent
        $0.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        $0.textAlignment = .left
    }

    // 서비스 이름 (Ting) 레이블
    let nameLabel = UILabel().then {
        $0.text = "Ting"
        $0.textColor = .brownText
        $0.font = UIFont.boldSystemFont(ofSize: 30)
        $0.textAlignment = .left
    }

    // "다음" 버튼
    let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        $0.backgroundColor = .primary
        $0.layer.cornerRadius = 10
    }

    // 약관 동의 안내 문구
    let agreementLabel = UILabel().then {
        let fullText = "다음 버튼을 클릭으로, Ting 이용 약관에 동의합니다."
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: "이용 약관")
        attributedString.addAttribute(.foregroundColor, value: UIColor.accent, range: range)
        $0.attributedText = attributedString
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textAlignment = .center
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

        addSubview(titleLabel)
        addSubview(nameLabel)
        addSubview(nextButton)
        addSubview(agreementLabel)

        // 제목 레이블 위치 설정
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(60)
            $0.leading.equalToSuperview().offset(20)
        }

        // 서비스 이름 (Ting) 위치 설정
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
        }

        // "다음" 버튼 위치 설정
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-80)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(50)
        }

        // 약관 동의 문구 위치 설정
        agreementLabel.snp.makeConstraints {
            $0.top.equalTo(nextButton.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
}
