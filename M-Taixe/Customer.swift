//
//  Customer.swift
//  M-Taixe
//
//  Created by duong nam minh kha on 7/15/16.
//  Copyright © 2016 kha. All rights reserved.
//

import Foundation
class Customer{
    var OrderGuid = String()
    var CustomerName = String()
    var CustomerMobile = String()
    var CatchAddress = String()
    var DropAddress = String()
    var TicketName = String()
    var SeatInOrder = String()
    var OrderTotal = Int64()
    var IsOnBus = Bool()
    var DepartGuid = String()
    var DepartText = String()
    var ArrivalGuid = String()
    var ArrivalText = String()
    
}


//{
//    "OrderGuid":"8e02f2c3-c6e4-4a49-a34c-111b5251d069",
//    "OtherTripId":"00000000-0000-0000-0000-000000000000",
//    "ItemGuid":"733366a0-2006-e811-940a-0cc47a96aaf3",
//    "OrderNo":54395,
//    "OrderCode":"",
//    "UserGuid":"00000000-0000-0000-0000-000000000000",
//    "AgentID":122,
//    "CompanyId":80,
//    "ClerkGuid":"1965f6d4-2432-4854-b5e6-4d09768c9d02",
//    "CustomerName":"Lộc",
//    "CustomerMobile":"12345678",
//    "CustomerEmail":"",
//    "FromCityGuid":"00000000-0000-0000-0000-000000000000",
//    "FromDistrictGuid":"00000000-0000-0000-0000-000000000000",
//    "ToCityGuid":"00000000-0000-0000-0000-000000000000",
//    "ToDistrictGuid":"00000000-0000-0000-0000-000000000000",
//    "DepartGuid":"e8c7ae6b-dfd4-413d-b019-8805bb0f7024",
//    "DepartText":"HCM",
//    "ArrivalGuid":"ecd44f06-f39d-e411-83ad-00237dcf4c9c",
//    "ArrivalText":"Nha Trang",
//    "PaymentMethod":0,
//    "ShippingMethod":0,
//    "SubTotal":0,
//    "TaxTotal":0,
//    "ShippingTotal":0,
//    "PaymentTotal":420000.0000,
//    "Discount":0,
//    "OrderTotal":420000.0000,
//    "Created":201801310754,
//    "CreatedFromIP":"",
//    "Completed":20180131075438,
//    "CompletedFromIP":"",
//    "LastModified":20180131080751,
//    "StatusGuid":"66666666-6666-6666-6666-666666666666",
//    "GatewayTransId":"",
//    "CustomData":"",
//    "CashierGuid":"00000000-0000-0000-0000-000000000000",
//    "CreatedBy":"00000000-0000-0000-0000-000000000000",
//    "UpdatedBy":"00000000-0000-0000-0000-000000000000",
//    "OrderType":2,
//    "AddressId":0,
//    "CatchAddress":"123123213",
//    "DropAddressId":0,
//    "DropAddress":"",
//    "CustomerInfoID":"00000000-0000-0000-0000-000000000000",
//    "ClerkName":"Kha_NV",
//    "CashierName":"",
//    "ShipperName":"",
//    "CreatedByUserName":"",
//    "DeletedByUserName":"",
//    "DeletedAt":0,
//    "LastUpdatedByUserName":"",
//    "PaymentGateway":0,
//    "ProductNameList":"",
//    "BankDestination":"",
//    "IsDeleted":false,
//    "DeletedBy":0,
//    "IsNotMe":false,
//    "IsOnBus":false,
//    "CatchType":3,
//    "StartTime":0,
//    "AgentName":"",
//    "SmsStatus":0,
//    "Birthday":0,
//    "TicketFeeTotal":0,
//    "PaidTime":0,
//    "CompanyName":"",
//    "TicketName":"A1, A3",
//    "LastModifiedString":"dd/MM/yyyy HH:mm:ss",
//    "OrderTotalString":"420,000.00",
//    "IsExternalAgent":false,
//    "ExternalAgentId":-1,
//    "ExternalAgentName":"",
//    "IsOpenTicket":false,
//    "OpenCode":"",
//    "IsCommit":false,
//    "CommitID":0,
//    "TripInfo":"",
//    "TripOtherInfo":"",
//    "IsPrivateTicket":false,
//    "SellerRole":0,
//    "IsPayOverrun":false,
//    "IsBookOverrun":false,
//    "LicensePlate":"",
//    "CountTicket":2,
//    "SeatInOrder":"A1, A3",
//    "SessionId":"",
//    "IsDebit":false,
//    "PayType":0,
//    "Passport":"",
//    "CountryCode":"VN",
//    "CustomerCountry":"Việt Nam",
//    "OrderSort":0,
//    "UpdateTime":-1,
//    "RequestSMS":false,
//    "SmsSent":false,
//    "CatchTime":0,
//    "KmFromDepart":0,
//    "AgentServiceCharge":0,
//    "IsConfirm":false,
//    "DepartKm":0,
//    "DepartMinute":0,
//    "ArrivalKm":0,
//    "ArrivalMinute":0
//},

