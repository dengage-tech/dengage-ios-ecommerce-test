//
//  ProductDetailViewController.swift
//  DengageEcommerceTest
//
//  Created by Egemen Gülkılık on 18.03.2025.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    let product: Product
    let imageView = UIImageView()
    let nameLabel = UILabel()
    let priceLabel = UILabel()
    let quantityPicker = UIPickerView()
    let addToCartButton = UIButton(type: .system)
    
    var selectedQuantity = 1 // Default quantity

    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
        title = product.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        setupViews()
    }
    
    func setupViews() {
        imageView.image = UIImage.fromBundle(named: product.imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.text = product.name
        nameLabel.font = UIFont.boldSystemFont(ofSize: 22)
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        priceLabel.text = "$\(String(format: "%.2f", product.price))"
        priceLabel.font = UIFont.systemFont(ofSize: 20)
        priceLabel.textAlignment = .center
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure Quantity Picker
        quantityPicker.translatesAutoresizingMaskIntoConstraints = false
        quantityPicker.dataSource = self
        quantityPicker.delegate = self
        
        // Configure Add to Cart Button
        addToCartButton.setTitle("Add to Cart", for: .normal)
        addToCartButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        addToCartButton.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(priceLabel)
        view.addSubview(quantityPicker)
        view.addSubview(addToCartButton)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            quantityPicker.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 20),
            quantityPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            quantityPicker.widthAnchor.constraint(equalToConstant: 100),
            quantityPicker.heightAnchor.constraint(equalToConstant: 100),
            
            addToCartButton.topAnchor.constraint(equalTo: quantityPicker.bottomAnchor, constant: 20),
            addToCartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func addToCart() {
        CartManager.shared.add(product: product, quantity: selectedQuantity)
        let alert = UIAlertController(title: "Success", message: "Added \(selectedQuantity) to cart", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UIPickerView DataSource & Delegate
extension ProductDetailViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10 // Allow selection of 1-10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedQuantity = row + 1
    }
}
