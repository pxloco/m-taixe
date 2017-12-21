//
//  AppDelegate.swift
//  M-Taixe
//
//  Created by duong nam minh kha on 7/14/16.
//  Copyright © 2016 kha. All rights reserved.
//

import UIKit
import CoreLocation
@available(iOS 8.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var manager = CLLocationManager()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.applicationIconBadgeNumber = 0
        application.registerForRemoteNotifications()
        registerForPushNotifications(application)
        //application.beginBackgroundTaskWithName("showNotification", expirationHandler: nil)
        

        return true
    }
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        getData()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    
    func registerForPushNotifications(_ application: UIApplication) {
        if #available(iOS 8.0, *) {
            let notificationSettings = UIUserNotificationSettings(
                types: [.badge, .sound, .alert], categories: nil)
            application.registerUserNotificationSettings(notificationSettings)
        } else {
            // Fallback on earlier versions
        }
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(deviceToken)
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotificationuserInfo: [AnyHashable: Any]) {
        //print(userInfo)
    }
    func getData() -> Void{
        
        let localNotification:UILocalNotification = UILocalNotification()
        localNotification.fireDate = Date.init(timeIntervalSinceNow: 0)
        localNotification.alertBody = "alert"
        localNotification.timeZone = TimeZone.current
        //localNotification.applicationIconBadgeNumber = 1
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
    
    var isBackground = false
    let backgroundQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
    var isStartBackground = false
    var firstRun = true
    var isStarted = false
    var timer = Timer()
    func applicationDidEnterBackground(_ application: UIApplication) {
//        self.isBackground = true
//        if !isStarted{
//            print("in background")
//            dispatch_async(self.backgroundQueue, myBackgroundTask)
//            isStarted = true
//        }
        getData()
       
    }
    var userDefaults = UserDefaults.standard
    var jsonHelper = JsonHelper()
    func refreshData(_ byDate: String){
        let userName = userDefaults.value(forKey: "UserName") as? String
        let password = userDefaults.value(forKey: "Password") as? String
        if userName != nil{
            let soapMessage = String(format: "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:GetTripByDate><!--Optional:--><tem:UserName>\(userName!)</tem:UserName><!--Optional:--><tem:Password>\(password!)</tem:Password><!--Optional:--><tem:TripDate>\(byDate)</tem:TripDate><tem:SecurityCode>MobihomeAppDv123</tem:SecurityCode></tem:GetTripByDate></soapenv:Body></soapenv:Envelope>")
            let soapAction = "http://tempuri.org/IMobihomeWcf/GetTripByDate"
            
            let sendPostRequest = SendPostRequest()
            
            //Gửi yêu cầu lấy danh sách chuyến trong ngày "bydate"
            sendPostRequest.sendRequest(soapMessage, soapAction: soapAction) { (string, error) in
                if error == nil{
                    //Parse dữ liệu trả về sang NSData
                    print(string)
                    let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
                    var trips = [Trip]()
                    
                    //Chuyển sang danh sách chuyến
                    trips = self.jsonHelper.parseTrips(data!)
                    
                    
                    let oldTripsData = self.userDefaults.value(forKey: byDate) as? NSData
                    if oldTripsData != nil{
                        let oldTrips = self.jsonHelper.parseTrips(oldTripsData! as Data)
                        var ktTrip = false
                        var ktKH = false
                        if oldTrips.count != trips.count{
                            ktTrip = true
                        }
                        for newTrip in trips{
                            for oldTrip in oldTrips{
                                if oldTrip.TripId == newTrip.TripId{
                                    if newTrip.UpdateTime.compare(oldTrip.UpdateTime) != ComparisonResult.orderedSame{
                                        ktTrip = true
                                    }
                                    if newTrip.CountBooked !=  oldTrip.CountBooked{
                                        ktKH = true
                                    }
                                }
                            }
                            
                        }
                        
                        print("oldtrip:\(oldTrips.count) newTrip:\(trips.count)")
                        if ktTrip || ktKH{
                            if self.isBackground{
                                //print(string)
                                //Nếu có dữ liẹu trả về từ server thì lưu xuống bộ nhớ local
                                if string != ""{
                                    self.userDefaults.setValue(data, forKey: byDate)
                                    self.userDefaults.synchronize()
                                }
                                let localNotification:UILocalNotification = UILocalNotification()
                                localNotification.soundName = UILocalNotificationDefaultSoundName
                                localNotification.fireDate = NSDate.init(timeIntervalSinceNow: 5) as Date
                                if ktTrip{
                                    localNotification.alertBody = "Có thay đổi danh sách chuyến"
                                    
                                }
                                else{
                                    localNotification.alertBody = "Có thay đổi danh sách hành khách"
                                }
                                localNotification.timeZone = NSTimeZone.default
                                localNotification.applicationIconBadgeNumber = 1
                                UIApplication.shared.scheduleLocalNotification(localNotification)
                            }
                        }
                    }
                    else{
                        if self.isBackground{
                            if trips.count>0{
                                let localNotification:UILocalNotification = UILocalNotification()
                                localNotification.fireDate = NSDate.init(timeIntervalSinceNow: 5) as Date
                                localNotification.alertBody = "Có chuyến mới"
                                localNotification.timeZone = NSTimeZone.default
                                localNotification.applicationIconBadgeNumber = 1
                            }
                        }
                    }
                    
                }
            }
            
        }
        
    }

    func myBackgroundTask() {
        if isBackground{
            Thread.sleep(forTimeInterval: 5)
            let currentDate = Date()
            let dateFomatter = DateFormatter()
            dateFomatter.dateFormat = "yyyyMMdd"
            let currentDateString = dateFomatter.string(from: currentDate)
            refreshData(currentDateString)
            self.backgroundQueue.async(execute: myBackgroundTask)
        }
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIApplication.shared.applicationIconBadgeNumber = 0
        print("app return")
        self.isBackground = false
        if firstRun{
            firstRun = false
        }
        else{
            if let navigationController = self.window?.rootViewController as? UINavigationController {
                
                if (navigationController.viewControllers.count == 2){
                    let category = navigationController.topViewController as! CategoryController
                    let currentDate = Date()
                    let dateFomatter = DateFormatter()
                    dateFomatter.dateFormat = "yyyyMMdd"
                    let currentDateString = dateFomatter.string(from: currentDate)
//                    category.loadData(currentDateString, choose: true)
                }
                if (navigationController.viewControllers.count == 3){
                    let customerController = navigationController.topViewController as! CustomersController
                    customerController.loadData()
                }
            }
            
            
        }
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        //backgroundThread(0, background: {
        //self.getData()
        //})
    }
    
    
}

