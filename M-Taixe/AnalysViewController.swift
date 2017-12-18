//
//  AnalysViewController.swift
//  M-Taixe
//
//  Created by M on 12/17/17.
//  Copyright © 2017 kha. All rights reserved.
//

import UIKit

class AnalysViewController: UIViewController {

    var currentUser = User()
    var userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    // MARK: - Init
    
    func initUI() {
        let fullName = self.userDefaults.value(forKey: "FullName") as! String
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.toolbar.barTintColor = UIColor.white
        self.navigationController?.setToolbarHidden(false, animated: false)
        //Thêm các nút tác vụ vào toolbar
        let inforButton = UIBarButtonItem.init(image: UIImage(named: "person-icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(AnalysViewController.btnInforClick(_:)))
        let listButton = UIBarButtonItem.init(image: UIImage(named: "ListIcon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(AnalysViewController.btnListCategoryClick(_:)))
        let analysButton = UIBarButtonItem.init(image: UIImage(named: "ListIcon"), style: UIBarButtonItemStyle.plain, target: self, action: nil)
        listButton.tintColor = UIColor(netHex: 0x197DAE)
        inforButton.tintColor = UIColor(netHex: 0x555555)
        analysButton.tintColor = UIColor(netHex: 0x555555)
        let flex = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        if currentUser.RoleType != 1 {
            let listCallButton = UIBarButtonItem.init(image: UIImage(named: "phone_active"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.btnListCallClick))
            
            listCallButton.tintColor = UIColor(netHex: 0x555555)
            let items = [flex,listButton, flex, listCallButton, flex, analysButton, flex, inforButton, flex]
            self.toolbarItems = items
        }
        else{
            let items = [flex,listButton,flex, inforButton, flex]
            self.toolbarItems = items
        }
    }
    
    func btnListCallClick(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "ListCall") as! ListCallController
        controller.currentUser = self.currentUser
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func btnListCategoryClick(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func btnInforClick(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "ListCall") as! ListCallController
        controller.currentUser = self.currentUser
        controller.inforView = true
        self.navigationController?.pushViewController(controller, animated: false)
    }
    
    
    // MARK: - User Action
    
    @IBAction func selectDateClick(_ sender: Any) {
    }
    
    @IBAction func rightDateButtonClick(_ sender: Any) {
    }
    @IBAction func leftDateButtonClick(_ sender: Any) {
    }
    @IBAction func btnThongKeTheoXeClick(_ sender: Any) {
    }
    
}
