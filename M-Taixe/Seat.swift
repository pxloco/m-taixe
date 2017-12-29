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
    var SeatID = Int()
    var StatusList = Int()
    var Status = Int()
    var OrderGuid = String()
    var Total = Int()
    var IsExternalAgent = Bool()
    var IsPayOverrun = Bool()
    var IsBookOverrun = Bool()
    var IsDebit = Bool()
    
    init() {
        
    }
    
    init(SeatID: Int, seatName: String, Status: Int) {
        self.SeatID = SeatID
        self.seatName = seatName
        self.Status = Status
    }
}
