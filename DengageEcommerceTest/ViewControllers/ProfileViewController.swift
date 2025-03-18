//
//  ProfileViewController.swift
//  DengageEcommerceTest
//
//  Created by Egemen Gülkılık on 18.03.2025.
//

import UIKit

class ProfileViewController: UITableViewController {
    
    let user = UserManager.shared.currentUsername ?? "Guest"
    
    let fields = ["Username", "Email", "Phone"]
    var values = ["User123", "user@example.com", "+1 (555) 123-4567"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        tableView = UITableView(frame: .zero, style: .insetGrouped) // Modern form style
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "logoutCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // User Info & Logout Button
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? fields.count : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = fields[indexPath.row]
            cell.detailTextLabel?.text = values[indexPath.row]
            cell.accessoryType = .disclosureIndicator
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "logoutCell", for: indexPath)
            cell.textLabel?.text = "Logout"
            cell.textLabel?.textColor = .red
            cell.textLabel?.textAlignment = .center
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            editField(at: indexPath.row)
        } else {
            handleLogout()
        }
    }
    
    func editField(at index: Int) {
        let alert = UIAlertController(title: "Edit \(fields[index])", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = self.values[index]
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            if let newValue = alert.textFields?.first?.text, !newValue.isEmpty {
                self.values[index] = newValue
                self.tableView.reloadData()
            }
        }))
        present(alert, animated: true)
    }
    
    func handleLogout() {
        UserManager.shared.logout()
        
        let loginVC = LoginViewController()
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = loginVC
        }
    }
}
