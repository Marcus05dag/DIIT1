//
//  Utils.swift
//  EnternProject
//
//  Created by Мухтарпаша on 26.05.2020.
//  Copyright © 2020 Magomed Inc. All rights reserved.
//

import UIKit

extension UIButton {
    class func setupButton (title:String, color:UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = color
        button.layer.cornerRadius = 22
        button.isEnabled = false
        return button
        
    }
}


extension UIButton {
    class func setupSign (title:String , NSAtitle: String, selector: String) -> UIButton {
        let button = UIButton(type: .system)
               // первая часть кнопки
               let attributedTitle = NSMutableAttributedString(string: title, attributes: [.font:UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.lightGray])
               //вторая часть кнопки
               attributedTitle.append(NSAttributedString(string: NSAtitle, attributes: [.font:UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
               button.setAttributedTitle(attributedTitle, for: .normal)
//               button.addTarget(self, action: #selector(selector), for: .touchUpInside)
               return button
               
    }
}
    
    


extension UITextField {
    class func setupTextField (placeholder:String,IsSecureTextEntry: Bool) -> UITextField{
        let tf = CustomTextField(padding: 16)
        tf.placeholder = placeholder
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.layer.cornerRadius = 22 
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.isSecureTextEntry = IsSecureTextEntry
        return tf
    }
    
    
}




extension UIColor {
    
    static func rgb(red:CGFloat,green:CGFloat,blue:CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
}

struct AnchoredConstraints {
    var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}


extension UIView {
    
    @discardableResult
    func anchor(top: NSLayoutYAxisAnchor? , leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing:NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> AnchoredConstraints {
        
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        
        if let top = top {
            anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
        }
        
        if let leading = leading {
            anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }
            
        if let bottom = bottom {
            anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        
        if let trailing = trailing {
            anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }
        
        if size.width != 0 {
            anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
        }
        
        if size.height != 0 {
            anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
        }
        
        [anchoredConstraints.top, anchoredConstraints.leading, anchoredConstraints.bottom, anchoredConstraints.trailing, anchoredConstraints.width, anchoredConstraints.height].forEach{$0?.isActive = true}
        
        
        return anchoredConstraints
    }
    
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let superViewTopAnchor = superview?.topAnchor {
            topAnchor.constraint(equalTo: superViewTopAnchor, constant: padding.top).isActive = true
        }
        
        if let superViewBottomAnchor = superview?.bottomAnchor {
            bottomAnchor.constraint(equalTo: superViewBottomAnchor, constant: -padding.bottom).isActive = true
        }
        
        if let superViewLeadingAnchor = superview?.leadingAnchor  {
            leadingAnchor.constraint(equalTo: superViewLeadingAnchor, constant: padding.left).isActive = true
        }
       
        if let superViewtrailingAnchor = superview?.trailingAnchor {
            trailingAnchor.constraint(equalTo: superViewtrailingAnchor, constant: -padding.right).isActive = true
        
        }
    }
    
    
    func centerInSuperview(size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let superviewCenterXAanchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterXAanchor).isActive = true
        }
        if let superviewCenterYAanchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAanchor).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true 
        }
    }
    
}
