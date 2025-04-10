//
//  ProfileViewController.swift
//  DengageEcommerceTest
//
//  Created by Egemen Gülkılık on 18.03.2025.
//

import UIKit
import Dengage

class ProfileViewController: UITableViewController {
    
    let user = UserManager.shared.currentUsername ?? "Guest"
    
    let fields = ["Username", "Device Token", "Device Id"]
    var values: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "logoutCell")
        let username = UserManager.shared.currentUsername ?? "Guest"
        values = [username, Dengage.getDeviceToken() ?? "", Dengage.getDeviceId() ?? ""]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // User Info & Logout Button
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? fields.count : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            cell.textLabel?.text = fields[indexPath.row]
            cell.detailTextLabel?.text = values[indexPath.row]
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.selectionStyle = .none
            
            cell.detailTextLabel?.isUserInteractionEnabled = true
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(copyFieldText(_:)))
            cell.detailTextLabel?.addGestureRecognizer(longPress)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "logoutCell", for: indexPath)
            cell.textLabel?.text = "Logout"
            cell.textLabel?.textColor = .red
            cell.textLabel?.textAlignment = .center
            return cell
        }
    }

    
    
    @objc func copyFieldText(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began,
              let label = gesture.view as? UILabel,
              let text = label.text else { return }

        UIPasteboard.general.string = text
        
        let alert = UIAlertController(title: nil, message: "Copied: \(text)", preferredStyle: .alert)
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            alert.dismiss(animated: true)
        }
    }



    
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            // Only allow editing for Email or Phone (row 1 or 2).
            if indexPath.row != 0 {
                //editField(at: indexPath.row)
            }
        } else {
            // Logout
            handleLogout()
        }
    }
    
    private func editField(at index: Int) {
        let alert = UIAlertController(title: "Edit \(fields[index])",
                                      message: nil,
                                      preferredStyle: .alert)
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
    
    private func handleLogout() {
        CartManager.shared.clearCart()
        UserManager.shared.logout()
        
        let loginVC = LoginViewController()
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = loginVC
        }
    }
}
