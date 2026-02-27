//
//  File.swift
//  ChatApp
//
//  Created by Abdalqader Alwahsh on 25/02/2026.
//

import Foundation
import UIKit

extension UIViewController {
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showLoadingview() {
        let lodingView = LoadingView()
        view.addSubview(lodingView)
        lodingView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        lodingView.tag = 2026
    }
    
    func removeLodingView() {
        if let lodingView = view.viewWithTag(2026) {
            lodingView.removeFromSuperview()
        }
    }
    
}
