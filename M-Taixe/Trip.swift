//
//  Trip.swift
//  M-Taixe
//
//  Created by duong nam minh kha on 7/14/16.
//  Copyright © 2016 kha. All rights reserved.
//

import Foundation
class Trip {
    var CountTicket = Int()
    var CountBooked = Int()
    var LicensePlate = String()
    var TripId = String()
    var StartTime = String()
    var StartTimeFull = String()
    var EndTime = String()
    var StartDate = String()
    var Title = String()
    var UpdateTime = Date()
    var RouteId = Int()
    var color = String()
    var DriversName = String()
    var EmployeesName = String()
    var TimeOnRoad = Int()
    var BusPriceID = Int()
    var Status = String()
    var IsLockedAgent = Bool()
    var IsCommit = Bool()
    var IsFixed = Bool()
    var AllowTrustDebit = Bool()
    var BusId = Int()
    var TicketAmount = Int()
    var TicketPaidAmount = Int()
    var CountPaid = Int()
    var BillFreightCount = Int()    // Tong so hang
    var BillFreightPaidCount = Int()    //Tong so hang da thanh toan
    var BillFreightAmount = Int()   // Tong do tien hang
    var BillFreightPaidAmount = Int()   //Tong so tien hang da thanh toan
    
}


//[{"TripId":"cffcd231-05f8-e711-940a-0cc47a96aaf3","CompanyID":80,"BusId":83,"Title":"","StartDate":20180113,"StartTime":201801130857,"EndTime":201801130856,"TimeOnRoad":-1,"BusPriceID":233,"RouteId":58,"RouteName":"","Status":1,"RuleId":0,"TotalTicket":"","BusType":"1         ","LicensePlate":"test","Color":"aaff56","LocalNumber":"01","CountTicket":40,"CountBooked":0,"CountPaid":0,"TicketAmount":0,"TicketPaidAmount":0,"BillFreightCount":1,"BillFreightPaidCount":0,"BillFreightAmount":300000,"BillFreightPaidAmount":0,"FeeTicketAmount":0,"FeeTicketPaidAmount":0,"TotalAmount":0,"TotalPaid":0,"IsDeleted":false,"BillTotal":"","IsLockedAgent":false,"IsCommit":true,"IsFixed":false,"PriceName":"","DriversName":"","EmployeesName":"","AllowTrustDebit":false,"PriceOffset":0,"PriceOffsetPercent":0.00,"PriceOffsetType":0,"UseFloorSeat":false,"Mobile":"","ArchivedApproval":false,"IsLimited":false,"ReturnTripId":"00000000-0000-0000-0000-000000000000","ReturnStarTime":-1,"ReturnStartDate":-1,"TripType":0,"UpdatedBy":-1,"WaitingCount":0,"OpenOnline":false,"MapId":50,"OrderSort":1,"CountFloorSeat":0,"MinuteFromDepart":0,"TripCommitDate":0,"UpdateTime":0,"LastPrint":0},{"TripId":"e3c5c91d-83f6-e711-940a-0cc47a96aaf3","CompanyID":80,"BusId":83,"Title":"","StartDate":20180113,"StartTime":201801131600,"EndTime":201801140000,"TimeOnRoad":-1,"BusPriceID":415,"RouteId":58,"RouteName":"","Status":4,"RuleId":0,"TotalTicket":"","BusType":"1         ","LicensePlate":"50H-8888  ","Color":"aaff56","LocalNumber":"01","CountTicket":40,"CountBooked":2,"CountPaid":2,"TicketAmount":490000,"TicketPaidAmount":490000,"BillFreightCount":0,"BillFreightPaidCount":0,"BillFreightAmount":0,"BillFreightPaidAmount":0,"FeeTicketAmount":0,"FeeTicketPaidAmount":0,"TotalAmount":0,"TotalPaid":0,"IsDeleted":false,"BillTotal":"","IsLockedAgent":false,"IsCommit":true,"IsFixed":false,"PriceName":"","DriversName":"Nguyễn Văn A","EmployeesName":"","AllowTrustDebit":false,"PriceOffset":0,"PriceOffsetPercent":0.00,"PriceOffsetType":0,"UseFloorSeat":false,"Mobile":"","ArchivedApproval":false,"IsLimited":false,"ReturnTripId":"00000000-0000-0000-0000-000000000000","ReturnStarTime":-1,"ReturnStartDate":-1,"TripType":0,"UpdatedBy":-1,"WaitingCount":0,"OpenOnline":false,"MapId":50,"OrderSort":1,"CountFloorSeat":0,"MinuteFromDepart":0,"TripCommitDate":0,"UpdateTime":0,"LastPrint":0},{"TripId":"b7f10025-83f6-e711-940a-0cc47a96aaf3","CompanyID":80,"BusId":86,"Title":"","StartDate":20180113,"StartTime":201801131800,"EndTime":201801140200,"TimeOnRoad":-1,"BusPriceID":234,"RouteId":58,"RouteName":"","Status":2,"RuleId":0,"TotalTicket":"","BusType":"1         ","LicensePlate":"50H-5555  ","Color":"007fff","LocalNumber":"04","CountTicket":42,"CountBooked":3,"CountPaid":3,"TicketAmount":750000,"TicketPaidAmount":750000,"BillFreightCount":0,"BillFreightPaidCount":0,"BillFreightAmount":0,"BillFreightPaidAmount":0,"FeeTicketAmount":0,"FeeTicketPaidAmount":0,"TotalAmount":0,"TotalPaid":0,"IsDeleted":false,"BillTotal":"","IsLockedAgent":false,"IsCommit":true,"IsFixed":false,"PriceName":"","DriversName":"Kha tai xe","EmployeesName":"","AllowTrustDebit":false,"PriceOffset":0,"PriceOffsetPercent":0.00,"PriceOffsetType":0,"UseFloorSeat":false,"Mobile":"","ArchivedApproval":false,"IsLimited":false,"ReturnTripId":"00000000-0000-0000-0000-000000000000","ReturnStarTime":-1,"ReturnStartDate":-1,"TripType":0,"UpdatedBy":-1,"WaitingCount":0,"OpenOnline":false,"MapId":51,"OrderSort":4,"CountFloorSeat":0,"MinuteFromDepart":0,"TripCommitDate":0,"UpdateTime":0,"LastPrint":0}]

