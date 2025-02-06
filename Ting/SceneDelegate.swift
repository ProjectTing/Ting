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
            checkUserDocument(userID: currentUser.uid)
        } else {
            showPermissionVC()  // 로그인되지 않은 경우 PermissionVC로 이동
        }
    }

    private func checkUserDocument(userID: String) {
        let db = Firestore.firestore()

        db.collection("users").document(userID).getDocument { [weak self] document, _ in
            if let document = document, document.exists {
                let termsAccepted = document.data()?["termsAccepted"] as? Bool ?? false
                
                if termsAccepted {
                    // 유저 정보가 입력되었는지 추가로 확인
                    self?.checkUserInfoExists(userID: userID)
                } else {
                    self?.showPermissionVC()
                }
            } else {
                self?.showPermissionVC()
            }
        }
    }

    private func checkUserInfoExists(userID: String) {
        let db = Firestore.firestore()

        db.collection("users").whereField("id", isEqualTo: userID).getDocuments { [weak self] snapshot, error in
            if let error = error {
                print("유저 정보 확인 중 오류 발생: \(error.localizedDescription)")
                self?.showPermissionVC()
                return
            }

            // 유저 정보가 존재하면 TabBar로 이동, 아니면 AddUserInfoVC로 이동
            if let documents = snapshot?.documents, !documents.isEmpty {
                print("UserInfo 문서가 존재합니다. TabBar로 이동합니다.")
                self?.window?.rootViewController = TabBar()
            } else {
                print("UserInfo 문서가 없습니다. AddUserInfoVC로 이동합니다.")
                let addUserInfoVC = AddUserInfoVC(userId: userID)  // userId 전달
                let navController = UINavigationController(rootViewController: addUserInfoVC)
                self?.window?.rootViewController = navController
            }
        }
    }

    private func showPermissionVC() {
        let permissionVC = PermissionVC()
        let navController = UINavigationController(rootViewController: permissionVC)
        window?.rootViewController = navController
    }
}
