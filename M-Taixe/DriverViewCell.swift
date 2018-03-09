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
    
    // Employee -> danh sach tai xe
    // EmployeeByTrip -> Danh sach tai xe cua xe
    
    func setDataToView(employee: Employee, index:Int, employeeByTrip: EmployeeByTrip) {
        self.indexCheckBox = index
        
        nameLabel.text = employee.EmployeeName
        phoneNumberLabel.text = employee.EmployeeMobile
        
        if employee.EmployeeId == employeeByTrip.Driver1Id || employee.EmployeeId == employeeByTrip.Employee1Id {
            checkBox.isSelected = true
        } else {
            checkBox.isSelected = false
        }
        
        checkBox.onSelectStateChanged = { (checkbox, selected) in
            if selected {
                self.delegate.checkCheckBox(indexCheckBox: self.indexCheckBox)
            }
        }
    }
    
    @IBAction func toggleCheckBox(_ sender: Any) {
        delegate.checkCheckBox(indexCheckBox: indexCheckBox)
    }
    
}
