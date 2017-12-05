//
//  TextFiledExtension.swift
//  M-Taixe
//
//  Created by duong nam minh kha on 10/14/16.
//  Copyright © 2016 kha. All rights reserved.
//

import Foundation
import UIKit
extension UITextField
{
    func setBottomBorder(color:String)
    {
        self.borderStyle = UITextBorderStyle.none;
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.gray.cgColor
        border.frame = CGRect(x: 0, y: bounds.size.height-1,   width:  bounds.size.width, height: 1)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
    }
    
}
