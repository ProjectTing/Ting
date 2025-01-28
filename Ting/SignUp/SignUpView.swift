//
//  SignUpView.swift
//  Ting
//
//  Created by Sol on 1/24/25.
//

import UIKit
import AuthenticationServices
import SnapKit
import Then

/// 회원가입 화면의 UI를 담당하는 뷰
class SignUpView: UIView {
    
    // 제목 레이블 (상단에 표시되는 설명 문구)
    let titleLabel = UILabel().then {
        $0.text = "개발자를 위한 매칭 플랫폼"
        $0.textColor = .accent
        $0.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        $0.textAlignment = .left // 왼쪽 정렬
    }
    
    // 서비스 이름 (Ting) 레이블
    let nameLabel = UILabel().then {
        $0.text = "Ting"
        $0.textColor = .brownText
        $0.font = UIFont.boldSystemFont(ofSize: 30)
        $0.textAlignment = .left // 왼쪽 정렬
    }
    
    // 회원가입 안내 텍스트 (버튼이 아니라 단순한 텍스트)
    let signUpLabel = UILabel().then {
        let text = "Ting 회원가입하기"
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: text.count))
        $0.attributedText = attributedString
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textAlignment = .left // 왼쪽 정렬
    }
    
    // Apple 로그인 버튼 (ASAuthorizationAppleIDButton 사용)
    let appleLoginButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black).then {
        $0.cornerRadius = 10
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI() // UI 요소 배치
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI 배치 설정
    private func setupUI() {
        backgroundColor = .background
        
        addSubview(titleLabel)
        addSubview(nameLabel)
        addSubview(signUpLabel)
        addSubview(appleLoginButton)
        
        // 제목 레이블 위치 설정
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(100)
            $0.leading.equalToSuperview().offset(20) // leading 기준 배치
        }
        
        // 서비스 이름 (Ting) 위치 설정
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20) // leading 기준 배치
        }
        
        // 회원가입 안내 텍스트 위치 설정
        signUpLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20) // leading 기준 배치
        }
        
        // Apple 로그인 버튼 위치 설정 (화면 하단 가까이 배치)
        appleLoginButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-40)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(280)
            $0.height.equalTo(50)
        }
    }
}
