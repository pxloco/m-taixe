//
//  DriverViewCell.swift
//  M-Taixe
//
//  Created by M on 1/14/18.
//  Copyright © 2018 kha. All rights reserved.
//

import UIKit
import HPUIViewExtensions
import UICheckbox_Swift

protocol CheckBoxDelegate {
    func checkCheckBox(indexCheckBox: Int)
}

class DriverViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImage: HPImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var checkBox: UICheckbox!
 
    var delegate: CheckBoxDelegate!
    var indexCheckBox: Int!
    
    func setDataToView(employee: Employee, index:Int) {
        self.indexCheckBox = index
        nameLabel.text = employee.EmployeeName
        phoneNumberLabel.text = employee.EmployeeMobile
        checkBox.onSelectStateChanged = { (checkbox, selected) in
           self.delegate.checkCheckBox(indexCheckBox: self.indexCheckBox)
        }
    }
    
    @IBAction func toggleCheckBox(_ sender: Any) {
        delegate.checkCheckBox(indexCheckBox: indexCheckBox)
    }
    
}