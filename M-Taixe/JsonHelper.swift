//
//  JsonHelper.swift
//  M-Taixe
//
//  Created by duong nam minh kha on 7/14/16.
//  Copyright © 2016 kha. All rights reserved.
//

import Foundation
class JsonHelper{
    
    func parseReportInTrip(_ inputData: Data) -> [ReportInTrip] {
        var reportInTrips = [ReportInTrip]()
        do {
            let json = try JSONSerialization.jsonObject(with: inputData, options: JSONSerialization.ReadingOptions.allowFragments)
            for item in json as! [[String: AnyObject]]{
                let report = ReportInTrip()
                
                if let SellerName =  item["SellerName"] as? String {
                    report.SellerName = SellerName
                }
                
                if let TotalAmount = item["TotalAmount"] as? Int{
                    report.TotalAmount = TotalAmount
                }
                
                if let TotalAmountPaid = item["TotalAmountPaid"] as? Int {
                    report.TotalAmountPaid = TotalAmountPaid
                }
                
                if let CountOrder = item["CountOrder"] as? Int {
                    report.CountOrder = CountOrder
                }
                
                if let CountTicket = item["CountTicket"] as? Int {
                    report.CountTicket = CountTicket
                }
                
                if let CountTicketPaid = item["CountTicketPaid"] as? Int {
                    report.CountTicketPaid = CountTicketPaid
                }
                
                if let CountBill = item["CountBill"] as? Int {
                    report.CountBill = CountBill
                }
                
                if let BillAmount = item["BillAmount"] as? Int {
                    report.BillAmount = BillAmount
                }
                
                if let CountBillPaid = item["CountBillPaid"] as? Int {
                    report.CountBillPaid = CountBillPaid
                }
                
                if let BillPaidAmount = item["BillPaidAmount"] as? Int {
                    report.BillPaidAmount = BillPaidAmount
                }
   
                
                reportInTrips.append(report)
            }
        }
        catch{
            
        }
        return reportInTrips
    }
    
    func parseTicket(_ inputData: Data) -> Ticket {
        let ticket = Ticket()
        do {
            let item = try JSONSerialization.jsonObject(with: inputData, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String, AnyObject>
            
            if let TicketID = item!["ticket"]!["TicketID"] as? String {
                ticket.TicketID = TicketID
            }
            
            if let BusId = item!["ticket"]!["BusId"] as? Int {
                ticket.BusId = BusId
            }
            
            if let TripId = item!["ticket"]!["TripId"] as? String {
                ticket.TripId = TripId
            }
            
            if let SeatID = item!["ticket"]!["SeatID"] as? Int{
                ticket.SeatID = SeatID
            }
            
            if let MapID = item!["ticket"]!["MapID"] as? Int{
                ticket.MapID = MapID
            }
            
            if let SeatNumber = item!["ticket"]!["SeatNumber"] as? String {
                ticket.SeatNumber = SeatNumber
            }
            
            if let SeatRow = item!["ticket"]!["SeatRow"] as? String{
                ticket.SeatRow = SeatRow
            }
            
            if let SeatListing = item!["ticket"]!["SeatListing"] as? Int {
                ticket.SeatListing = SeatListing
            }
            
            if let ActualPrice = item!["ticket"]!["ActualPrice"] as? Int {
                ticket.ActualPrice = ActualPrice
            }
            
            if let TicketCustName = item!["ticket"]!["TicketCustName"] as? String {
                ticket.TicketCustName = TicketCustName
            }
            
            if let TicketCustMobile = item!["ticket"]!["TicketCustMobile"] as? String {
                ticket.TicketCustMobile = TicketCustMobile
            }
            
            if let OrderGuid = item!["ticket"]!["OrderGuid"] as? String {
                ticket.OrderGuid = OrderGuid
            }
            
            if let OfferPrice = item!["ticket"]!["OfferPrice"] as? Int {
                ticket.OfferPrice = OfferPrice
            }
            
            if let DepartText = item!["ticket"]!["DepartText"] as? String {
                ticket.DepartText = DepartText
            }
            
            if let ArrivalText = item!["ticket"]!["ArrivalText"] as? String {
                ticket.ArrivalText = ArrivalText
            }
            
            if let DepartGuid = item!["ticket"]!["DepartGuid"] as? String {
                ticket.DepartGuid = DepartGuid
            }
            
            if let ArrivalGuid = item!["ticket"]!["ArrivalGuid"] as? String {
                ticket.ArrivalGuid = ArrivalGuid
            }
            
            if let PaidTime = item!["ticket"]!["PaidTime"] as? Int {
                ticket.PaidTime = PaidTime
            }
            
            if let CatchAddress = item!["ticket"]!["CatchAddress"] as? String {
                ticket.CatchAddress = CatchAddress
            }
            
            if let BookingClerkId = item!["ticket"]!["BookingClerkId"] as? Int {
                ticket.BookingClerkId = BookingClerkId
            }
            
            if let BookingClerkName = item!["ticket"]!["BookingClerkName"] as? String {
                ticket.BookingClerkName = BookingClerkName
            }
            
            if let Status = item!["ticket"]!["Status"] as? Int {
                ticket.Status = Status
            }
            
            if let SessionId = item!["ticket"]!["SessionId"] as? String {
                ticket.SessionId = SessionId
            }
        }
        catch{
            
        }
        return ticket
    }
    
    func parseEmployeeByTrip(_ inputData: Data) -> EmployeeByTrip {
        let employee = EmployeeByTrip()
        do {
            let item = try JSONSerialization.jsonObject(with: inputData, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String, AnyObject>
            
            if let ID = item!["ID"] as? Int {
                    employee.ID = ID
                }

            if let TripId = item!["TripId"] as? String{
                    employee.TripId = TripId
                }

            if let Driver1Id = item!["Driver1Id"] as? Int{
                    employee.Driver1Id = Driver1Id
                }

            if let Driver1Name = item!["Driver1Name"] as? String{
                    employee.Driver1Name = Driver1Name
                }

            if let Driver2Id = item!["Driver2Id"] as? Int{
                    employee.Driver2Id = Driver2Id
                }

            if let Driver2Name = item!["Driver2Name"] as? String{
                    employee.Driver2Name = Driver2Name
                }

            if let Employee1Id = item!["Employee1Id"] as? Int{
                    employee.Employee1Id = Employee1Id
                }

            if let Employee1Name = item!["Employee1Name"] as? String{
                    employee.Employee1Name = Employee1Name
                }

            if let Employee2Id = item!["Employee2Id"] as? Int{
                    employee.Employee2Id = Employee2Id
                }

            if let Employee2Name = item!["Employee2Name"] as? String{
                    employee.Employee2Name = Employee2Name
                }
        }
        catch{
            
        }
        return employee
    }
    
    func parseEmployee(_ inputData: Data) -> [Employee] {
        var employees = [Employee]()
        do {
            let json = try JSONSerialization.jsonObject(with: inputData, options: JSONSerialization.ReadingOptions.allowFragments)
            for item in json as! [[String: AnyObject]]{
                let employee = Employee()
                
                if let EmployeeId =  item["EmployeeId"] as? Int {
                    employee.EmployeeId = EmployeeId
                }
                
                if let CompanyId = item["CompanyId"] as? Int{
                    employee.CompanyId = CompanyId
                }
                
                if let PositionID = item["PositionID"] as? Int{
                    employee.PositionID = PositionID
                }
                
                if let CompanyId = item["CompanyId"] as? Int{
                    employee.CompanyId = CompanyId
                }
                
                if let EmployeeName = item["EmployeeName"] as? String{
                    employee.EmployeeName = EmployeeName
                }
                
                if let EmployeeMobile = item["EmployeeMobile"] as? String{
                    employee.EmployeeMobile = EmployeeMobile
                }
                
                employees.append(employee)
            }
        }
        catch{
            
        }
        return employees
    }
    
    func parseTicketPriceByBus(_ inputData: Data) -> [TicketByBus] {
        var ticketByBuses = [TicketByBus]()
        do {
            let json = try JSONSerialization.jsonObject(with: inputData, options: JSONSerialization.ReadingOptions.allowFragments)
            for item in json as! [[String: AnyObject]]{
                let ticketByBus = TicketByBus()
                if let MapTicketPriceID =  item["MapTicketPriceID"] as? Int {
                    ticketByBus.MapTicketPriceID = MapTicketPriceID
                }
                if let Title = item["Title"] as? String{
                    ticketByBus.Title = Title
                }
                ticketByBuses.append(ticketByBus)
            }
        }
        catch{
            
        }
        return ticketByBuses
    }
    
    func parseBus(_ inputData: Data) -> [Bus] {
        var buses = [Bus]()
        do {
            let json = try JSONSerialization.jsonObject(with: inputData, options: JSONSerialization.ReadingOptions.allowFragments)
            for item in json as! [[String: AnyObject]]{
                let bus = Bus()
                
                if let busId =  item["BusId"] as? Int {
                    bus.BusId = busId
                }
                
                if let LicensePlate = item["LicensePlate"] as? String{
                    bus.LicensePlate = LicensePlate
                }
                
                if let TripId = item["TripId"] as? String{
                    bus.TripId = TripId
                }
                
                buses.append(bus)
            }
        }
        catch{
            
        }
        return buses
    }
    
    func parseBills(_ inputData: Data)-> [Bill]{
        var items = [Bill]()
        do{
            let json = try JSONSerialization.jsonObject(with: inputData, options: JSONSerialization.ReadingOptions.allowFragments)
            for obj in json as! [[String: AnyObject]]{
                var item = Bill()
                if let BillId = obj["BillID"] as? Int{
                    item.BillID = BillId
                }
                if let ShipperMobile = obj["ShipperMobile"] as? String{
                    item.ShipperMobile = ShipperMobile
                }
                if let ShipperName = obj["ShipperName"] as? String{
                    item.ShipperName = ShipperName
                }
                if let ShipperAdd = obj["ShipperAdd"] as? String{
                    item.ShipperAdd = ShipperAdd
                }
                if let ConsigneeMobile = obj["ConsigneeMobile"] as? String{
                    item.ConsigneeMobile = ConsigneeMobile
                }
                if let Consignee = obj["Consignee"] as? String{
                    item.Consignee = Consignee
                }
                if let ConsigneeAdd = obj["ConsigneeAdd"] as? String{
                    item.ConsigneeAdd = ConsigneeAdd
                }
                if let NameOfGoods = obj["NameOfGoods"] as? String{
                    item.NameOfGoods = NameOfGoods
                }
                if let TotalCharges = obj["TotalCharges"] as? Int64{
                    item.TotalCharges = TotalCharges
                }
                items.append(item)
            }
        }
        catch{
            
        }
        return items
    }
    
    func parseSeats(_ inputData: Data)-> [Seat]{
        var seats = [Seat]()
        do{
            let json = try JSONSerialization.jsonObject(with: inputData, options: JSONSerialization.ReadingOptions.allowFragments)
            for item in json as! [[String: AnyObject]]{
                let seat = Seat()
                
                if let seatID =  item["SeatID"] as? Int {
                    seat.SeatID = seatID
                }
                
                if let status = item["Status"] as? Int{
                    seat.Status = status
                }
                
                if let seatName = item["SeatName"] as? String{
                    seat.seatName = seatName
                }
                
                if let StatusList = item["StatusList"] as? Int{
                    seat.StatusList = StatusList
                }
                
                if let OrderGuid = item["OrderGuid"] as? String{
                    seat.OrderGuid = OrderGuid
                }
                
                if let Total = item["Total"] as? Int{
                    seat.Total = Total
                }
                
                if let IsExternalAgent = item["IsExternalAgent"] as? Bool{
                    seat.IsExternalAgent = IsExternalAgent
                }
                
                if let IsPayOverrun = item["IsPayOverrun"] as? Bool{
                    seat.IsPayOverrun = IsPayOverrun
                }
                
                if let IsBookOverrun = item["IsBookOverrun"] as? Bool{
                    seat.IsBookOverrun = IsBookOverrun
                }
                
                if let IsDebit = item["IsDebit"] as? Bool{
                    seat.IsDebit = IsDebit
                }
                
                seats.append(seat)
            }
        }
        catch{
            
        }
        return seats
    }
    
    func parseRoutes(_ inputData: Data)-> [Route]{
        var routes = [Route]()
        do{
            let json = try JSONSerialization.jsonObject(with: inputData, options: JSONSerialization.ReadingOptions.allowFragments)
            for item in json as! [[String: AnyObject]]{
                var route = Route()
                if let routeId =  item["RouteId"] as? Int {
                    route.RouteId = routeId
                }
                if let name = item["Name"] as? String{
                    route.Name = name
                }
                routes.append(route)
            }
        }
        catch{
            
        }
        return routes
    }
    
    func parseCalls(_ inputData: Data) -> [Call]{
        var calls = [Call]()
        do{
            let json = try JSONSerialization.jsonObject(with: inputData, options: JSONSerialization.ReadingOptions.allowFragments)
            for item in json as! [[String: AnyObject]]{
                var call = Call()
                if let CallId =  item["NumberCallingId"] as? String {
                    call.NumberCallingId = CallId
                }
                if let PhoneNumber =  item["PhoneNumber"] as? String {
                    call.PhoneNumber = PhoneNumber
                }
                if let CallToHotline =  item["CallToHotline"] as? String {
                    call.CallToHotline = CallToHotline
                }
                if let CustomerName =  item["CustName"] as? String {
                    call.CustomerName = CustomerName
                }
                if let callAt = item["CallAt"] as? Int64{
                    call.CallAt = callAt
                }
                calls.append(call)
            }
        }
        catch{
            
        }
        return calls
    }
    
    func parseRouteDetail(_ inputData: Data)-> [RouteDetail] {
        var routeDetails = [RouteDetail]()
        do{
            let json = try JSONSerialization.jsonObject(with: inputData, options: JSONSerialization.ReadingOptions.allowFragments)
            for item in json as! [[String: AnyObject]]{
                var routeDetail = RouteDetail()
                if let StopPointId =  item["StopsPointId"] as? String {
                    routeDetail.StopPointId = StopPointId
                }
                if let IsStartPoint =  item["IsStartPoint"] as? Bool {
                    routeDetail.IsStartPoint = IsStartPoint
                }
                if let name = item["Name"] as? String{
                    routeDetail.Name = name
                }
                routeDetails.append(routeDetail)
            }
        }
        catch{
            
        }
        return routeDetails
    }
    
    func parseRouteLocation(_ inputData: Data)-> [Location]{
        var locations = [Location]()
        do {
            let json = try JSONSerialization.jsonObject(with: inputData, options: JSONSerialization.ReadingOptions.allowFragments)
            print(json)
            for item in json as! [[String: AnyObject]]{
                let location = Location()
                if let locationId =  item["LocationID"] as? String {
                    location.LocationID = locationId
                }
                
                if let Name =  item["Name"] as? String {
                    location.Name = Name
                }
                
                if let ParentId =  item["ParentId"] as? String {
                    location.ParentId = ParentId
                }
               
                locations.append(location)
            }
        }
        catch{
            print("json error: \(error)")
        }
        return locations
    }
    
    func parseTrips(_ inputData: Data) -> [Trip]{
        var trips = [Trip]()
        do{
            
            let dateFormatter = DateFormatter()
            let json = try JSONSerialization.jsonObject(with: inputData, options: JSONSerialization.ReadingOptions.allowFragments)
            for item in json as! [[String: AnyObject]]{
                let trip = Trip()
                
                if let CountTicket = item["CountTicket"] as? Int
                {
                    trip.CountTicket = CountTicket
                }
                
                if let CountBooked = item["CountBooked"] as? Int
                {
                    trip.CountBooked = CountBooked
                }
                
                if let RouteId = item["RouteId"] as? Int
                {
                    trip.RouteId = RouteId
                }

                if let LicensePlate = item["LicensePlate"] as? String
                {
                    trip.LicensePlate = LicensePlate
                }
                
                if let TripId = item["TripId"] as? String
                {
                    trip.TripId = TripId
                }
                
                if let color = item["Color"] as? String {
                    trip.color = color
                }
                
                if let StartTime = item["StartTime"] as? Double
                {
                    let time = Int64(StartTime)
                    dateFormatter.dateFormat = "yyyyMMddHHmm"
                    let date = dateFormatter.date(from: "\(time)")!
                    let newFormatter = DateFormatter()
                    newFormatter.dateFormat = "HH:mm"
                    trip.StartTime = newFormatter.string(from: date)
                }
                
                if let StartTimeFull = item["StartTime"] as? Double
                {
                    let time = Int64(StartTimeFull)
                    dateFormatter.dateFormat = "yyyyMMddHHmm"
                    let date = dateFormatter.date(from: "\(time)")!
                    let newFormatter = DateFormatter()
                    newFormatter.dateFormat = "yyyyMMddHHmm"
                    trip.StartTimeFull = newFormatter.string(from: date)
                }
            
                if let EndTime = item["EndTime"] as? Double
                {
                    let time = Int64(EndTime)
                    dateFormatter.dateFormat = "yyyyMMddHHmm"
                    let date = dateFormatter.date(from: "\(time)")!
                    let newFormatter = DateFormatter()
                    newFormatter.dateFormat = "yyyyMMddHHmm"
                    trip.EndTime = newFormatter.string(from: date)
                }
                
                if let StartDate = item["StartDate"] as? Int
                {
                    dateFormatter.dateFormat = "yyyyMMdd"
                    let date = dateFormatter.date(from: "\(StartDate)")!
                    let newFormatter = DateFormatter()
                    newFormatter.dateFormat = "dd:MM:yyyy"
                    trip.StartDate = newFormatter.string(from: date)
                }
                
                if let Title = item["Title"] as? String
                {
                    trip.Title = Title
                }
                
                if let DriversName = item["DriversName"] as? String
                {
                    trip.DriversName = DriversName
                }
                
                if let EmployeesName = item["EmployeesName"] as? String
                {
                    trip.EmployeesName = EmployeesName
                }
                
                if let TimeOnRoad = item["TimeOnRoad"] as? Int
                {
                    trip.TimeOnRoad = TimeOnRoad
                }
                
                if let BusPriceID = item["BusPriceID"] as? Int
                {
                    trip.BusPriceID = BusPriceID
                }
                
                if let Status = item["Status"] as? String
                {
                    trip.Status = Status
                }
                
                if let IsLockedAgent = item["IsLockedAgent"] as? Bool
                {
                    trip.IsLockedAgent = IsLockedAgent
                }
                
                if let IsCommit = item["IsCommit"] as? Bool
                {
                    trip.IsCommit = IsCommit
                }
                
                if let IsFixed = item["IsFixed"] as? Bool
                {
                    trip.IsFixed = IsFixed
                }
                
                if let AllowTrustDebit = item["AllowTrustDebit"] as? Bool
                {
                    trip.AllowTrustDebit = AllowTrustDebit
                }
                
                if let BusId = item["BusId"] as? Int
                {
                    trip.BusId = BusId
                }
                
                if let UpdateTime = item["UpdateTime"] as? Double{
                    if UpdateTime > 10000000000000{
                        dateFormatter.dateFormat = "yyyyMMddHHmmss"
                        let num = Int64(UpdateTime)
                        trip.UpdateTime = dateFormatter.date(from: "\(num)")!
                    }
                   
                }
                
                if let TicketAmount = item["TicketAmount"] as? Int {
                    trip.TicketAmount = TicketAmount
                }
                
                if let TicketPaidAmount = item["TicketPaidAmount"] as? Int {
                    trip.TicketPaidAmount = TicketPaidAmount
                }
                
                if let CountPaid = item["CountPaid"] as? Int {
                    trip.CountPaid = CountPaid
                }
                
                if let BillFreightCount = item["BillFreightCount"] as? Int {
                    trip.BillFreightCount = BillFreightCount
                }
                
                if let BillFreightPaidCount = item["BillFreightPaidCount"] as? Int {
                    trip.BillFreightPaidCount = BillFreightPaidCount
                }
                
                if let BillFreightAmount = item["BillFreightAmount"] as? Int {
                    trip.BillFreightAmount = BillFreightAmount
                }
                
                if let BillFreightPaidAmount = item["BillFreightPaidAmount"] as? Int {
                    trip.BillFreightPaidAmount = BillFreightPaidAmount
                }
                
                trips.append(trip)
            }
        }
        catch{
            //print("json error: \(error)")
        }
        
        return trips
    }
    func parseCustomers(_ data: Data) -> [Customer]{
        var customers = [Customer]()
        do{
            var err: NSError?
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            
            for item in json as! [[String: AnyObject]]{
                let customer = Customer()
                if let OrderGuid = item["OrderGuid"] as? String
                {
                    customer.OrderGuid = OrderGuid
                }
                if let CustomerName = item["CustomerName"] as? String
                {
                    customer.CustomerName = CustomerName
                }
                if let CustomerMobile = item["CustomerMobile"] as? String
                {
                    customer.CustomerMobile = CustomerMobile
                }
                if let CatchAddress = item["CatchAddress"] as? String
                {
                    customer.CatchAddress = CatchAddress
                }
                if let DropAddress = item["DropAddress"] as? String
                {
                    customer.DropAddress = DropAddress
                }
                if let TicketName = item["TicketName"] as? String
                {
                    customer.TicketName = TicketName
                }
                if let SeatInOrder = item["SeatInOrder"] as? String
                {
                    customer.SeatInOrder = SeatInOrder
                }
                if let OrderTotal = item["OrderTotal"] as? Double
                {
                    let total = Int64(OrderTotal)
                    customer.OrderTotal = total
                }
                if let DaDon = item["IsOnBus"] as? Bool
                {
                    customer.IsOnBus = DaDon
                }
                if let DepartGuid = item["DepartGuid"] as? String
                {
                    customer.DepartGuid = DepartGuid
                }
                if let DepartText = item["DepartText"] as? String
                {
                    customer.DepartText = DepartText
                }
                if let ArrivalGuid = item["ArrivalGuid"] as? String
                {
                    customer.ArrivalGuid = ArrivalGuid
                }
                if let ArrivalText = item["ArrivalText"] as? String
                {
                    customer.ArrivalText = ArrivalText
                }
                customers.append(customer)
                
            }
        }
        catch{
            //print("json error: \(error)")
        }
        return customers
    }
    func customersToJson(_ customers: [Customer]) -> String{
        var result = "["
        for i in 0 ..< customers.count {
            let cus = customers[i]
            result = "\(result){"
            result = "\(result)\u{22}OrderGuid\u{22}:\u{22}\(cus.OrderGuid)\u{22}, "
            result = "\(result)\u{22}CustomerName\u{22}:\u{22}\(cus.CustomerName)\u{22}, "
            result = "\(result)\u{22}CustomerMobile\u{22}:\u{22}\(cus.CustomerMobile)\u{22}, "
            result = "\(result)\u{22}CatchAddress\u{22}:\u{22}\(cus.CatchAddress)\u{22}, "
            result = "\(result)\u{22}DropAddress\u{22}:\u{22}\(cus.DropAddress)\u{22}, "
            result = "\(result)\u{22}TicketName\u{22}:\u{22}\(cus.TicketName)\u{22}, "
            result = "\(result)\u{22}SeatInOrder\u{22}:\u{22}\(cus.SeatInOrder)\u{22}, "
            result = "\(result)\u{22}OrderTotal\u{22}:\(cus.OrderTotal), "
            result = "\(result)\u{22}IsOnBus\u{22}:\(cus.IsOnBus)"
            result = "\(result)}"
            if i < customers.count-1{
                result = "\(result), "
            }
        }
        result = "\(result)]"
        return result
    }
}
