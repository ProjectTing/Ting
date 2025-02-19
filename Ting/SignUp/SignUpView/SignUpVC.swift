//
//  SignUpVC.swift
//  Ting
//
//  Created by Sol on 1/21/25.
//

import UIKit
import AuthenticationServices
import FirebaseAuth
import FirebaseFirestore
import CryptoKit

class SignUpVC: UIViewController {

    private let signUpView = SignUpView()
    private var rawNonce: String?

    override func loadView() {
        view = signUpView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        navigationController?.navigationBar.isHidden = true
    }

    private func setupActions() {
        signUpView.appleLoginButton.addTarget(self, action: #selector(handleAppleLogin), for: .touchUpInside)
    }

    @objc private func handleAppleLogin() {
        rawNonce = Self.randomNonceString()
        let hashedNonce = Self.sha256(rawNonce!)

        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = hashedNonce

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
}

extension SignUpVC: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
           let identityToken = appleIDCredential.identityToken,
           let tokenString = String(data: identityToken, encoding: .utf8),
           let rawNonce = rawNonce {
            
            let credential = OAuthProvider.credential(
                providerID: AuthProviderID.apple,  // "apple.com" 대신 AuthProviderID.apple 사용
                idToken: tokenString,
                rawNonce: rawNonce,
                accessToken: nil
            )
            Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                if let error = error {
                    print("Firebase 인증 실패: \(error.localizedDescription)")
                    return
                }
                
                guard let user = authResult?.user else { return }
                
                // Firestore에 사용자 정보 저장
                self?.createUserDocument(for: user)
                
                // UserDefaults에 UID 저장
                UserDefaults.standard.set(user.uid, forKey: "userId")
                UserDefaults.standard.synchronize()
                
                // 기존 사용자 정보 검증 후 화면 전환
                self?.checkExistingUserInfo(userID: user.uid)
            }
        }
    }
    
    private func createUserDocument(for user: User) {
        let db = Firestore.firestore()
        let userData: [String: Any] = [
            "id": user.uid,               // 사용자 UID
            "email": user.email ?? "",    // 사용자 이메일
            "createdAt": Timestamp()      // 생성 날짜
        ]
        
        db.collection("users").document(user.uid).setData(userData) { error in
            if let error = error {
                print("Firestore에 사용자 데이터 저장 실패: \(error.localizedDescription)")
            } else {
                print("Firestore에 사용자 데이터 저장 성공")
            }
        }
    }
    
    private func checkExistingUserInfo(userID: String) {
        let db = Firestore.firestore()
        
        db.collection("infos").whereField("userId", isEqualTo: userID).getDocuments { [weak self] snapshot, error in
            if let documents = snapshot?.documents, !documents.isEmpty {
                print("기존 사용자 정보가 존재합니다. TabBar로 이동합니다.")
                DispatchQueue.main.async {
                    let tabBar = TabBar()
                    self?.navigationController?.setViewControllers([tabBar], animated: true)
                }
            } else {
                print("기존 사용자 정보가 없습니다. PermissionVC로 이동합니다.")
                DispatchQueue.main.async {
                    self?.navigateToPermissionVC(userID: userID)
                }
            }
        }
    }
    
    private func navigateToPermissionVC(userID: String) {
        let permissionVC = PermissionVC()
        permissionVC.modalPresentationStyle = .fullScreen
        
        // PermissionVC에서 약관 동의 후 `AddUserInfoVC`로 이동하도록 설정
        permissionVC.onAgreementCompletion = { [weak self] in
            print("약관 동의 완료. AddUserInfoVC로 이동합니다.")
            let addUserInfoVC = AddUserInfoVC(userId: userID)
            self?.navigationController?.pushViewController(addUserInfoVC, animated: true)
        }
        
        self.present(permissionVC, animated: true)
    }
}

// MARK: - Nonce 생성 및 해싱
extension SignUpVC {
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
