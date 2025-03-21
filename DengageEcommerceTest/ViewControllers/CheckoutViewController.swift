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
                Product(id: 6, name: "adidas Women's Sneaker", price: 44.99, imageName: "product_06")
            ]
        ),
        Category(
            id: 3,
            name: "Games",
            imageName: "category_03",
            products: [
                Product(id: 7, name: "PlayStation 5 console (slim)", price: 469.99, imageName: "product_07"),
                Product(id: 8, name: "Silent Hill 2 (PS5)", price: 59.60, imageName: "product_08"),
                Product(id: 9, name: "PDP Victrix Controller", price: 155.00, imageName: "product_09")
            ]
        ),
        Category(
            id: 4,
            name: "Laptops",
            imageName: "category_04",
            products: [
                Product(id: 10, name: "Lenovo E14 Laptop", price: 729.99, imageName: "product_10"),
                Product(id: 11, name: "2025 MacBook AirLaptop", price: 1579.99, imageName: "product_11"),
                Product(id: 12, name: "UtechSmart Wireless Mouse", price: 47.99, imageName: "product_12")
            ]
        )
    ]
    
    func findProductById(_ id: Int) -> Product? {
        for category in categories {
            for product in category.products {
                if product.id == id {
                    return product
                }
            }
        }
        return nil
    }
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
    
    func login(username: String, completion: (Bool) -> Void) {
        if username.isEmpty {
            completion(false)
        } else {
            isLoggedIn = true
            UserDefaults.standard.set(username, forKey: usernameKey)
            completion(true)
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
    
    private let cartUserDefaultsKey = "cartItems"
    
    private(set) var items: [Product: Int] = [:] {
        didSet {
            NotificationCenter.default.post(name: .cartUpdated, object: nil)
            saveCartToUserDefaults()
        }
    }
    
    private init() {
        loadCartFromUserDefaults()
    }
    
    func add(product: Product, quantity: Int) {
        let currentQuantity = items[product] ?? 0
        let newQuantity = currentQuantity + quantity
        items[product] = min(newQuantity, 10) // Cap at 10
    }
    
    func updateQuantity(for product: Product, quantity: Int) {
        let clamped = min(quantity, 10)
        if clamped > 0 {
            items[product] = clamped
        } else {
            items.removeValue(forKey: product)
        }
    }
    
    func remove(product: Product) {
        items.removeValue(forKey: product)
    }
    
    func clearCart() {
        items.removeAll()
    }
    
    private func saveCartToUserDefaults() {
        var dictToSave: [String: Int] = [:]
        for (product, quantity) in items {
            dictToSave[String(product.id)] = quantity
        }
        UserDefaults.standard.set(dictToSave, forKey: cartUserDefaultsKey)
    }
    
    private func loadCartFromUserDefaults() {
        guard let savedData = UserDefaults.standard.dictionary(forKey: cartUserDefaultsKey) as? [String: Int] else {
            return
        }
        
        var loadedItems: [Product: Int] = [:]
        for (productIDString, quantity) in savedData {
            if let productID = Int(productIDString),
               let product = DataProvider.shared.findProductById(productID) {
                loadedItems[product] = quantity
            }
        }
        self.items = loadedItems
    }
}




class CheckoutViewController: UIViewController {
    
    let summaryLabel = UILabel()
    let placeOrderButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Checkout"
        view.backgroundColor = .systemBackground
        
        summaryLabel.numberOfLines = 0
        summaryLabel.textAlignment = .left
        summaryLabel.font = UIFont.systemFont(ofSize: 16)
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        placeOrderButton.setTitle("Place Order", for: .normal)
        placeOrderButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        placeOrderButton.backgroundColor = .systemGreen
        placeOrderButton.setTitleColor(.white, for: .normal)
        placeOrderButton.layer.cornerRadius = 8
        placeOrderButton.translatesAutoresizingMaskIntoConstraints = false
        placeOrderButton.addTarget(self, action: #selector(didTapPlaceOrder), for: .touchUpInside)
        
        view.addSubview(summaryLabel)
        view.addSubview(placeOrderButton)
        
        NSLayoutConstraint.activate([
            summaryLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            summaryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            summaryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            placeOrderButton.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 20),
            placeOrderButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeOrderButton.widthAnchor.constraint(equalToConstant: 200),
            placeOrderButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        populateSummary()
    }
    
    private func populateSummary() {
        let items = CartManager.shared.items
        if items.isEmpty {
            summaryLabel.text = "Your cart is empty!"
            placeOrderButton.isEnabled = false
            placeOrderButton.alpha = 0.5
        } else {
            placeOrderButton.isEnabled = true
            placeOrderButton.alpha = 1.0
            
            var summaryText = "Your Items:\n"
            var total: Double = 0
            
            for (product, quantity) in items {
                summaryText += "• \(product.name) (x\(quantity))\n"
                total += product.price * Double(quantity)
            }
            summaryText += "\nTotal: $\(String(format: "%.2f", total))"
            
            summaryLabel.text = summaryText
        }
    }
    
    @objc private func didTapPlaceOrder() {
        // Clear the cart
        CartManager.shared.clearCart()
        
        let alert = UIAlertController(
            title: "Order Placed",
            message: "Your order has been placed successfully!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
}
