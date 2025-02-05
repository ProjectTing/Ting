//
//  AppDelegate.swift
//  Ting
//
//  Created by 이재건 on 1/17/25.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()  // Firebase 초기화

        window = UIWindow(frame: UIScreen.main.bounds)
        
        // 약관 동의 및 로그인 상태 확인
        checkAgreementAndLoginStatus { isAgreedAndLoggedIn in
            if isAgreedAndLoggedIn {
                // 약관 동의 및 로그인 완료 -> TabBar로 이동
                let tabBarVC = TabBar()
                self.window?.rootViewController = tabBarVC
            } else {
                // 약관 동의 또는 로그인 필요 -> SignUpViewController로 이동
                let signUpVC = SignUpViewController()
                self.window?.rootViewController = signUpVC
            }
            self.window?.makeKeyAndVisible()
        }

        return true
    }

    // MARK: - 약관 동의 및 로그인 상태 확인
    private func checkAgreementAndLoginStatus(completion: @escaping (Bool) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(false)  // 로그인된 유저가 없으면 약관 동의 창으로 이동
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { document, error in
            if let document = document, document.exists {
                if let termsAccepted = document.data()?["termsAccepted"] as? Bool {
                    completion(termsAccepted)  // 약관 동의 여부에 따라 분기
                } else {
                    completion(false)  // 약관 동의 기록이 없으면 창을 띄움
                }
            } else {
                completion(false)  // 문서가 존재하지 않음
            }
        }
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}

