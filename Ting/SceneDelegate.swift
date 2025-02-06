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
        // 주석 처리된 코드를 활성화하고 테스트 코드 제거
        checkCurrentUser()
        window?.makeKeyAndVisible()
    }
    
    private func checkCurrentUser() {
        if let currentUser = Auth.auth().currentUser {
            checkUserDocument(userID: currentUser.uid)
        } else {
            // 로그인되지 않은 경우 PermissionVC부터 시작
            let permissionVC = PermissionVC()
            let navController = UINavigationController(rootViewController: permissionVC)
            window?.rootViewController = navController
            window?.makeKeyAndVisible()
        }
    }
    
    private func checkUserDocument(userID: String) {
        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { [weak self] document, _ in
            if let document = document, document.exists {
                if let termsAccepted = document.data()?["termsAccepted"] as? Bool, termsAccepted {
                    self?.window?.rootViewController = TabBar()
                } else {
                    let permissionVC = PermissionVC()
                    let navController = UINavigationController(rootViewController: permissionVC)
                    self?.window?.rootViewController = navController
                }
            } else {
                let permissionVC = PermissionVC()
                let navController = UINavigationController(rootViewController: permissionVC)
                self?.window?.rootViewController = navController
            }
            self?.window?.makeKeyAndVisible()
        }
    }
}
