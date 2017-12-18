//
//  Seat.swift
//  M-Taixe
//
//  Created by M on 12/10/17.
//  Copyright © 2017 kha. All rights reserved.
//

import Foundation

class Seat {
    var isSelected = Bool()
    var seatName = String()
    
    init(isSelected: Bool, seatName: String) {
        self.isSelected = isSelected
        self.seatName = seatName
    }
}
