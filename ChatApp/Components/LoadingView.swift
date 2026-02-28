//
//  LoadingView.swift
//  ChatApp
//
//  Created by Abdalqader Alwahsh on 27/02/2026.
//

import UIKit

class LoadingView: UIView {

    @IBOutlet var containerView: UIView!
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubViews()
    }
    
    func initSubViews(){
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: nil)
        nib.instantiate(withOwner: self)
        containerView.frame = bounds
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        addSubview(containerView)
    }
    
}
