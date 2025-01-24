//
//  SignUpViewController.swift
//  Ting
//
//  Created by Sol on 1/21/25.
//

import UIKit
import AuthenticationServices
import SnapKit
import Then

class SignUpViewController: UIViewController {
    
    // 제목 레이블 (상단에 표시되는 설명 문구)
    private let titleLabel = UILabel().then {
        $0.text = "개발자를 위한 매칭 플랫폼"
        $0.textColor = UIColor(hex: "#9A3412") // HEX 컬러 사용
        $0.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        $0.textAlignment = .center
    }
    
    // 서비스 이름 (Ting) 레이블
    private let nameLabel = UILabel().then {
        $0.text = "Ting"
        $0.textColor = UIColor(hex: "#7C2D12")
        $0.font = UIFont.boldSystemFont(ofSize: 30) // 현재 볼드체, 폰트 수정 예정
        $0.textAlignment = .center
    }
    
    // 회원가입 안내 텍스트 (버튼이 아니라 단순한 텍스트)
    private let signUpLabel = UILabel().then {
        let text = "Ting 회원가입하기"
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: text.count))
        $0.attributedText = attributedString
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textAlignment = .center
    }
    
    // Apple 로그인 버튼 (ASAuthorizationAppleIDButton 사용)
    private let appleLoginButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black).then {
        $0.cornerRadius = 10 // 버튼 모서리 둥글게 설정
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#FFF7ED") // 배경색 설정
        setupUI() // UI 요소 배치
        setupActions() // 버튼 액션 설정
    }
    
    // MARK: - UI 배치 설정
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(nameLabel)
        view.addSubview(signUpLabel)
        view.addSubview(appleLoginButton)
        
        // 제목 레이블 위치 설정
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            $0.centerX.equalToSuperview()
        }
        
        // 서비스 이름 (Ting) 위치 설정
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        // 회원가입 안내 텍스트 위치 설정
        signUpLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        // Apple 로그인 버튼 위치 설정 (화면 하단 가까이 배치)
        appleLoginButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40) // 하단에서 40pt 위
            $0.centerX.equalToSuperview()
            $0.width.equalTo(280) // 버튼 너비
            $0.height.equalTo(50) // 버튼 높이
        }
    }
    
    // MARK: - 액션 설정
    private func setupActions() {
        appleLoginButton.addTarget(self, action: #selector(handleAppleLogin), for: .touchUpInside)
    }
    
    // MARK: - Apple 로그인 처리
    @objc private func handleAppleLogin() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email] // 사용자 이름, 이메일 요청
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests() // 로그인 요청 실행
    }
}

// MARK: - Apple 로그인 처리 (ASAuthorizationControllerDelegate)
extension SignUpViewController: ASAuthorizationControllerDelegate {
    
    // 로그인 성공 시 처리
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user // 유저 ID
            let fullName = appleIDCredential.fullName // 전체 이름
            let email = appleIDCredential.email // 이메일
            
            print("Apple 로그인 성공!")
            print("User ID: \(userIdentifier)")
            print("Name: \(fullName?.givenName ?? "") \(fullName?.familyName ?? "")")
            print("Email: \(email ?? "이메일 없음")")
            
            // 로그인 후 메인 화면으로 이동하는 코드 추가 가능
        }
    }
    
    // 로그인 실패 시 처리
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple 로그인 실패: \(error.localizedDescription)")
    }
}

// MARK: - UIColor HEX 코드 변환 확장
extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
