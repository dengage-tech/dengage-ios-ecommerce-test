//
//  SceneDelegate.swift
//  DengageEcommerceTest
//
//  Created by Egemen Gülkılık on 18.03.2025.
//



import UIKit

// MARK: - SceneDelegate (for iOS 13+)

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        
        // Show MainTabBarController if logged in; otherwise, show LoginViewController.
        let rootVC: UIViewController
        if UserManager.shared.isLoggedIn {
            rootVC = TabBarController()
        } else {
            rootVC = LoginViewController()
        }
        
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }
}
