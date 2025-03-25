//
//  ProductDetailViewController.swift
//  DengageEcommerceTest
//
//  Created by Egemen Gülkılık on 18.03.2025.
//

import UIKit
import Dengage

class ProductDetailViewController: UIViewController {
    
    let product: Product
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let idLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let quantityLabel: UILabel = {
        let label = UILabel()
        label.text = "Quantity:"
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let quantityPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add to Cart", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var selectedQuantity = 1
    
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
        title = product.name
        Dengage.setNavigation(screenName: product.imageName)
        Dengage.pageView(parameters: [
            "page_type": "product",
            "category_id": product.imageName
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupScrollView()
        setupViews()
        setupConstraints()
    }
    
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            // ScrollView constraints
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            // Ensuring vertical scrolling by matching the width
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    func setupViews() {
        productImageView.image = UIImage.fromBundle(named: product.imageName)
        nameLabel.text = product.name
        idLabel.text = product.imageName

        priceLabel.text = "$\(String(format: "%.2f", product.price))"
        
        quantityPicker.dataSource = self
        quantityPicker.delegate = self
        
        contentView.addSubview(productImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(idLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(quantityLabel)
        contentView.addSubview(quantityPicker)
        contentView.addSubview(addToCartButton)
        addToCartButton.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            productImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 250),
            productImageView.heightAnchor.constraint(equalToConstant: 250),
            
            nameLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            idLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            idLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            idLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            priceLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 10),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            quantityLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 20),
            quantityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            quantityPicker.topAnchor.constraint(equalTo: quantityLabel.bottomAnchor, constant: 10),
            quantityPicker.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            quantityPicker.widthAnchor.constraint(equalToConstant: 150),
            quantityPicker.heightAnchor.constraint(equalToConstant: 100),
            
            addToCartButton.topAnchor.constraint(equalTo: quantityPicker.bottomAnchor, constant: 20),
            addToCartButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            addToCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            addToCartButton.heightAnchor.constraint(equalToConstant: 50),
            addToCartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    @objc func addToCart() {
        CartManager.shared.add(product: product, quantity: selectedQuantity)
        let params: [String: Any] = [
            "product_id": product.id,
            "product_variant_id": product.id,
            "quantity": selectedQuantity,
            "unit_price": product.price,
            "discounted_price": product.price
        ]
        Dengage.addToCart(parameters : params)
    }
}

// MARK: - UIPickerView DataSource & Delegate
extension ProductDetailViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { 10 }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        "\(row + 1)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedQuantity = row + 1
    }
}
