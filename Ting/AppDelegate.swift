//
//  AppDelegate.swift
//  Ting
//
//  Created by 이재건 on 1/17/25.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Firebase 초기화만 담당
        FirebaseApp.configure()
        return true
    }
}
