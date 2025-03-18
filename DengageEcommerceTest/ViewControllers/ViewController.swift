//
//  ViewController.swift
//  DengageEcommerceTest
//
//  Created by Egemen Gülkılık on 18.03.2025.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

import UIKit

// MARK: - Models

struct Product: Hashable {
    let id: Int
    let name: String
    let price: Double
    let imageName: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }

    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}


struct Category {
    let id: Int
    let name: String
    let imageName: String
    let products: [Product]
}

// MARK: - Dummy Data Provider

class DataProvider {
    static let shared = DataProvider()
    
    // Creates 5 categories, each with 3 products and associated images
    let categories: [Category] = {
        var categories = [Category]()
        for catIndex in 1...5 {
            var products = [Product]()
            for prodIndex in 1...3 {
                let product = Product(
                    id: prodIndex,
                    name: "Product \(prodIndex)",
                    price: Double.random(in: 10...100),
                    imageName: "product_\(catIndex)_\(prodIndex)" // Make sure this image exists in assets
                )
                products.append(product)
            }
            let category = Category(
                id: catIndex,
                name: "Category \(catIndex)",
                imageName: "category_\(catIndex)", // Make sure this image exists in assets
                products: products
            )
            categories.append(category)
        }
        return categories
    }()
}

// MARK: - User Management

class UserManager {
    static let shared = UserManager()
    
    private let isLoggedInKey = "isLoggedIn"
    private let usernameKey = "username"

    var isLoggedIn: Bool {
        get { UserDefaults.standard.bool(forKey: isLoggedInKey) }
        set { UserDefaults.standard.set(newValue, forKey: isLoggedInKey) }
    }
    
    var currentUsername: String? {
        return UserDefaults.standard.string(forKey: usernameKey)
    }

    func login(username: String, password: String, completion: (Bool) -> Void) {
        if username == "egemen" && password == "password" {
            isLoggedIn = true
            UserDefaults.standard.set(username, forKey: usernameKey)
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func logout() {
        isLoggedIn = false
        UserDefaults.standard.removeObject(forKey: usernameKey)
    }
}


// MARK: - Cart Management

extension Notification.Name {
    static let cartUpdated = Notification.Name("cartUpdated")
}

class CartManager {
    static let shared = CartManager()
    
    private(set) var items: [Product: Int] = [:] { // Dictionary to store product and its quantity
        didSet {
            NotificationCenter.default.post(name: .cartUpdated, object: nil)
        }
    }
    
    func add(product: Product, quantity: Int) {
        if let currentQuantity = items[product] {
            items[product] = currentQuantity + quantity // Increment quantity
        } else {
            items[product] = quantity // Add new item
        }
    }
    
    func updateQuantity(for product: Product, quantity: Int) {
        if quantity > 0 {
            items[product] = quantity
        } else {
            items.removeValue(forKey: product) // Remove if quantity is 0
        }
    }
    
    func remove(product: Product) {
        items.removeValue(forKey: product)
    }
    
    func clearCart() {
        items.removeAll()
    }
}









class CheckoutViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Checkout"
        view.backgroundColor = UIColor.systemBackground
        // Add checkout form and additional UI as needed.
    }
}

