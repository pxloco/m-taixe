//
//  CustomersController.swift
//  M-Taixe
//
//  Created bye duong nam minh kha on 7/15/16.
//  Copyright © 2016 kha. All rights reserved.
//

import UIKit

class CustomersController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTongSo: UILabel!
    @IBOutlet weak var topbar: UIView!
    @IBOutlet weak var addGoodsButton: UIButton!
    
    var currentUser = User()
    var segmentControl = UISegmentedControl()
    var tripId = String()
    var arrCustomers = [Customer]()
    var arrCustomersChuaDon = [Customer]()
    var alert = SCLAlertView()
    var timer = Timer()
    var firstRun = true
    var jsonHelper = JsonHelper()
    var userDefaults = UserDefaults.standard
    var gioXuatBen = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        initBar()
        loadFirst()
        //30 s load dữ liệu server 1 lần
        //timer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(CustomersController.timerTask), userInfo: nil, repeats: true)
        //segmentControl.frame = CGRect(x: 50, y: 50, width: 1000, height: 50)
    }
    
    func setUpData() {
        let defaults = UserDefaults.standard
        
        let userName = defaults.value(forKey: "UserName")
        let password = defaults.value(forKey: "Password")
        let displayName = defaults.value(forKey: "FullName")
        let roleType = defaults.value(forKey: "RoleType")
        let companyId = defaults.value(forKey: "CompanyId")
        let AgentId = defaults.value(forKey: "AgentId")
        let userId = defaults.value(forKey: "UserId")
        let userGuid = defaults.value(forKey: "UserGuid")
        
        currentUser.UserName = userName  as! String
        currentUser.Password = password as! String
        currentUser.DisplayName = displayName  as! String
        currentUser.RoleType = Int.init(roleType as! String)!
        currentUser.CompanyId = companyId  as! String
        currentUser.AgentId = AgentId as! String
        currentUser.UserId = userId  as! String
        currentUser.UserGuid = userGuid as! String
    }
    
    func initBar() {
        //Add segmentcontrol vào navigationbar
//        let titleView = UIView.init(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        self.initSegmentControl()
//        titleView.addSubview(segmentControl)
        topbar.addSubview(segmentControl)
//        let navBarFrame = self.navigationController!.navigationBar.frame
//        titleView.frame = CGRect(x: (navBarFrame.width - segmentControl.frame.width) / 2, y: (navBarFrame.height - segmentControl.frame.height) / 2, width: segmentControl.frame.width, height: se`gmentControl.frame.height)
        let attr = NSDictionary(object: UIFont(name: "HelveticaNeue", size: 9.0)!, forKey: NSFontAttributeName as NSCopying)

        segmentControl.setTitleTextAttributes(attr as! [AnyHashable : Any], for: UIControlState.normal)
//        self.navigationItem.titleView = titleView
        let btnAdd = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = btnAdd
        
//        let btnHome = UIButton()
//        btnHome.setBackgroundImage(UIImage(named: "home_icon"), for: UIControlState.normal)
//        var frame = btnHome.frame
//        frame.size.width = 35
//        frame.size.height = 25
//        btnHome.frame = frame
//
//        btnHome.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0)
//        btnHome.addTarget(self, action: #selector(self.btnHomeClick), for: UIControlEvents.touchUpInside)
//        var right = UIBarButtonItem(customView: btnHome)
        
//        self.navigationItem.setHidesBackButton(true, animated: false)
//        self.navigationItem.leftBarButtonItem = right

    }
    
    func btnHomeClick() {
        self.navigationController?.popViewController(animated: true)
    }

    
    func timerTask(){
        if UIApplication.shared.applicationState == UIApplicationState.active{
            loadData()
        }
    }
    
    func loadFirst(){
        var firstTab = self.tabBarController?.viewControllers![0] as! SchemaViewController
        self.tripId = firstTab.tripId
        arrCustomers = [Customer]()
        arrCustomersChuaDon = [Customer]()
        let json = userDefaults.value(forKey: self.tripId) as? Data
        if json != nil{
            let stringJson = String(data: json!, encoding: String.Encoding.utf8)
            //print("json: \(stringJson)")
            self.arrCustomers = self.jsonHelper.parseCustomers(json!)
        }
        self.tableView.reloadData()
        do{
            let text = try NSAttributedString(data: "<b>\(gioXuatBen)</b> Tổng số hành khách: \(arrCustomersChuaDon.count)".data(using: String.Encoding.unicode, allowLossyConversion: false)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            lblTongSo.attributedText = text
        }
        catch{
            
        }
        
    }
    
    func updateCustomer(_ orderGuid: String){
        let soapMessage = String(format: "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:UpdateOnBus><!--Optional:--><tem:UserName>\(currentUser.UserName)</tem:UserName><!--Optional:--><tem:Password>\(currentUser.Password)</tem:Password><!--Optional:--><tem:OrderGuid>\(orderGuid)</tem:OrderGuid></tem:UpdateOnBus><tem:SecurityCode>MobihomeAppDv123</tem:SecurityCode></soapenv:Body></soapenv:Envelope>")
        let soapAction = "http://tempuri.org/IMobihomeWcf/UpdateOnBus"
        let sendPostRequest = SendPostRequest()
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction) { (string, error) in
            
        }
    }
    
    func loadData(){
        let soapMessage = String(format: "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:Order_GetByTrip><!--Optional:--><tem:UserName>\(currentUser.UserName)</tem:UserName><!--Optional:--><tem:Password>\(currentUser.Password)</tem:Password><!--Optional:--><tem:TripId>\(tripId)</tem:TripId><tem:SecurityCode>MobihomeAppDv123</tem:SecurityCode></tem:Order_GetByTrip></soapenv:Body></soapenv:Envelope>")
        let soapAction = "http://tempuri.org/IMobihomeWcf/Order_GetByTrip"
        let sendPostRequest = SendPostRequest()
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction) { (string, error) in
            self.alert.hideView()
            if error == nil{
                
                //Có phản hồi từ server
                if string != "" {
                    
                    //Parse dữ liệu của server và set lại thuộc tính đã đón hay chưa đón
                    let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
                    let arrTmp = self.jsonHelper.parseCustomers(data!)
                    
                    let jsonString = self.jsonHelper.customersToJson(self.arrCustomers)
                    let jsonData = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false)
                    self.userDefaults.setValue(jsonData, forKey: self.tripId)
                    self.userDefaults.synchronize()
                    self.arrCustomers = arrTmp
                    self.arrCustomersChuaDon = [Customer]()
                    for cus in self.arrCustomers{
                        if !cus.IsOnBus{
                            self.arrCustomersChuaDon.append(cus)
                        }
                    }
                    
                    self.tableView.reloadData()
                    self.resetLabelText()
                }
                else{
                    //Thông báo lỗi server
                    
                }
            }
            else{
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentControl.selectedSegmentIndex == 1{
            return arrCustomers.count
        }
        else {
            return arrCustomersChuaDon.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        let storyBoard = UIStoryboard.init(name: "Schema", bundle: Bundle.main)
        let controller = storyBoard.instantiateViewController(withIdentifier: "AddOrder") as! AddOrderController
        controller.orderGuid = arrCustomers[indexPath.row].OrderGuid
        controller.currentOrder = arrCustomers[indexPath.row]
        controller.tripId = tripId
        controller.currentUser = currentUser
        self.navigationController?.pushViewController(controller, animated: true)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerCell") as! CustomerCell
        if segmentControl.selectedSegmentIndex == 1{
            let customer = arrCustomers[(indexPath as NSIndexPath).row]
            cell.lblCustomerName.text = customer.CustomerName
            cell.lblCustomerNumber.text = customer.CustomerMobile
            cell.lblCatchAddress.text = customer.CatchAddress
        }
        else{
            let customer = arrCustomersChuaDon[(indexPath as NSIndexPath).row]
            cell.lblCustomerName.text = customer.CustomerName
            cell.lblCustomerNumber.text = "\(customer.CustomerMobile)"
            cell.lblCatchAddress.text = customer.CatchAddress
        }
        cell.parent = self
        return cell
    }
   
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        if self.segmentControl.selectedSegmentIndex == 0
        {
            return true
        }
        else {
            
            return false
        }
    }
    
    @available(iOS 8.0, *)
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        let daDon = UITableViewRowAction(style: .default, title: "Đã đón")
        { action, index in
            for i in 0 ..< self.arrCustomers.count {
                if self.arrCustomers[i].OrderGuid == self.arrCustomersChuaDon[(index as NSIndexPath).row].OrderGuid{
                    self.arrCustomers[i].IsOnBus = true
                }
            }
            let strJson = self.jsonHelper.customersToJson(self.arrCustomers)
            let dataJson = strJson.data(using: String.Encoding.utf8, allowLossyConversion: false)
            print(strJson)
            self.userDefaults.setValue(dataJson, forKey: self.tripId)
            self.userDefaults.synchronize()
            
            self.arrCustomersChuaDon.remove(at: (index as NSIndexPath).row)
            do{
                let t = try NSAttributedString(data: "<b>\(self.gioXuatBen)</b> Tổng số hành khách: \(self.arrCustomersChuaDon.count)".data(using: String.Encoding.unicode, allowLossyConversion: false)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                self.lblTongSo.attributedText = t
            }
            catch{
                
            }
            self.tableView.reloadData()
        }
        daDon.backgroundColor = UIColor.init(hexString: "00aff0")
        let huyVe = UITableViewRowAction.init(style: .normal, title: "Huỷ vé") { (action, index) in
            
        }
        huyVe.backgroundColor = UIColor.red
        return [daDon, huyVe]
        
    }
    
    func resetLabelText(){
        do{
            if self.segmentControl.selectedSegmentIndex == 0{
                let t = try NSAttributedString(data: "<b>\(self.gioXuatBen)</b> Tổng số hành khách: \(self.arrCustomersChuaDon.count)".data(using: String.Encoding.unicode, allowLossyConversion: false)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                self.lblTongSo.attributedText = t
            }
            if self.segmentControl.selectedSegmentIndex == 1{
                let t = try NSAttributedString(data: "<b>\(self.gioXuatBen)</b> Tổng số hành khách: \(self.arrCustomers.count)".data(using: String.Encoding.unicode, allowLossyConversion: false)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                self.lblTongSo.attributedText = t
            }
        }
        catch{
            
        }
    }
    
    var currentSegmentIndex = 0
    
    func initSegmentControl() {
        self.segmentControl = UISegmentedControl.init(frame: CGRect(x: UIScreen.main.bounds.width/2 - 78, y: 20, width: 156, height: 29))
        self.segmentControl.removeAllSegments()
        self.segmentControl.insertSegment(withTitle: "Chưa đón", at: 0, animated: true)
        self.segmentControl.insertSegment(withTitle: "Tất cả", at: 1, animated: true)
        self.segmentControl.insertSegment(withTitle: "Hàng", at: 2, animated: true)
        self.segmentControl.selectedSegmentIndex = 0
        self.segmentControl.addTarget(self, action: #selector(CustomersController.segmentedControlValueChanged(_:)), for:.valueChanged)
        self.segmentControl.addTarget(self, action: #selector(CustomersController.segmentedControlValueChanged(_:)), for:.touchUpInside)
    }
    
    func segmentedControlValueChanged(_ sender: UISegmentedControl){
        tableView.reloadData()
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            currentSegmentIndex = 0
            do {
                let text = try NSAttributedString(data: "<b>\(gioXuatBen)</b> Tổng số hành khách: \(arrCustomersChuaDon.count)".data(using: String.Encoding.unicode, allowLossyConversion: false)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                lblTongSo.attributedText = text
                addGoodsButton.isHidden = true
            }
            catch{
            }
        case 1:
            currentSegmentIndex = 1
            do{
                let text = try NSAttributedString(data: "<b>\(gioXuatBen)</b> Tổng số hành khách: \(arrCustomers.count)".data(using: String.Encoding.unicode, allowLossyConversion: false)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                lblTongSo.attributedText = text
                addGoodsButton.isHidden = true
            }
            catch{
                
            }
        default:
            let storyBoard = UIStoryboard.init(name: "Schema", bundle: Bundle.main)
            let controller = storyBoard.instantiateViewController(withIdentifier: "Fret") as! FretController
            controller.currentUser = currentUser
            controller.tripId = tripId
            self.navigationController?.pushViewController(controller, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.segmentControl.selectedSegmentIndex = currentSegmentIndex
        self.overTop = false
        loadData()
    }
    
    var overTop = false
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableView.contentOffset.y < -30{
            overTop = true
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if overTop{
            //navigateToSearch()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    @IBAction func homeAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addGoodsAction(_ sender: Any) {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        let storyboard = UIStoryboard.init(name: "Schema", bundle: Bundle.main)
        let addController = storyboard.instantiateViewController(withIdentifier: "AddOrder") as! AddOrderController
        addController.tripId = tripId
        addController.currentUser = currentUser
        self.navigationController?.pushViewController(addController, animated: false)
    }
    
    
}
