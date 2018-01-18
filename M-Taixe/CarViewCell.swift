//
//  CarViewCell.swift
//  M-Taixe
//
//  Created by M on 1/14/18.
//  Copyright © 2018 kha. All rights reserved.
//

import UIKit

class CarViewCell: UITableViewCell {
    @IBOutlet weak var bienSoLabel: UILabel!
    
    func setDataToView(bus: Bus) {
        bienSoLabel.text = bus.LicensePlate
    }
}
