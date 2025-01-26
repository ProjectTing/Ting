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

/// 회원가입 화면의 컨트롤러
class SignUpViewController: UIViewController {
    
    private let signUpView = SignUpView() // 뷰 인스턴스
    
    // MARK: - View Lifecycle
    override func loadView() {
        view = signUpView // 뷰를 SignUpView로 설정
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions() // 버튼 액션 설정
    }
    
    // MARK: - 액션 설정
    private func setupActions() {
        signUpView.appleLoginButton.addTarget(self, action: #selector(handleAppleLogin), for: .touchUpInside)
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
