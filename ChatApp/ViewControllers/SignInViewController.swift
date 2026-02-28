//
//  SignInViewController.swift
//  ChatApp
//
//  Created by Gwinyai Nyatsoka on 21/7/2023.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var createAccountTextView: UITextView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    var activeTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.clipsToBounds = true
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let attributeString = NSMutableAttributedString(string: "Don't have an account? Create an account here.", attributes: [.font: Font.caption])
        attributeString.addAttribute(.link, value: "chatapp://createaccount", range: (attributeString.string as NSString).range(of: "Create an account here."))
        createAccountTextView.attributedText = attributeString
        createAccountTextView.linkTextAttributes = [.font: Font.linkLabel,.foregroundColor: UIColor.secondary]
        createAccountTextView.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        let backGroundTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeybord))
        view.addGestureRecognizer(backGroundTap)
        
     
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.layer.cornerRadius = 20
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeybordNonification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    func registerKeybordNonification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    @objc func dismissKeybord() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardOffset = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
        let totalOffset = activeTextField == nil ? keyboardOffset : keyboardOffset + activeTextField!.frame.height
        scrollView.contentInset.bottom = totalOffset
    }
    
    
    @objc func keyboardWillHide(notification: Notification) {
        
        scrollView.contentInset.bottom = 0

    }

    @IBAction func signinButtonTapped(_ sender: Any) {
        
        guard let email = emailTextField.text else {
            presentAlert(title: "Email Required", message: "please enter a valid email")
            return
        }
        
        guard let password = passwordTextField.text else {
            presentAlert(title: "Password Required", message: "please enter a valid password")
            return
        }
        
        showLoadingview()
        
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error as? NSError{
                var errorMessage = "something went wrong, please try again"
                if let errorAuth = AuthErrorCode(rawValue: error.code){
                    switch errorAuth {
                    case .userNotFound:
                        errorMessage = "email/password is incorrect"
                    case .invalidEmail:
                        errorMessage = "invalid email"
                    default: break
                        
                    }
                }
                self.removeLodingView()
                self.presentAlert(title: "Signin failed", message: errorMessage)
                return
            }

            let mainStorybord = UIStoryboard(name: "Main", bundle: nil)
            let homeVC = mainStorybord.instantiateViewController(identifier: "HomeViewController")
            let navVC = UINavigationController(rootViewController: homeVC)
            if let windowSence = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let window = windowSence.windows.first
                window?.rootViewController = navVC
                
            }
            
        }
        
        
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

extension SignInViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
}
