//
//  CartViewController.swift
//  DengageEcommerceTest
//
//  Created by Egemen Gülkılık on 18.03.2025.
//

import UIKit


class CartItemCell: UITableViewCell {
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 2 // allow wrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let quantityStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.maximumValue = 10
        stepper.translatesAutoresizingMaskIntoConstraints = false
        return stepper
    }()
    
    var quantityChanged: ((Double) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupViews()
        quantityStepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(cardView)
        cardView.addSubview(productImageView)
        cardView.addSubview(detailsLabel)
        cardView.addSubview(quantityStepper)
        
        NSLayoutConstraint.activate([
            // Make the cardView fill the entire cell height (with slight horizontal margins)
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            // Product Image
            productImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10),
            productImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            productImageView.widthAnchor.constraint(equalToConstant: 60),
            productImageView.heightAnchor.constraint(equalToConstant: 60),
            
            // Stepper in the top-right corner
            quantityStepper.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10),
            quantityStepper.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            
            // Details Label
            detailsLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10),
            detailsLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 15),
            detailsLabel.trailingAnchor.constraint(equalTo: quantityStepper.leadingAnchor, constant: -10),
            detailsLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10),
            
            // Allow image & stepper to not exceed bottom if text is taller
            productImageView.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -10),
            quantityStepper.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with product: Product, quantity: Int) {
        productImageView.image = UIImage.fromBundle(named: product.imageName)
        detailsLabel.text = "\(product.name)\n\(quantity) pcs - $\(String(format: "%.2f", product.price * Double(quantity)))"
        quantityStepper.value = Double(quantity)
    }
    
    @objc private func stepperValueChanged(_ sender: UIStepper) {
        quantityChanged?(sender.value)
    }
}




class CartViewController: UITableViewController {
    
    var cartItems: [(product: Product, quantity: Int)] {
        return CartManager.shared.items.map { ($0.key, $0.value) }
    }
    
    // UI references for the footer
    private var totalLabel: UILabel?
    private var checkoutButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cart"
        
        // Self-sizing for multiline product names
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        
        tableView.register(CartItemCell.self, forCellReuseIdentifier: "CartItemCell")
        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle = .none
        
        // Observe cart changes
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(cartUpdated),
                                               name: .cartUpdated,
                                               object: nil)
        
        // Set up table footer with total price & checkout button
        setupFooterView()
        refreshFooter()  // Initialize footer text & button state
    }
    
    private func setupFooterView() {
        let footerHeight: CGFloat = 100
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: footerHeight))
        footerView.backgroundColor = .clear
        
        let totalLabel = UILabel()
        totalLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        totalLabel.textAlignment = .left
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let checkoutButton = UIButton(type: .system)
        checkoutButton.setTitle("Proceed to Checkout", for: .normal)
        checkoutButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        checkoutButton.backgroundColor = .systemBlue
        checkoutButton.setTitleColor(.white, for: .normal)
        checkoutButton.layer.cornerRadius = 8
        checkoutButton.translatesAutoresizingMaskIntoConstraints = false
        checkoutButton.addTarget(self, action: #selector(didTapCheckout), for: .touchUpInside)
        
        footerView.addSubview(totalLabel)
        footerView.addSubview(checkoutButton)
        tableView.tableFooterView = footerView
        
        self.totalLabel = totalLabel
        self.checkoutButton = checkoutButton
        
        // Layout constraints
        NSLayoutConstraint.activate([
            // Total label on the left
            totalLabel.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            totalLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            totalLabel.widthAnchor.constraint(equalToConstant: 200),
            
            // Checkout button on the right
            checkoutButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            checkoutButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            checkoutButton.heightAnchor.constraint(equalToConstant: 40),
            checkoutButton.widthAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    @objc func cartUpdated() {
        tableView.reloadData()
        updateCartBadge()
        refreshFooter()  // Update total price & button state
    }
    
    // MARK: - Table Data Source
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell",
                                                       for: indexPath) as? CartItemCell else {
            return UITableViewCell()
        }
        
        let cartItem = cartItems[indexPath.row]
        cell.configure(with: cartItem.product, quantity: cartItem.quantity)
        
        // Called when the user changes the quantity via stepper
        cell.quantityChanged = { [weak self] newQuantity in
            CartManager.shared.updateQuantity(for: cartItem.product, quantity: Int(newQuantity))
            self?.updateCartBadge()
        }
        return cell
    }
    
    // MARK: - Swipe to Delete
    
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
                            -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            
            let cartItem = self.cartItems[indexPath.row]
            // Remove product from cart
            CartManager.shared.remove(product: cartItem.product)
            
            completionHandler(true)
        }
        deleteAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    // MARK: - Checkout
    
    @objc private func didTapCheckout() {
        let checkoutVC = CheckoutViewController()
        navigationController?.pushViewController(checkoutVC, animated: true)
    }
    
    // MARK: - Footer Helpers
    
    private func refreshFooter() {
        // Calculate total price
        var total: Double = 0
        for (product, quantity) in CartManager.shared.items {
            total += product.price * Double(quantity)
        }
        totalLabel?.text = String(format: "Total: $%.2f", total)
        
        // If cart is empty, disable the checkout button
        let isCartEmpty = cartItems.isEmpty
        checkoutButton?.isEnabled = !isCartEmpty
        checkoutButton?.alpha = isCartEmpty ? 0.5 : 1.0
    }
    
    // MARK: - Badge
    
    func updateCartBadge() {
        if let tabBarItems = tabBarController?.tabBar.items {
            for item in tabBarItems where item.title == "Cart" {
                let totalItems = CartManager.shared.items.values.reduce(0, +)
                item.badgeValue = totalItems > 0 ? "\(totalItems)" : nil
            }
        }
    }
}
