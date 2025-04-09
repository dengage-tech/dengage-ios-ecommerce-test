//
//  TabBarController.swift
//  DengageEcommerceTest
//
//  Created by Egemen Gülkılık on 18.03.2025.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        configureTabBarAppearance()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartBadge), name: .cartUpdated, object: nil)
    }
    
    func setupTabs() {
        
        let homeVC = HomeViewController()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        let categoriesVC = CategoryListViewController()
        let categoriesNav = UINavigationController(rootViewController: categoriesVC)
        categoriesNav.tabBarItem = UITabBarItem(title: "Categories", image: UIImage(systemName: "list.bullet"), tag: 1)
        
        let cartVC = CartViewController()
        let cartNav = UINavigationController(rootViewController: cartVC)
        cartNav.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(systemName: "cart"), tag: 2)
        updateCartBadgeForTabItem(cartNav.tabBarItem)
        
        let profileVC = ProfileViewController()
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 3)
        
        viewControllers = [homeNav, categoriesNav, cartNav, profileNav]
    }
    
    func configureTabBarAppearance() {
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemBackground
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor.systemBlue
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        } else {
            tabBar.barTintColor = UIColor.systemBackground
            tabBar.tintColor = UIColor.systemBlue
        }
    }
    
    @objc func updateCartBadge() {
        if let viewControllers = viewControllers {
            for vc in viewControllers {
                if let nav = vc as? UINavigationController, nav.tabBarItem.title == "Cart" {
                    updateCartBadgeForTabItem(nav.tabBarItem)
                }
            }
        }
    }
    
    func updateCartBadgeForTabItem(_ item: UITabBarItem) {
        let totalItems = CartManager.shared.items.values.reduce(0, +)
        item.badgeValue = totalItems > 0 ? "\(totalItems)" : nil
    }
}
