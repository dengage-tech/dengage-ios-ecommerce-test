//
//  ProductListViewController.swift
//  DengageEcommerceTest
//
//  Created by Egemen Gülkılık on 18.03.2025.
//

import UIKit

class ProductListViewController: UITableViewController {
    
    let category: Category
    
    init(category: Category) {
        self.category = category
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = category.name
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let product = category.products[indexPath.row]
        cell.textLabel?.text = "\(product.name) - $\(String(format: "%.2f", product.price))"
        cell.imageView?.image = UIImage(named: product.imageName)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = category.products[indexPath.row]
        let detailVC = ProductDetailViewController(product: product)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}


