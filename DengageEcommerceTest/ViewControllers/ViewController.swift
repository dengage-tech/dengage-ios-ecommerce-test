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

    let categories: [Category] = [
        Category(
            id: 1,
            name: "Phones",
            imageName: "category_01",
            products: [
                Product(id: 1, name: "iPhone 16 Pro Max", price: 1199.99, imageName: "product_01"),
                Product(id: 2, name: "Samsung Galaxy A35", price: 399.99, imageName: "product_02"),
                Product(id: 3, name: "Samsung Galaxy S24 Ultra", price: 845.99, imageName: "product_03")
            ]
        ),
        Category(
            id: 2,
            name: "Sports",
            imageName: "category_02",
            products: [
                Product(id: 4, name: "Spalding TF-1000", price: 79.99, imageName: "product_04"),
                Product(id: 5, name: "Bushnell Velocity Speed Gun", price: 119.99, imageName: "product_05"),
                Product(id: 6, name: "adidas Women's Ultrarun 5 Running Sneaker", price: 44.99, imageName: "product_06")
            ]
        ),
        Category(
            id: 3,
            name: "Games",
            imageName: "category_03",
            products: [
                Product(id: 7, name: "PlayStation 5 console (slim)", price: 469.99, imageName: "product_07"),
                Product(id: 8, name: "Silent Hill 2 (PS5)", price: 59.60, imageName: "product_08"),
                Product(id: 9, name: "PDP Victrix Pro BFG Wireless Gaming Controller", price: 155.00, imageName: "product_09")
            ]
        ),
        Category(
            id: 4,
            name: "Laptops",
            imageName: "category_04",
            products: [
                Product(id: 10, name: "Lenovo ThinkPad E14 Gen 5 Business Laptop", price: 729.99, imageName: "product_10"),
                Product(id: 11, name: "Apple 2025 MacBook Air 15-inch Laptop", price: 1579.99, imageName: "product_11"),
                Product(id: 12, name: "UtechSmart Venus Pro RGB Wireless MMO Gaming Mouse", price: 47.99, imageName: "product_12")
            ]
        )
    ]
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

