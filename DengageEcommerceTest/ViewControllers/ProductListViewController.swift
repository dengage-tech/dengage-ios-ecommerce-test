//
//  ProductListViewController.swift
//  DengageEcommerceTest
//
//  Created by Egemen Gülkılık on 18.03.2025.
//

import UIKit
import Dengage

class ProductListViewController: UITableViewController {
    
    let category: Category
    
    init(category: Category) {
        self.category = category
        super.init(style: .plain)
        Dengage.setNavigation(screenName: category.imageName)
        Dengage.pageView(parameters: [
            "page_type": "category",
            "category_id": category.imageName
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = category.name
        tableView.register(ProductCell.self, forCellReuseIdentifier: "ProductCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = 120
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        let product = category.products[indexPath.row]
        cell.configure(with: product)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = category.products[indexPath.row]
        let detailVC = ProductDetailViewController(product: product)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

class ProductCell: UITableViewCell {
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
    
    let productImageView = UIImageView()
    let nameLabel = UILabel()
    let idLabel = UILabel() // New UILabel for product ID
    let priceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        productImageView.contentMode = .scaleAspectFit
        productImageView.clipsToBounds = true
        productImageView.layer.cornerRadius = 10
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        idLabel.font = UIFont.systemFont(ofSize: 14) // Smaller font
        idLabel.textColor = .secondaryLabel
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        
        priceLabel.font = UIFont.systemFont(ofSize: 16)
        priceLabel.textColor = .gray
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, idLabel, priceLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(productImageView)
        cardView.addSubview(stackView)
        contentView.addSubview(cardView)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            productImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            productImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 80),
            productImageView.heightAnchor.constraint(equalToConstant: 80),
            
            stackView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            stackView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
        ])
    }
    
    func configure(with product: Product) {
        productImageView.image = UIImage.fromBundle(named: product.imageName)
        nameLabel.text = product.name
        idLabel.text = product.imageName
        priceLabel.text = "$\(String(format: "%.2f", product.price))"
    }
}
