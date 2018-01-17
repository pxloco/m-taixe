//
//  ListGoodsViewController.swift
//  M-Taixe
//
//  Created by M on 1/13/18.
//  Copyright © 2018 kha. All rights reserved.
//

import UIKit
import DropDown
import UICheckbox_Swift

class ListGoodsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var goodsTableView: UITableView!
    @IBOutlet weak var currentBienSoLabel: UILabel!
    @IBOutlet weak var chonHetCheckBox: UICheckbox!
    @IBOutlet weak var topBarMenu: UIView!
    
    var bills = [Bill]()
    var callBill = Bill()
    var trips = [Trip]()
    var currentTrip = Trip()
    var currentUser = User()
    var formatter = DateFormatter()
    var currentDate = String()
    let dropDown = DropDown()
    var jsonHelper = JsonHelper()
    
    let pageSize = 50
    let pageNumber = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUserDefaultParam()
        setUpUI()
        checkAll()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFilterWaitTrip()
    }
    
    func initData(trips: [Trip], currentDate: String) {
        self.trips = trips
        self.currentDate = currentDate
    }
    
    func setUpUI() {
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
        DropDown.appearance().cellHeight = 60
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
        DropDown.appearance().cellHeight = 60
        
        AppUtils.addShadowToView(view: topBarMenu, width: 1, height: 2, color: UIColor.gray.cgColor, opacity: 0.5, radius: 2)
        
        if trips.count > 0 {
            currentBienSoLabel.text = trips[0].LicensePlate
            currentTrip = trips[0]
        }
    }
    
    func setUpUserDefaultParam() {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier else {
            return
        }
        
        switch segueId {
        case SegueFactory.fromGoodsToAddGoods.rawValue:
             (segue.destination as! AddFretController).setUpData(tripId: "")
        default:
            break
        }
    }
    
    func checkAll() {
        chonHetCheckBox.onSelectStateChanged = { (checkbox, selected) in
            self.goodsTableView.reloadData()
        }
    }
    
    // MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BillCell", for: indexPath) as! BillCell
        cell.selectionStyle = .none
        let bill = bills[indexPath.row]
        cell.lblShipper.text = "Gửi: \(bill.ShipperName) - \(bill.ShipperMobile)"
        cell.lblConsignee.text = "Nhận: \(bill.Consignee) - \(bill.ConsigneeMobile)"
        cell.btnCall.tag = indexPath.row
        let theString = "<label style=\"font-size: 18px;\">\(bill.NameOfGoods) - <b>\(bill.TotalCharges)</b></label>"
        cell.selectedGood.isSelected = chonHetCheckBox.isSelected ? true : false
        
        let theAttributedString = try! NSAttributedString(data: theString.data(using: String.Encoding.unicode, allowLossyConversion: false)!,
                                                          options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                                          documentAttributes: nil)
        cell.lblBillName.attributedText = theAttributedString
        cell.lblCatch.text = "\(bill.ShipperAdd) - \(bill.ConsigneeAdd)"
        cell.btnCall.addTarget(self, action: #selector(self.btnCallClick(sender:)), for: UIControlEvents.touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        let storyboard = UIStoryboard.init(name: "Goods", bundle: Bundle.main)
        let addController = storyboard.instantiateViewController(withIdentifier: "AddFret") as! AddFretController
        addController.currentUser = currentUser
        addController.tripId = "00000000-0000-0000-0000-000000000000"
        addController.billID = bills[indexPath.row].BillID
        addController.bill = bills[indexPath.row]
        self.navigationController?.pushViewController(addController, animated: false)
    }
    
    // MARK: Action
    
    func btnCallClick(sender: UIButton){
        callBill = bills[sender.tag]
        if #available(iOS 8.0, *) {
            let confirm = UIAlertController(title: "Hỏi?", message: "Bạn muốn gọi cho người gửi hay người nhận?", preferredStyle: .alert)
            let shipperClick = UIAlertAction.init(title: "Người gửi", style: .cancel, handler: { (UIAlertAction) in
                self.makeCall(self.callBill.ShipperMobile)
            })
            let consigneeClick = UIAlertAction.init(title: "Người nhận", style: .default, handler: { (UIAlertAction) in
                self.makeCall(self.callBill.ConsigneeMobile)
            })
            confirm.addAction(shipperClick)
            confirm.addAction(consigneeClick)
            self.present(confirm, animated: true, completion:{
                confirm.view.superview?.isUserInteractionEnabled = true
                confirm.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
            })
        } else {
            // Fallback on earlier versions
        }
    }
    
    func makeCall(_ tel: String){
        let trimmedString = tel.trimmingCharacters(in: CharacterSet.whitespaces)
        let telUrl:URL? = URL(string: "telprompt://"+tel)
        if ((telUrl) != nil){
            if(UIApplication.shared.canOpenURL(telUrl!)){
                UIApplication.shared.openURL(telUrl!)
            }else
            {
                print("Call not available")
            }
        }
    }
    
    func alertControllerBackgroundTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: User Action
    
    @IBAction func danhSachChuyenAction(_ sender: Any) {
        if self.trips.count > 0 {
            // The view to which the drop down will appear on
            dropDown.anchorView = self.currentBienSoLabel // UIView or UIBarButtonItem
            
            var arrDropDown = [String]()
            for trip in self.trips {
                arrDropDown.append(trip.LicensePlate)
            }
            
            // The list of items to display. Can be changed dynamically
            dropDown.dataSource = arrDropDown
            
            // Action triggered on selection
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                self.currentBienSoLabel.text = item
                self.currentTrip = self.trips[index]
            }
            
            // Will set a custom width instead of the anchor view width
            dropDown.show()
        }
        else {
            self.currentTrip = Trip()
        }
    }
    
    @IBAction func phanXeAction(_ sender: Any) {
        if currentTrip.TripId == "" {
            print("Vui long chon chuyen")
            return
        }
        DispatchQueue.main.async {
            for row in 0 ..< self.bills.count {
                let cell = self.goodsTableView.cellForRow(at: IndexPath(item: row, section: 0)) as! BillCell
                if cell.selectedGood.isSelected {
                    self.assignTrip(tripId: self.currentTrip.TripId, billId: self.bills[row].BillID)
                }
            }
            self.loadFilterWaitTrip()
        }
    }
    
    @IBAction func addGoodAction(_ sender: Any) {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        let storyboard = UIStoryboard.init(name: "Goods", bundle: Bundle.main)
        let addController = storyboard.instantiateViewController(withIdentifier: "AddFret") as! AddFretController
        addController.currentUser = currentUser
        addController.tripId = "00000000-0000-0000-0000-000000000000"
        self.navigationController?.pushViewController(addController, animated: false)
    }
    
    @IBAction func homeAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Load data from Api

    func loadFilterWaitTrip() {
        let fromDate = currentDate + "000000"
        let toDate = currentDate + "240000"
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
            "<soapenv:Header/>" +
            "<soapenv:Body>" +
            "<tem:FilterWaitTrip>" +
            "<!--Optional:-->" +
            "<tem:Mobile>\(currentUser.UserName)</tem:Mobile>" +
            "<!--Optional:-->" +
            "<tem:Password>\(currentUser.Password)</tem:Password>" +
            "<!--Optional:-->" +
            "<tem:SecurityCode>MobihomeAppDv123</tem:SecurityCode>" +
            "<!--Optional:-->" +
            "<tem:CompanyId>\(currentUser.CompanyId)</tem:CompanyId>" +
            "<!--Optional:-->" +
            "<tem:AgentID>\(currentUser.AgentId)</tem:AgentID>" +
            "<!--Optional:-->" +
            "<tem:From>\(fromDate)</tem:From>" +
            "<!--Optional:-->" +
            "<tem:To>\(toDate)</tem:To>" +
            "<!--Optional:-->" +
            "<tem:SearchText></tem:SearchText>" +
            "<!--Optional:-->" +
            "<tem:pageNumber>\(pageNumber)</tem:pageNumber>" +
            "<!--Optional:-->" +
            "<tem:pageSize>\(pageSize)</tem:pageSize>" +
            "</tem:FilterWaitTrip>" +
            "</soapenv:Body>" +
        "</soapenv:Envelope>"
        let soapAction = "http://tempuri.org/IBillWcf/FilterWaitTrip"
        let sendPostRequest = SendPostRequest()
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction, urlKey: .billURL) { (result, error) in
            if error == nil {
                self.bills = self.jsonHelper.parseBills(result.data(using: String.Encoding.utf8)!)
                self.goodsTableView.reloadData()
            }
        }
    }
    
    func assignTrip(tripId: String, billId: Int) {
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
            "<soapenv:Header/>" +
            "<soapenv:Body>" +
            "<tem:AssignTrip>" +
            "<!--Optional:-->" +
            "<tem:TripId>\(tripId)</tem:TripId>" +
            "<!--Optional:-->" +
            "<tem:BillId>\(billId)</tem:BillId>" +
            "<!--Optional:-->" +
            "<tem:Password>\(currentUser.Password)</tem:Password>" +
            "<!--Optional:-->" +
            "<tem:Mobile>\(currentUser.UserName)</tem:Mobile>" +
            "<!--Optional:-->" +
            "<tem:SecurityCode>MobihomeAppDv123</tem:SecurityCode>" +
            "</tem:AssignTrip>" +
            "</soapenv:Body>" +
        "</soapenv:Envelope>"
        let soapAction = "http://tempuri.org/IBillWcf/AssignTrip"
        let sendPostRequest = SendPostRequest()
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction, urlKey: .billURL) { (result, error) in
            if error == nil {
                print("thanh cong")
            }
        }
    }
    
}
