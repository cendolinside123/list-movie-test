//
//  UITextField+extensions.swift
//  movie
//
//  Created by Jan Sebastian on 27/04/24.
//

import Foundation
import UIKit

class TextField: UITextField {

    var padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        if self.rightViewMode == .always || self.rightViewMode == .unlessEditing {
            if let rightView,
                rightView.frame.width > 0 {
                padding.right = (rightView.frame.width + 10)
            }
        }
        
        if self.leftViewMode == .always || self.leftViewMode == .unlessEditing {
            if let leftView,
               leftView.frame.width > 0 {
                padding.left = (leftView.frame.width + 10)
            }
        }
        
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        
        if self.rightViewMode == .always || self.rightViewMode == .unlessEditing {
            if let rightView,
                rightView.frame.width > 0 {
                padding.right = (rightView.frame.width + 10)
            }
        }
        
        if self.leftViewMode == .always || self.leftViewMode == .unlessEditing {
            if let leftView,
               leftView.frame.width > 0 {
                padding.left = (leftView.frame.width + 10)
            }
        }
        
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        if self.rightViewMode == .always || self.rightViewMode == .unlessEditing {
            if let rightView,
                rightView.frame.width > 0 {
                padding.right = (rightView.frame.width + 10)
            }
        }
        
        if self.leftViewMode == .always || self.leftViewMode == .unlessEditing {
            if let leftView,
               leftView.frame.width > 0 {
                padding.left = (leftView.frame.width + 10)
            }
        }
        
        return bounds.inset(by: padding)
    }
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        if let rightView, rightView.frame.width > 0 {
            return CGRect(x: bounds.width - (rightView.frame.width + 10), y: 0, width: rightView.frame.width , height: bounds.height)
        }
        return bounds
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        
        if let leftView, leftView.frame.width > 0 {
            return CGRect(x: 10, y: 0, width: leftView.frame.width , height: bounds.height)
        }
        
        return bounds
    }
}
