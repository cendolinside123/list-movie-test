//
//  UIViewController+extensions.swift
//  movie
//
//  Created by Jan Sebastian on 28/04/24.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showToast(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.numberOfLines = 0
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 1;
        toastLabel.clipsToBounds  =  true
        toastLabel.preferredMaxLayoutWidth = (UIScreen.main.bounds.width - 75)
        toastLabel.sizeToFit()
        self.view.addSubview(toastLabel)
        toastLabel.layoutIfNeeded()
        toastLabel.frame.origin.x = (self.view.frame.size.width - toastLabel.frame.size.width ) / 2
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func showLoading() {
        let loadingView = UIActivityIndicatorView(frame: CGRect(x: (self.view.frame.size.width / 2) - 40, y: (self.view.frame.size.height / 2) - 40, width: 80, height: 80))
        if #available(iOS 13.0, *) {
            loadingView.style = UIActivityIndicatorView.Style.medium
        } else {
            // Fallback on earlier versions
            loadingView.style = UIActivityIndicatorView.Style.white
        }
        loadingView.color = .black
        loadingView.backgroundColor = .gray
        loadingView.tag = 12345
        
        if self.view.subviews.first(where: { $0 is UIActivityIndicatorView && $0.tag == 12345 }) == nil {
            self.view.addSubview(loadingView)
            loadingView.startAnimating()
        } else {
            print("loading indicator already show")
        }
    }
    
    func hideLoading() {
//        self.view.subviews.removeAll(where: { $0 is UIActivityIndicatorView })
        if let getView =  self.view.subviews.first(where: { $0 is UIActivityIndicatorView && $0.tag == 12345 }) {
            getView.removeFromSuperview()
        }
        
    }
    
    func askReload(yesAnswer: @escaping (() -> Void), noAnswer: @escaping (() -> Void)) {
        let alert = UIAlertController(title: "Error", message: "Want reload?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            yesAnswer()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { _ in
            noAnswer()
        }))
        self.navigationController?.present(alert, animated: true)
        
    }
}
