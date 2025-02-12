//
//  LoginCheck+Alert.swift
//  Ting
//
//  Created by Watson22_YJ on 2/10/25.
//

import UIKit

extension UIViewController {
    
    func loginCheck() -> Bool {
        /// 유저디폴트에 userId 있는지 확인 - 로그인했는지 확인
        guard UserDefaults.standard.string(forKey: "userId") != nil else {
            
            /// 비로그인일 경우 알럿
            let alert = UIAlertController(title: "로그인이 필요합니다.", message: "로그인을 하시겠습니까?", preferredStyle: .alert)
            
            let confirm = UIAlertAction(title: "확인", style: .default) { _ in
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    let signupVC = SignUpVC()
                    let navigationController = UINavigationController(rootViewController: signupVC)
                    
                    sceneDelegate.window?.rootViewController = navigationController
                    sceneDelegate.window?.makeKeyAndVisible()
                }
            }
            
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(confirm)
            alert.addAction(cancel)
            self.present(alert, animated: true)
            
            return false
        }
        return true
    }
}
