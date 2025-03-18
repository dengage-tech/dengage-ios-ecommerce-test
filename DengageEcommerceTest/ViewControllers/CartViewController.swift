//
//  CartViewController.swift
//  DengageEcommerceTest
//
//  Created by Egemen Gülkılık on 18.03.2025.
//

import UIKit

class CartViewController: UITableViewController {
    
    var cartItems: [(product: Product, quantity: Int)] {
        return CartManager.shared.items.map { ($0.key, $0.value) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cart"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        NotificationCenter.default.addObserver(self, selector: #selector(cartUpdated), name: .cartUpdated, object: nil)
    }
    
    @objc func cartUpdated() {
        tableView.reloadData()
        updateCartBadge()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let cartItem = cartItems[indexPath.row]
        
        cell.textLabel?.text = "\(cartItem.product.name) - \(cartItem.quantity) pcs - $\(String(format: "%.2f", cartItem.product.price * Double(cartItem.quantity)))"
        cell.imageView?.image = UIImage(named: cartItem.product.imageName)
        
        // Create quantity picker
        let quantityStepper = UIStepper()
        quantityStepper.minimumValue = 1
        quantityStepper.maximumValue = 10
        quantityStepper.value = Double(cartItem.quantity)
        quantityStepper.tag = indexPath.row
        quantityStepper.addTarget(self, action: #selector(quantityChanged(_:)), for: .valueChanged)
        
        cell.accessoryView = quantityStepper
        return cell
    }
    
    @objc func quantityChanged(_ sender: UIStepper) {
        let rowIndex = sender.tag
        let cartItem = cartItems[rowIndex]
        CartManager.shared.updateQuantity(for: cartItem.product, quantity: Int(sender.value))
        updateCartBadge()
    }
    
    func updateCartBadge() {
        if let tabBarItems = tabBarController?.tabBar.items {
            for item in tabBarItems {
                if item.title == "Cart" {
                    let totalItems = CartManager.shared.items.values.reduce(0, +) // Sum of all quantities
                    item.badgeValue = totalItems > 0 ? "\(totalItems)" : nil
                }
            }
        }
    }
}
