//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Abdalqader Alwahsh on 05/03/2026.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    var username: String?

    @IBOutlet weak var changeImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = username
        let changeImageTap = UITapGestureRecognizer(target: self, action: #selector(presentAvatarOption))
        changeImageView.isUserInteractionEnabled = true
        changeImageView.addGestureRecognizer(changeImageTap)
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        containerView.layer.cornerRadius = 8
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.tintColor = .black
        profileImage.backgroundColor = .systemGray6
    }
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            presentAlert(title: "Logout Field", message: "something went wrong please try again")
        }
        
        let authStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let signinVC = authStoryboard.instantiateViewController(identifier: "SignInViewController")
      
        let window = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
        window?.rootViewController = signinVC
        
    }
    
    @objc func presentAvatarOption() {
        let avatarOptionSheet = UIAlertController(title: "Change Avatar", message: "select an option", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            
        }
        let photoAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
            
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        avatarOptionSheet.addAction(cameraAction)
        avatarOptionSheet.addAction(photoAction)
        avatarOptionSheet.addAction(deleteAction)
        avatarOptionSheet.addAction(cancelAction)
        present(avatarOptionSheet, animated: true)
    }

    
   

}
