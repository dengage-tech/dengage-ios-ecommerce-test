import UIKit
import WebKit
import Dengage

let STORY_VIEW_TAG = 1453
let INLINE_VIEW_TAG = 1789

class HomeViewController: UIViewController {
    
    var webView1: InAppInlineElementView = {
        let wv = InAppInlineElementView(frame: .zero)
        wv.translatesAutoresizingMaskIntoConstraints = false
        wv.contentMode = .scaleAspectFit
        wv.autoresizesSubviews = true
        wv.tag = INLINE_VIEW_TAG
        wv.layer.zPosition = 100
        return wv
    }()
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [])
        sv.axis = .vertical
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 10
        return sv
    }()
    
    var storiesListView: StoriesListView?
    private var webViewHeightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        if let viewWithTag = stackView.viewWithTag(STORY_VIEW_TAG) {
            viewWithTag.removeFromSuperview()
        }
        
        Dengage.showAppStory(storyPropertyID: "story", screenName: "home", customParams: [:]) { storyView in
            if let storyView = storyView {
                self.storiesListView = storyView
                self.storiesListView?.translatesAutoresizingMaskIntoConstraints = false
                self.storiesListView?.tag = STORY_VIEW_TAG
                self.storiesListView?.backgroundColor = .secondarySystemBackground
                self.stackView.addArrangedSubview(storyView)
            }
            
            self.stackView.addArrangedSubview(self.webView1)
            self.webViewHeightConstraint = self.webView1.heightAnchor.constraint(equalToConstant: 500)
            self.webViewHeightConstraint?.isActive = true
            
            Dengage.showInAppInLine(propertyID: "inline",
                                     inAppInlineElement: self.webView1,
                                     screenName: "home",
                                     customParams: [:],
                                     hideIfNotFound: true)
            
            // Insert webView1 into the stack view and add a temporary height constraint.
            
            
            // Adjust the height based on the web content.
            //self.updateWebViewHeight()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Dengage.removeInAppMessageDisplay()
    }
    
    private func setupUI() {
        title = "App Story"
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaTopAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    private func updateWebViewHeight() {
        self.webView1.evaluateJavaScript("document.body.scrollHeight") { [weak self] (result, error) in
            guard let self = self, let height = result as? CGFloat else { return }
            self.webViewHeightConstraint?.constant = height
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}

// MARK: - Safe Area Layout
public extension UIView {
    var safeAreaTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        } else {
            return topAnchor
        }
    }
}
