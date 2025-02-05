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

        // 로그인 및 약관 동의 상태 확인
        if let currentUser = Auth.auth().currentUser {
            checkAgreementStatus(userID: currentUser.uid) { isAgreed in
                if isAgreed {
                    // 약관 동의 및 로그인 완료된 사용자 → TabBar로 이동
                    self.window?.rootViewController = TabBar()
                } else {
                    // 로그인했지만 약관 동의가 되지 않은 사용자 → PermissionVC로 이동
                    self.window?.rootViewController = PermissionVC()
                }
                self.window?.makeKeyAndVisible()
            }
        } else {
            // 로그인되지 않은 사용자 → PermissionVC로 이동
            self.window?.rootViewController = PermissionVC()
            self.window?.makeKeyAndVisible()
        }
    }

    private func checkAgreementStatus(userID: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { document, error in
            if let document = document, document.exists {
                if let termsAccepted = document.data()?["termsAccepted"] as? Bool {
                    completion(termsAccepted)
                } else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
    }
}

