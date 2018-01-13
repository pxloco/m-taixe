//
//  FretController.swift
//  M-Taixe
//
//  Created by duong nam minh kha on 10/12/16.
//  Copyright © 2016 kha. All rights reserved.
//

import UIKit

class FretController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topBarMenu: UIView!
    
    var tripId = String()
    var currentUser = User()
    var bills = [Bill]()
    var segmentControl = UISegmentedControl()
    var sendPostRequest = SendPostRequest()
    var jsonHelper = JsonHelper()
    var alert = SCLAlertView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupBar()
        //setUpToolbar()
        loadData()
    }
    
//    func setUpToolbar() {
//        self.navigationController?.toolbar.barTintColor = UIColor.white
//        self.navigationController?.setToolbarHidden(false, animated: false)
//        //Thêm các nút tác vụ vào toolbar
//
//        let chemaButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "map_icon_active"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.btnSchemaClick(_:)))
//
//        let listButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "phone_active"), style: UIBarButtonItemStyle.plain, target: nil, action: nil)
//
//        let flex = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
//
//        let mapButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "map_google_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.btnMapClick(_:)))
//
//        listButton.tintColor = UIColor(netHex: 0x197DAE)
//        chemaButton.tintColor = UIColor(netHex: 0x555555)
//        mapButton.tintColor = UIColor(netHex: 0x555555)
//        let items = [flex,chemaButton,flex,listButton, flex, mapButton, flex]
//        self.toolbarItems = items
//    }
//
//    func btnSchemaClick(_ sender: UIBarButtonItem) {
//        self.navigationController?.popViewController(animated: false)
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
//    }
//
//    func btnMapClick(_ sender: UIBarButtonItem){
//        self.navigationController?.popViewController(animated: false)
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
//    }
    
    func loadData(){
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">" +
            "<soapenv:Header/>" +
            "<soapenv:Body>" +
            "<tem:GetBillOnTrip>" +
            "<!--Optional:-->" +
            "<tem:TripId>\(tripId)</tem:TripId>" +
            "<!--Optional:-->" +
            "<tem:Password>\(currentUser.Password)</tem:Password>" +
            "<!--Optional:-->" +
            "<tem:Mobile>\(currentUser.UserName)</tem:Mobile>" +
            "<!--Optional:-->" +
            "<tem:SecurityCode>MobihomeAppDv123</tem:SecurityCode>" +
            "</tem:GetBillOnTrip>" +
            "</soapenv:Body>" +
        "</soapenv:Envelope>"
        let soapAction = "http://tempuri.org/IMobihomeWcf/GetBillOnTrip"
        sendPostRequest.sendRequest(soapMessage, soapAction: soapAction){
            (result, error) in
            if error == nil{
                self.bills = self.jsonHelper.parseBills(result.data(using: String.Encoding.utf8)!)
                self.tableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BillCell", for: indexPath) as! BillCell
        let bill = bills[indexPath.row]
        cell.lblShipper.text = "Gửi: \(bill.ShipperName) - \(bill.ShipperMobile)"
        cell.lblConsignee.text = "Nhận: \(bill.Consignee) - \(bill.ConsigneeMobile)"
        cell.btnCall.tag = indexPath.row
//        let theStringNameOfGoods = bill.NameOfGoods.withFont(.systemFont(ofSize: 18))
        let theString = "<label style=\"font-size: 18px;\">\(bill.NameOfGoods) - <b>\(bill.TotalCharges)</b></label>"
        
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
        addController.tripId = tripId
        addController.billID = bills[indexPath.row].BillID
        addController.bill = bills[indexPath.row]
        self.navigationController?.pushViewController(addController, animated: false)
    }
    var callBill = Bill()
    
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

    func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        var tel = ""
        switch buttonIndex {
        case 0:
            tel = callBill.ShipperMobile
            break
        case 1:
            tel = callBill.ConsigneeMobile
            break
        default:
            break
        }
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
    
    func setupBar(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
         AppUtils.addShadowToView(view: topBarMenu, width: 1, height: 2, color: UIColor.gray.cgColor, opacity: 0.5, radius: 2)
        initSegmentControl()
        topBarMenu.addSubview(segmentControl)
        let attr = NSDictionary(object: UIFont(name: "HelveticaNeue", size: 9.0)!, forKey: NSFontAttributeName as NSCopying)
        self.segmentControl.setTitleTextAttributes(attr as! [AnyHashable : Any], for: UIControlState.normal)
        
//        let titleView = UIView.init(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
//        let titleImage = UIImageView(image: UIImage(named: "muiten"))
//        titleView.addSubview(segmentControl)
//        let navBarFrame = self.navigationController!.navigationBar.frame
//        titleView.frame = CGRect(x: (navBarFrame.width - segmentControl.frame.width) / 2, y: (navBarFrame.height - segmentControl.frame.height) / 2, width: segmentControl.frame.width, height: segmentControl.frame.height)
//        let attr = NSDictionary(object: UIFont(name: "HelveticaNeue", size: 9.0)!, forKey: NSFontAttributeName as NSCopying)
//
//        segmentControl.setTitleTextAttributes(attr as! [AnyHashable : Any], for: UIControlState.normal)
        
//        self.navigationItem.titleView = titleView
//
//        let btnAdd = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(self.btnAddClick))
//        self.navigationItem.rightBarButtonItem = btnAdd
//
//
//        let btnHome = UIButton()
//        btnHome.setBackgroundImage(UIImage(named: "home_icon"), for: UIControlState.normal)
//        var frame = btnHome.frame
//        frame.size.width = 35
//        frame.size.height = 25
//        btnHome.frame = frame
//
//        btnHome.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0)
//        btnHome.addTarget(self, action: #selector(self.btnHomeClick), for: UIControlEvents.touchUpInside)
//        let right = UIBarButtonItem(customView: btnHome)
//
//        self.navigationItem.setHidesBackButton(true, animated: false)
//        self.navigationItem.leftBarButtonItem = right
        
    }
//    func btnHomeClick() {
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
//        let controller = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)!-3]
//        self.navigationController?.popToViewController(controller!, animated: true)
//    }
//    func btnAddClick() {
//        let transition:CATransition = CATransition()
//        transition.duration = 0.5
//        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        transition.type = kCATransitionPush
//        transition.subtype = kCATransitionFromTop
//        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
//        let storyboard = UIStoryboard.init(name: "Goods", bundle: Bundle.main)
//        let addController = storyboard.instantiateViewController(withIdentifier: "AddFret") as! AddFretController
//        addController.currentUser = currentUser
//        addController.tripId = tripId
//        self.navigationController?.pushViewController(addController, animated: false)
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initSegmentControl(){
        self.segmentControl = UISegmentedControl.init(frame: CGRect(x: UIScreen.main.bounds.width/2 - 78, y: 20, width: 156, height: 29))
        self.segmentControl.removeAllSegments()
        self.segmentControl.insertSegment(withTitle: "Chưa đón", at: 0, animated: false)
        self.segmentControl.insertSegment(withTitle: "Tất cả", at: 1, animated: false)
        self.segmentControl.insertSegment(withTitle: "Hàng", at: 2, animated: false)
        self.segmentControl.selectedSegmentIndex = 2
        self.segmentControl.addTarget(self, action: #selector(CustomersController.segmentedControlValueChanged(_:)), for:.valueChanged)
        self.segmentControl.addTarget(self, action: #selector(CustomersController.segmentedControlValueChanged(_:)), for:.touchUpInside)
    }
    
    func segmentedControlValueChanged(_ sender: UISegmentedControl) {
//        if self.segmentControl.selectedSegmentIndex != 2{
//            var controllerCount = self.navigationController?.viewControllers.count
//            var lastController = self.navigationController?.viewControllers[controllerCount!-2] as! CustomersController
//            lastController.currentSegmentIndex = self.segmentControl.selectedSegmentIndex
//
//        }
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.popViewController(animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.overTop = false
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        loadData()
    }
    
    var overTop = false
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if tableView.contentOffset.y < -30{
//            overTop = true
//        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if overTop{
            navigateToSearch()
        }
    }
    
    func navigateToSearch(){
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "Search") as! SearchController
        controller.currentUser = self.currentUser
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - user action
    
    @IBAction func homeAction(_ sender: Any) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let controller = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)!-3]
        self.navigationController?.popToViewController(controller!, animated: true)
    }
    
    @IBAction func addGoodsAction(_ sender: Any) {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        let storyboard = UIStoryboard.init(name: "Goods", bundle: Bundle.main)
        let addController = storyboard.instantiateViewController(withIdentifier: "AddFret") as! AddFretController
        addController.currentUser = currentUser
        addController.tripId = tripId
        self.navigationController?.pushViewController(addController, animated: false)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
