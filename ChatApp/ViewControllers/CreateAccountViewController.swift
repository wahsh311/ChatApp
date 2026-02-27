//
//  CreateAccountViewController.swift
//  ChatApp
//
//  Created by Gwinyai Nyatsoka on 21/7/2023.
//

import UIKit
import FirebaseAuth
import Firebase

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signinAccountTextView: UITextView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    var activeTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.clipsToBounds = true
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let attributeString = NSMutableAttributedString(string: "Already have an account? Sign in here.", attributes: [.font: Font.caption])
        attributeString.addAttribute(.link, value: "chatapp://signin", range: (attributeString.string as NSString).range(of: "Sign in here."))
        signinAccountTextView.attributedText = attributeString
        signinAccountTextView.linkTextAttributes = [.font: Font.linkLabel,.foregroundColor: UIColor.secondary]
        signinAccountTextView.isEditable = false
        signinAccountTextView.delegate = self
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        registerKeybordNotifications()
        let backgorindTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(backgorindTap)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)

    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func registerKeybordNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        
        guard let keybordFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keybordHeight = view.convert(keybordFrame.cgRectValue, from: nil).size.height
        let totalOffset = activeTextField == nil ? keybordHeight : keybordHeight + activeTextField!.frame.height
        scrollView.contentInset.bottom = totalOffset
        
    }

    @objc func keyboardWillHide(notification: Notification) {
        
        scrollView.contentInset.bottom = 0
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.layer.cornerRadius = 20
    }
    
    
    
    
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        
        guard let username = usernameTextField.text else {
            presentAlert(title: "username Required", message: "please enter a username")

            return
            }
        guard username.count > 1 && username.count <= 15 else {
            presentAlert(title: "Username Unvalid", message: "please enter username between 1 and 15")
            return
        }
        guard let email = emailTextField.text else {
            presentAlert(title: "Email Required", message: "please enter a valid email")
            return
        
        }
        
        guard let password = passwordTextField.text else {
            presentAlert(title: "Password Required", message: "please enter a valid password")
            return
        }
        
        Database.database().reference().child("usernames").child(username).observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                self.presentAlert(title: "Username in use", message: "pleate try another username")
                print(snapshot)
                return
            }
            
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                guard let result = result else {
                    self.presentAlert(title: "Create Acount Feild", message: "something went wrong try again")
                    return
                }
                let userId = result.user.uid
                let userData = ["id": userId, "username": username]
                Database.database().reference().child("usernames").child(username).setValue(userData)
            }
            
            let mainStorybord = UIStoryboard(name: "Main", bundle: nil)
            let homeViewControoler = mainStorybord.instantiateViewController(identifier: "HomeViewController")
            let navVC = UINavigationController(rootViewController: homeViewControoler)
            if let windowSence = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowSence.windows.first {
                window.rootViewController = navVC
                
                
            }
            
        }
        
        
        
        
        
        
    }
    

}

extension CreateAccountViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if URL.scheme == "chatapp" {
            performSegue(withIdentifier: "SignInSegue", sender: nil)
        }
        return false
    }
}

extension CreateAccountViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
}
