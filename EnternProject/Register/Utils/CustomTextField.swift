//
//  CustomTextField.swift
//  EnternProject
//
//  Created by Мухтарпаша on 28.05.2020.
//  Copyright © 2020 Magomed Inc. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    //сделаем отступ текста в текстфиелд
    let padding: CGFloat
    
    init(padding: CGFloat) {
        
        self.padding = padding
        super.init(frame: .zero)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 50)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
