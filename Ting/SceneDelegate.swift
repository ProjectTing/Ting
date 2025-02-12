//
//  SceneDelegate.swift
//  Ting
//
//  Created by 이재건 on 1/17/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        // 현재 유저 확인
        checkCurrentUser()
        window?.makeKeyAndVisible()
    }

    private func checkCurrentUser() {
        if let currentUser = Auth.auth().currentUser {
            // 로그인된 유저가 있으면 Firestore의 유저 정보를 검증하고 적절한 화면으로 이동
            checkUserDocument(userID: currentUser.uid)
        } else {
            // 로그인되지 않은 경우 SignUpVC로 이동
            showSignUpVC()
        }
    }

    private func checkUserDocument(userID: String) {
        let db = Firestore.firestore()

        db.collection("users").document(userID).getDocument { [weak self] document, _ in
            if let document = document, document.exists {
                let termsAccepted = document.data()?["termsAccepted"] as? Bool ?? false
                
                if termsAccepted {
                    // 약관에 동의한 유저라면 추가 정보 검증
                    self?.checkUserInfoExists(userID: userID)
                } else {
                    // 약관에 동의하지 않았다면 SignUpVC로 이동
                    self?.showSignUpVC()
                }
            } else {
                // 유저 문서가 존재하지 않으면 SignUpVC로 이동
                self?.showSignUpVC()
            }
        }
    }

    private func checkUserInfoExists(userID: String) {
        let db = Firestore.firestore()

        db.collection("infos").whereField("userId", isEqualTo: userID).getDocuments { [weak self] snapshot, error in
            if let error = error {
                print("유저 정보 확인 중 오류 발생: \(error.localizedDescription)")
                self?.showSignUpVC()
                return
            }

            // 유저 정보가 존재하면 TabBar로 이동, 없으면 추가 정보 입력 화면으로 이동
            if let documents = snapshot?.documents, !documents.isEmpty {
                print("UserInfo 문서가 존재합니다. TabBar로 이동합니다.")
                self?.window?.rootViewController = TabBar()
            } else {
                print("UserInfo 문서가 없습니다. AddUserInfoVC로 이동합니다.")
                let addUserInfoVC = AddUserInfoVC(userId: userID)
                let navController = UINavigationController(rootViewController: addUserInfoVC)
                self?.window?.rootViewController = navController
            }
        }
    }

    private func showSignUpVC() {
        let signUpVC = SignUpVC()
        let navController = UINavigationController(rootViewController: signUpVC)
        window?.rootViewController = navController
    }
}
