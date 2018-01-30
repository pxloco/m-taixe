//
//  AddOrderController.swift
//  M-Taixe
//
//  Created by duong nam minh kha on 11/4/16.
//  Copyright © 2016 kha. All rights reserved.
//

import UIKit

class AddOrderController: UITableViewController, UITextFieldDelegate, UIWebViewDelegate {

    @IBOutlet var tableViewSeat: UITableView!
    var webviewDepart = UIWebView()
    var webviewArrival = UIWebView()
    var arrivalPicker = UIPickerView()
    var arrSeat = [String]()
    var tripId = String()
    var currentTrip = Trip()
    var inforCell = OrderInforCell()
    var currentUser = User()
    var alert = SCLAlertView()
    var routeId = Int()
    var departs = [RouteDetail]()
    var arrivals = [RouteDetail]()
    var htmlString = ""
    var helper = AddOrderHelper()
    
    var sendPostRequest = SendPostRequest()
    var jsonHelper = JsonHelper()
    var orderGuid = "00000000-0000-0000-0000-000000000000"
    var currentOrder = Customer()
    var saveButton = UIBarButtonItem()
    var isSearch = false
    override func viewDidLoad() {
        super.viewDidLoad()
        alert.showWait("Đang tải dữ liệu", subTitle: "Vui lòng đợi")
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.setHidesBackButton(true, animated: false)
        var cancelButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(self.btnCancelClick))
        cancelButton = UIBarButtonItem.init(title: "Huỷ", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.btnCancelClick))
        self.navigationItem.leftBarButtonItem = cancelButton;
        if !isSearch {
            saveButton = UIBarButtonItem.init(title: "Lưu", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.btnSaveClick))
            self.navigationItem.rightBarButtonItem = saveButton
        }
        
        self.navigationItem.title = "Thêm vé"
        initSelect()
        if self.tripId != "" {
            loadOneTrip()
        }
        
        // Do any additional setup after loading the view.
        //setTextField()
        tableViewSeat.allowsSelection = false
        arrSeat.append("")
        if orderGuid != "00000000-0000-0000-0000-000000000000" {
            self.navigationItem.title = "Sửa vé"
            inforCell.tfMobile.text = currentOrder.CustomerMobile
            inforCell.tfMobile.isEnabled = false
            arrSeat = currentOrder.SeatInOrder.components(separatedBy: ",")
            inforCell.tfName.text = currentOrder.CustomerName
            inforCell.tfCatchAddress.text = currentOrder.CatchAddress
        }
        
        if isSearch {
            inforCell.tfName.isEnabled = false
            inforCell.tfCatchAddress.isEnabled = false
            let depart = RouteDetail()
            depart.Name = currentOrder.DepartText
            depart.StopPointId = currentOrder.DepartGuid
            departs.append(depart)
            
            let arrival = RouteDetail()
            arrival.Name = currentOrder.ArrivalText
            arrival.StopPointId = currentOrder.ArrivalGuid
            arrivals.append(arrival)
            
            bindSelectData()
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    func initSelect(){
        inforCell = tableViewSeat.dequeueReusableCell(withIdentifier: "OrderInfor") as! OrderInforCell
        inforCell.frame = inforCell.contentView.frame
        webviewDepart = inforCell.webviewDepart
        webviewArrival = inforCell.webviewArrival
        webviewDepart.delegate = self
        webviewArrival.delegate = self
        let bundle = Bundle.main
        let file = bundle.path(forResource: "select", ofType: "html")
        do{
            htmlString = try String.init(contentsOfFile: file!)
        }
        catch{
            
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if self.orderGuid != "00000000-0000-0000-0000-000000000000" {
            print(self.currentOrder.ArrivalText)
            for i in 0..<departs.count{
                if departs[i].StopPointId == self.currentOrder.DepartGuid{
                    self.webviewDepart.stringByEvaluatingJavaScript(from: "document.getElementById('select').selectedIndex=\(i)")
                }
            }
            for i in 0..<arrivals.count{
                if arrivals[i].StopPointId == self.currentOrder.ArrivalGuid{
                    self.webviewArrival.stringByEvaluatingJavaScript(from: "document.getElementById('select').selectedIndex=\(i)")
                }
            }

        }

    }
    
    func parseRouteDetailsToString(routeDetails: [RouteDetail])->String{
        var result = ""
        for routeDetail in routeDetails{
            result = "\(result)<option value=\"\(routeDetail.StopPointId)\">\(routeDetail.Name)</option>"
        }
        return result
    }
    
    func btnCancelClick(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.popViewController(animated: true);
    }
    
    func btnSaveClick(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        saveOrder()
    }
    
    func saveOrder(){
        let custMobile = inforCell.tfMobile.text ?? ""
        let custName = inforCell.tfName.text ?? ""
        let catchAdd = inforCell.tfCatchAddress.text ?? ""
        let departGuid = webviewDepart.stringByEvaluatingJavaScript(from: "document.getElementById('select').value") ?? ""
        let arrivalGuid = webviewArrival.stringByEvaluatingJavaScript(from: "document.getElementById('select').value") ?? ""
        let departText = webviewDepart.stringByEvaluatingJavaScript(from: "getSelectedText()") ?? ""
        let arrivalText = webviewArrival.stringByEvaluatingJavaScript(from: "getSelectedText()") ?? ""
        var seats = ""
        
        for seat in arrSeat {
            seats = "\(seats),\(seat)"
        }
        
        if custMobile == ""{
            self.alert.showError("Lỗi!", subTitle: "Bạn phải điền số điện thoại của khách!")
            return
        }
        
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
            "<soapenv:Header/>" +
            "<soapenv:Body>" +
            "<tem:Order_SaveV2>" +
            "<!--Optional:-->" +
            "<tem:OrderGuid>\(orderGuid)</tem:OrderGuid>" +
            "<!--Optional:-->" +
            "<tem:TripId>\(currentTrip.TripId)</tem:TripId>" +
            "<!--Optional:-->" +
            "<tem:CustName>\(custName)</tem:CustName>" +
            "<!--Optional:-->" +
            "<tem:CustMobile>\(custMobile)</tem:CustMobile>" +
            "<!--Optional:-->" +
            "<tem:DepartGuid>\(departGuid)</tem:DepartGuid>" +
            "<!--Optional:-->" +
            "<tem:DepartText>\(departText)</tem:DepartText>" +
            "<!--Optional:-->" +
            "<tem:ArrivalGuid>\(arrivalGuid)</tem:ArrivalGuid>" +
            "<!--Optional:-->" +
            "<tem:ArrivalText>\(arrivalText)</tem:ArrivalText>" +
            "<!--Optional:-->" +
            "<tem:AddressId>0</tem:AddressId>" +
            "<!--Optional:-->" +
            "<tem:CatchAddress>\(catchAdd)</tem:CatchAddress>" +
            "<!--Optional:-->" +
            "<tem:DropAddressId>0</tem:DropAddressId>" +
            "<!--Optional:-->" +
            "<tem:DropAddress></tem:DropAddress>" +
            "<!--Optional:-->" +
            "<tem:CatchType>3</tem:CatchType>" +
            "<!--Optional:-->" +
            "<tem:IsPaid>false</tem:IsPaid>" +
            "<!--Optional:-->" +
            "<tem:SeatNumbers>\(seats)</tem:SeatNumbers>" +
            "<!--Optional:-->" +
            "<tem:CompanyId>\(currentUser.CompanyId)</tem:CompanyId>" +
            "<!--Optional:-->" +
            "<tem:AgentId>\(currentUser.AgentId)</tem:AgentId>" +
            "<!--Optional:-->" +
            "<tem:UserGuid>\(currentUser.UserGuid)</tem:UserGuid>" +
            "<!--Optional:-->" +
            "<tem:UserId>\(currentUser.UserId)</tem:UserId>" +
            "<!--Optional:-->" +
            "<tem:Password>\(currentUser.Password)</tem:Password>" +
            "<!--Optional:-->" +
            "<tem:Mobile>\(currentUser.UserName)</tem:Mobile>" +
            "<!--Optional:-->" +
            "<tem:Mobile>0</tem:Mobile>" +
            "<!--Optional:-->" +
            "<tem:SessionId>\(UserDefaults.standard.value(forKey: "SessionId")!)</tem:SessionId>" +
            "<!--Optional:-->" +
            "<tem:DeviceId>5B47E42C-16BE-4479-92B5-2C31633AD9D4</tem:DeviceId>" +  // \(UserDefaults.standard.string(forKey: "DevideId")!)
            "<!--Optional:-->" +
            "<tem:SecurityCode>MobihomeAppDv123</tem:SecurityCode>" +
            "</tem:Order_SaveV2>" +
            "</soapenv:Body>" +
        "</soapenv:Envelope>"
        let soapAction = "http://tempuri.org/IMobihomeWcf/Order_SaveV2"
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction){
            (result, error) in
            if error != nil{
                self.alert.showError("Lỗi!", subTitle: "Không kết nối được server!")
            }
            else{
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if !isSearch{
            
            return arrSeat.count+2
        }
        else{
            return arrSeat.count+1
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 230.0
        }
        else
        {
            return 47.0
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
           return inforCell
        }
        else if indexPath.row == arrSeat.count+1{
            let cell = tableViewSeat.dequeueReusableCell(withIdentifier: "AddSeatCell", for: indexPath) as! AddSeatCell
            cell.btnAdd.addTarget(self, action: #selector(self.btnAddSeatClick(_:)), for: UIControlEvents.touchUpInside)
            cell.iconAdd.addTarget(self, action: #selector(self.btnAddSeatClick(_:)), for: UIControlEvents.touchUpInside)
            
            return cell
        }
        else{
            let cell = tableViewSeat.dequeueReusableCell(withIdentifier: "SeatCell") as! AddCustomerViewCell
            cell.tfSeatNum.text = arrSeat[indexPath.row-1]
            cell.tfSeatNum.tag = indexPath.row-1
            cell.tfSeatNum.delegate = self
            cell.btnRemove.tag = indexPath.row-1
            if !isSearch{
                
                cell.btnRemove.addTarget(self, action: #selector(self.btnRemoveSeatClick(sender:)), for: UIControlEvents.touchUpInside)
            }
            else{
                cell.tfSeatNum.isEnabled = false
            }
            cell.selectionStyle = .none
            
            return cell
            
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        arrSeat[textField.tag] = textField.text ?? ""
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        arrSeat[textField.tag] = textField.text ?? ""
    }
        func btnRemoveSeatClick(sender: UIButton){
        if arrSeat.count > 1{
            arrSeat.remove(at: sender.tag)
            reloadTable()
        }
    }
    
    @IBAction func btnAddSeatClick(_ sender: UIButton) {
        arrSeat.append("")
        reloadTable()
        tableViewSeat.scrollToRow(at: NSIndexPath.init(row: arrSeat.count+1, section: 0) as IndexPath, at: UITableViewScrollPosition.bottom, animated: true)
    }
    func reloadTable(){
        tableViewSeat.reloadData()
        
    }
    func bindSelectData(){
        var departsStr = self.parseRouteDetailsToString(routeDetails: self.departs)
        var arrivalStr = self.parseRouteDetailsToString(routeDetails: self.arrivals)
        departsStr = self.htmlString.replacingOccurrences(of: "optionvalue", with: departsStr)
        arrivalStr = self.htmlString.replacingOccurrences(of: "optionvalue", with: arrivalStr)
        self.webviewDepart.loadHTMLString(departsStr, baseURL: nil)
        self.webviewArrival.loadHTMLString(arrivalStr, baseURL: nil)
        self.alert.hideView()
    }
    
    func loadDeparts(){
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
        "<soapenv:Header/>" +
        "<soapenv:Body>" +
        "<tem:Place_SearchDepart>" +
        "<!--Optional:-->" +
        "<tem:CompanyId>\(currentUser.CompanyId)</tem:CompanyId>" +
        "<!--Optional:-->" +
        "<tem:AgentId>\(currentUser.AgentId)</tem:AgentId>" +
        "<!--Optional:-->" +
        "<tem:UserName>\(currentUser.UserName)</tem:UserName>" +
        "<!--Optional:-->" +
        "<tem:Password>\(currentUser.Password)</tem:Password>" +
        "<!--Optional:-->" +
        "<tem:SecurityCode>MobihomeAppDv123</tem:SecurityCode>" +
        "<!--Optional:-->" +
        "<tem:RouteId>\(currentTrip.RouteId)</tem:RouteId>" +
        "<!--Optional:-->" +
        "<tem:SearchText></tem:SearchText>" +
        "</tem:Place_SearchDepart>" +
        "</soapenv:Body>" +
        "</soapenv:Envelope>"
        let soapAction = "http://tempuri.org/IMobihomeWcf/Place_SearchDepart"
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction){
            (result, error) in
            if result != ""{
                let dps = self.jsonHelper.parseRouteDetail(result.data(using: String.Encoding.utf8)!)
                self.departs.append(contentsOf: dps)
                
            }
            self.loadArrivals()
            
        }
    }
    
    func loadArrivals(){
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
            "<soapenv:Header/>" +
            "<soapenv:Body>" +
            "<tem:Place_SearchArrival>" +
            "<!--Optional:-->" +
            "<tem:CompanyId>\(currentUser.CompanyId)</tem:CompanyId>" +
            "<!--Optional:-->" +
            "<tem:AgentId>\(currentUser.AgentId)</tem:AgentId>" +
            "<!--Optional:-->" +
            "<tem:UserName>\(currentUser.UserName)</tem:UserName>" +
            "<!--Optional:-->" +
            "<tem:Password>\(currentUser.Password)</tem:Password>" +
            "<!--Optional:-->" +
            "<tem:SecurityCode>MobihomeAppDv123</tem:SecurityCode>" +
            "<!--Optional:-->" +
            "<tem:RouteId>\(currentTrip.RouteId)</tem:RouteId>" +
            "<!--Optional:-->" +
            "<tem:SearchText></tem:SearchText>" +
            "</tem:Place_SearchArrival>" +
            "</soapenv:Body>" +
        "</soapenv:Envelope>"
        let soapAction = "http://tempuri.org/IMobihomeWcf/Place_SearchArrival"
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction){
            (result, error) in
            if result != ""{
                let arrs = self.jsonHelper.parseRouteDetail(result.data(using: String.Encoding.utf8)!)
                self.arrivals.append(contentsOf: arrs)
                self.bindSelectData()
            }
            
        }
    }
    
    func loadOneTrip(){
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
            "<soapenv:Header/>" +
            "<soapenv:Body>" +
            "<tem:Trip_GetOne>" +
            "<!--Optional:-->" +
            "<tem:CompanyId>\(currentUser.CompanyId)</tem:CompanyId>" +
            "<!--Optional:-->" +
            "<tem:UserId>\(currentUser.UserId)</tem:UserId>" +
            "<!--Optional:-->" +
            "<tem:Password>\(currentUser.Password)</tem:Password>" +
            "<!--Optional:-->" +
            "<tem:TripId>\(tripId)</tem:TripId>" +
            "<!--Optional:-->" +
            "<tem:SecurityCode>MobihomeAppDv123</tem:SecurityCode>" +
            "</tem:Trip_GetOne>" +
            "</soapenv:Body>" +
        "</soapenv:Envelope>"
        let soapAction = "http://tempuri.org/IMobihomeWcf/Trip_GetOne"
        
        let sendPostRequest = SendPostRequest()
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction){
            (result, error) in
            
            if error == nil{
                let text = "[\(result)]"
                let jsonHelper = JsonHelper()
                var trips = jsonHelper.parseTrips(text.data(using: String.Encoding.utf8)!)
                self.currentTrip = trips[0]
                if self.currentTrip.RouteId > 0{
                    self.loadStartEnd()
                }
                else{
                    self.alert.hideView()
                    self.alert = SCLAlertView()
                    self.alert.showError("Lỗi!", subTitle: "Không thể kết nối server!")                }
            }
            else{
                self.alert.hideView()
                self.alert = SCLAlertView()
                self.alert.showError("Lỗi!", subTitle: "Không thể kết nối server!")            }
        }
    }
    func loadStartEnd(){
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
            "<soapenv:Header/>" +
            "<soapenv:Body>" +
            "<tem:Place_GetStartEnd>" +
            "<!--Optional:-->" +
            "<tem:CompanyId>\(currentUser.CompanyId)</tem:CompanyId>" +
            "<!--Optional:-->" +
            "<tem:AgentId>\(currentUser.AgentId)</tem:AgentId>" +
            "<!--Optional:-->" +
            "<tem:UserName>\(currentUser.UserName)</tem:UserName>" +
            "<!--Optional:-->" +
            "<tem:Password>\(currentUser.Password)</tem:Password>" +
            "<!--Optional:-->" +
            "<tem:SecurityCode>MobihomeAppDv123</tem:SecurityCode>" +
            "<!--Optional:-->" +
            "<tem:RouteId>\(self.currentTrip.RouteId)</tem:RouteId>" +
            "</tem:Place_GetStartEnd>" +
            "</soapenv:Body>" +
        "</soapenv:Envelope>"
        let soapAction = "http://tempuri.org/IMobihomeWcf/Place_GetStartEnd"
        let sendPost = SendPostRequest()
        sendPost.sendRequest(soapMessage, soapAction: soapAction) {
            (result, error) in
            if error == nil{
                
                let jsonHelper = JsonHelper()
                let startEnd = jsonHelper.parseRouteDetail(result.data(using: String.Encoding.utf8)!)
                for detail in startEnd {
                    if detail.IsStartPoint{
                        self.departs.append(detail)
                    }
                    else{
                        self.arrivals.append(detail)
                    }
                }
                self.loadDeparts()
            } else {
                self.alert.hideView()
                    self.alert = SCLAlertView()
                    self.alert.showError("Lỗi!", subTitle: "Không thể kết nối server!")
            }
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
