//
//  Seat.swift
//  M-Taixe
//
//  Created by M on 12/10/17.
//  Copyright © 2017 kha. All rights reserved.
//

import Foundation
import Firebase

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
    let ref: DatabaseReference?
    var key = String()
    
    init() {
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        //key = snapshot.key
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        isSelected = snapshotValue["isSelected"] as! Bool
        seatName = snapshotValue["seatName"] as! String
        SeatID = snapshotValue["SeatID"] as! Int
        StatusList = snapshotValue["StatusList"] as! Int
        OrderGuid = snapshotValue["OrderGuid"] as! String
        Total = snapshotValue["Total"] as! Int
        IsExternalAgent = snapshotValue["IsExternalAgent"] as! Bool
        IsPayOverrun = snapshotValue["IsPayOverrun"] as! Bool
        IsBookOverrun = snapshotValue["IsBookOverrun"] as! Bool
        IsDebit = snapshotValue["IsDebit"] as! Bool
        
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "isSelected": isSelected,
            "seatName": seatName,
            "SeatID": SeatID,
            "StatusList": StatusList,
            "Status": Status,
            "OrderGuid": OrderGuid,
            "Total": Total,
            "IsExternalAgent": IsExternalAgent,
            "IsPayOverrun": IsPayOverrun,
            "IsBookOverrun": IsBookOverrun,
            "IsDebit": IsDebit
        ]
    }
    
    
//    init(SeatID: Int, seatName: String, Status: Int, isSelected: Bool, StatusList: Int, OrderGuid: String, Total: Int, IsExternalAgent: Bool, IsPayOverrun: Bool, IsBookOverrun: Bool, IsDebit: Bool) {
//        self.SeatID = SeatID
//        self.seatName = seatName
//        self.Status = Status
//        self.isSelected = isSelected
//        self.StatusList = StatusList
//        self.OrderGuid = OrderGuid
//        self.Total = Total
//        self.IsExternalAgent = IsExternalAgent
//        self.IsPayOverrun = IsPayOverrun
//        self.IsBookOverrun = IsBookOverrun
//        self.IsDebit = IsDebit
//    }
    
//    {"SeatID":875,"StatusList":"32","Status":32,"OrderGuid":"b7eeb304-2db1-4def-af7c-228403664473","Total":0,"IsExternalAgent":false,"IsPayOverrun":false,"IsBookOverrun":false,"IsDebit":false},{"SeatID":876,"StatusList":"32","Status":32,"OrderGuid":"b7eeb304-2db1-4def-af7c-228403664473","Total":0,"IsExternalAgent":false,"IsPayOverrun":false,"IsBookOverrun":false,"IsDebit":false}
}
