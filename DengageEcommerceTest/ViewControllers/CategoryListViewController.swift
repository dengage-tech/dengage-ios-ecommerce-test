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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .singleLine
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
        cell.imageView?.image = UIImage.fromBundle(named: category.imageName)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let category = categories[indexPath.row]
       let productListVC = ProductListViewController(category: category)
       navigationController?.pushViewController(productListVC, animated: true)
    }
}

