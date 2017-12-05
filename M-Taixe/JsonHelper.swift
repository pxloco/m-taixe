//
//  JsonHelper.swift
//  M-Taixe
//
//  Created by duong nam minh kha on 7/14/16.
//  Copyright © 2016 kha. All rights reserved.
//

import Foundation
class JsonHelper{
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
    func parseRouteDetail(_ inputData: Data)-> [RouteDetail]{
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
    func parseTrips(_ inputData: Data) -> [Trip]{
        var trips = [Trip]()
        do{
            
            let dateFormatter = DateFormatter()
            var err: NSError?
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
                if let StartTime = item["StartTime"] as? Double
                {
                    let time = Int64(StartTime)
                    dateFormatter.dateFormat = "yyyyMMddHHmm"
                    let date = dateFormatter.date(from: "\(time)")!
                    let newFormatter = DateFormatter()
                    newFormatter.dateFormat = "HH:mm"
                    trip.StartTime = newFormatter.string(from: date)
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
                if let UpdateTime = item["UpdateTime"] as? Double{
                    if UpdateTime > 10000000000000{
                        dateFormatter.dateFormat = "yyyyMMddHHmmss"
                        let num = Int64(UpdateTime)
                        trip.UpdateTime = dateFormatter.date(from: "\(num)")!
                    }
                   
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