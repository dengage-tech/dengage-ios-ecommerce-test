//
//  CategoryListViewController.swift
//  DengageEcommerceTest
//
//  Created by Egemen Gülkılık on 18.03.2025.
//

import UIKit

class CategoryListViewController: UITableViewController {
    
    let categories = DataProvider.shared.categories
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Categories"
        tableView.register(CategoryCell.self, forCellReuseIdentifier: "CategoryCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = 120
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        let category = categories[indexPath.row]
        cell.configure(with: category)
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        let productListVC = ProductListViewController(category: category)
        navigationController?.pushViewController(productListVC, animated: true)
    }
}

class CategoryCell: UITableViewCell {
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
    
    let categoryImageView = UIImageView()
    let nameLabel = UILabel()
    let idLabel = UILabel()
    
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
        categoryImageView.contentMode = .scaleAspectFit
        categoryImageView.clipsToBounds = true
        categoryImageView.layer.cornerRadius = 10
        categoryImageView.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        idLabel.font = UIFont.systemFont(ofSize: 14) // Smaller font
        idLabel.textColor = .secondaryLabel
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, idLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(categoryImageView)
        cardView.addSubview(stackView)
        contentView.addSubview(cardView)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            categoryImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            categoryImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            categoryImageView.widthAnchor.constraint(equalToConstant: 80),
            categoryImageView.heightAnchor.constraint(equalToConstant: 80),
            
            stackView.leadingAnchor.constraint(equalTo: categoryImageView.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            stackView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
        ])
    }
    
    func configure(with category: Category) {
        categoryImageView.image = UIImage.fromBundle(named: category.imageName)
        nameLabel.text = category.name
        idLabel.text = category.imageName
    }
}
