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
        addTopBorderToTabBar()
        
        // Observe cart updates to update badge count
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartBadge), name: .cartUpdated, object: nil)
    }
    
    func setupTabs() {
        // Categories tab
        let categoriesVC = CategoryListViewController()
        let categoriesNav = UINavigationController(rootViewController: categoriesVC)
        categoriesNav.tabBarItem = UITabBarItem(title: "Categories", image: UIImage(systemName: "list.bullet"), tag: 0)
        
        // Cart tab
        let cartVC = CartViewController()
        let cartNav = UINavigationController(rootViewController: cartVC)
        cartNav.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(systemName: "cart"), tag: 1)
        updateCartBadgeForTabItem(cartNav.tabBarItem)
        
        // Profile tab
        let profileVC = ProfileViewController()
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 2)

        viewControllers = [categoriesNav, cartNav, profileNav]
    }
    
    func addTopBorderToTabBar() {
        let border = UIView()
        border.backgroundColor = UIColor.lightGray // Change color as needed
        border.translatesAutoresizingMaskIntoConstraints = false
        tabBar.addSubview(border)
        
        NSLayoutConstraint.activate([
            border.topAnchor.constraint(equalTo: tabBar.topAnchor),
            border.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            border.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            border.heightAnchor.constraint(equalToConstant: 0.5) // Adjust thickness
        ])
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
        let totalItems = CartManager.shared.items.values.reduce(0, +) // Sum of all quantities
        item.badgeValue = totalItems > 0 ? "\(totalItems)" : nil
    }

}
