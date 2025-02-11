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
        $0.text = "프로젝트를 위한 완벽한 매칭"
        $0.textColor = .accent
        $0.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        $0.textAlignment = .left // 왼쪽 정렬
    }
    
    // 서비스 이름 (Ting) 레이블
    let nameLabel = UILabel().then {
        $0.text = "Ting"
        $0.textColor = .primary
        $0.font = UIFont(name: "Gemini Moon", size: 55) // Gemini Moon 폰트 적용
        $0.textAlignment = .left // 왼쪽 정렬
    }
    
    // Apple 로그인 버튼 (ASAuthorizationAppleIDButton 사용)
    let appleLoginButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black).then {
        $0.cornerRadius = 10
    }
    
    // 비로그인으로 시작하기 버튼
    private lazy var guestLoginBtn = UIButton().then {
        $0.setTitle("로그인 없이 둘러만 볼게요", for: .normal)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .background
        $0.layer.borderColor = UIColor.accent.cgColor // 테두리 색 설정
        $0.layer.borderWidth = 2 // 테두리 두께 설정
        $0.setTitleColor(.accent, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        $0.addTarget(self, action: #selector(guestBtnTapped), for: .touchUpInside)
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
        addSubview(appleLoginButton)
        addSubview(guestLoginBtn)
        
        // 제목 레이블 위치 설정
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(60)
            $0.leading.equalToSuperview().offset(20) // leading 기준 배치
        }
        
        // 서비스 이름 (Ting) 위치 설정
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20) // leading 기준 배치
        }
        
        // Apple 로그인 버튼 위치 설정 (화면 하단 가까이 배치)
        appleLoginButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-96)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(280)
            $0.height.equalTo(50)
        }
        
        // 게스트 로그인 버튼
        guestLoginBtn.snp.makeConstraints {
            $0.top.equalTo(appleLoginButton.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(280)
            $0.height.equalTo(50)
        }
    }
    
    // MARK: - Button Action
    @objc // 게스트 로그인 버튼 클릭시 액션
    private func guestBtnTapped() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = TabBar()
        }
    }
}

