//
//  SignInViewController.swift
//  ChatApp
//
//  Created by Gwinyai Nyatsoka on 21/7/2023.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var createAccountTextView: UITextView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.clipsToBounds = true
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let attributeString = NSMutableAttributedString(string: "Don't have an account? Create an account here.", attributes: [.font: Font.caption])
        attributeString.addAttribute(.link, value: "chatapp://createaccount", range: (attributeString.string as NSString).range(of: "Create an account here."))
        createAccountTextView.attributedText = attributeString
        createAccountTextView.linkTextAttributes = [.font: Font.linkLabel,.foregroundColor: UIColor.secondary]
        createAccountTextView.delegate = self
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.layer.cornerRadius = 20
    }

    @IBAction func signinButtonTapped(_ sender: Any) {
        
    }

}

extension SignInViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if URL.scheme == "chatapp" {
            performSegue(withIdentifier: "CreateAccountSegue", sender: nil)
        }
        
        return false
    }
}
