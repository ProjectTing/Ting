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

class SignUpViewController: UIViewController {
    
    private let signUpView = SignUpView()
    private var rawNonce: String?
    
    override func loadView() {
        view = signUpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        navigationController?.navigationBar.isHidden = true // 네비게이션컨트롤러 가리는 객체
    }
    
    
    
    private func setupActions() {
        signUpView.appleLoginButton.addTarget(self, action: #selector(handleAppleLogin), for: .touchUpInside)
    }
    
    @objc private func handleAppleLogin() {
        rawNonce = Self.randomNonceString()
        let hashedNonce = Self.sha256(rawNonce!) // 해싱된 nonce 생성
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = hashedNonce // 애플 요청에 해시된 nonce 포함
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
}

extension SignUpViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
           let identityToken = appleIDCredential.identityToken,
           let tokenString = String(data: identityToken, encoding: .utf8),
           let rawNonce = rawNonce {  // 저장된 rawNonce 사용
            
            // Apple의 userIdentifier 저장
            UserDefaults.standard.set(appleIDCredential.user, forKey: "appleUserIdentifier")
            
            // Firebase 인증
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: rawNonce)
            
            Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                if let error = error {
                    print("Firebase 인증 실패: \(error.localizedDescription)")
                    return
                }
                
                guard let user = authResult?.user else { return }
                // 여기에 추가
                self?.createUserDocument(for: user)
                
                DispatchQueue.main.async {
                    let addUserInfoVC = AddUserInfoVC(userId: user.uid)
                    self?.navigationController?.pushViewController(addUserInfoVC, animated: true)
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple 로그인 실패:", error.localizedDescription)
    }
}

// MARK: - Firestore에 약관 동의 상태 저장
extension SignUpViewController {
   func createUserDocument(for user: User) {
       let db = Firestore.firestore()
       let userData: [String: Any] = [
           "id": user.uid,              // 고유 키값
           "email": user.email ?? "",   // 애플id 이메일값
           "createdAt": Timestamp(),    // 생성날짜
           "termsAccepted": true        // 약관 동의
       ]
       
       db.collection("users").document(user.uid).setData(userData) { error in
           if let error = error {
               print("사용자 문서 생성 실패: \(error)")
           } else {
               print("사용자 문서 생성 성공")
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
