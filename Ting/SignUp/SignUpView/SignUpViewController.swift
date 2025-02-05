//
//  SignUpViewController.swift
//  Ting
//
//  Created by Sol on 1/21/25.
//

import UIKit
import AuthenticationServices
import FirebaseAuth
import FirebaseFirestore
import CryptoKit

/// 회원가입 화면의 컨트롤러
class SignUpViewController: UIViewController {
    
    private let signUpView = SignUpView()
    private var rawNonce: String?  // rawNonce를 전역 변수로 저장
    
    override func loadView() {
        view = signUpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }
    
    private func setupActions() {
        signUpView.appleLoginButton.addTarget(self, action: #selector(handleAppleLogin), for: .touchUpInside)
    }
    
    // MARK: - Apple 로그인 처리
    @objc private func handleAppleLogin() {
        rawNonce = Self.randomNonceString()  // rawNonce 생성 및 저장
        let hashedNonce = Self.sha256(rawNonce!)  // 해싱된 nonce 생성
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = hashedNonce  // 애플 요청에 해시된 nonce 포함
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
}

// MARK: - Apple 로그인 처리 (ASAuthorizationControllerDelegate)
extension SignUpViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
           let identityToken = appleIDCredential.identityToken,
           let tokenString = String(data: identityToken, encoding: .utf8),
           let rawNonce = rawNonce {  // 저장된 rawNonce 사용
            
            // Firebase 인증
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: rawNonce)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase 인증 실패: \(error.localizedDescription)")
                    return
                }
                
                print("Firebase 인증 성공!")
                if let user = authResult?.user {
                    print("유저 UID: \(user.uid)")
                    print("이메일: \(user.email ?? "이메일 없음")")
                    
                    // Firestore에 약관 동의 상태 저장
                    self.saveAgreementStatus(userID: user.uid)
                    
                    // TabBar로 완전히 전환 (루트 뷰 컨트롤러 변경)
                    let tabBarController = TabBar()
                    let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                    sceneDelegate?.window?.rootViewController = tabBarController
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple 로그인 실패: \(error.localizedDescription)")
    }
}

// MARK: - Firestore에 약관 동의 상태 저장
extension SignUpViewController {
    func saveAgreementStatus(userID: String) {
        let db = Firestore.firestore()
        db.collection("users").document(userID).setData(["termsAccepted": true]) { error in
            if let error = error {
                print("약관 동의 상태 저장 실패: \(error.localizedDescription)")
            } else {
                print("약관 동의 상태 저장 성공!")
            }
        }
    }
}

// MARK: - Nonce 생성 및 해싱
extension SignUpViewController {
    
    static func randomNonceString(length: Int = 32) -> String {
        let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode == errSecSuccess {
                    return random
                } else {
                    fatalError("Unable to generate nonce.")
                }
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }

    static func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        return hashedData.compactMap { String(format: "%02x", $0) }.joined()
    }
}
