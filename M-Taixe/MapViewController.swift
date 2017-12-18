//
//  MapViewController.swift
//  M-Taixe
//
//  Created by M on 12/17/17.
//  Copyright © 2017 kha. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBottomBar()
    }
    
    func initNavigationBottomBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.toolbar.barTintColor = UIColor.white
        self.navigationController?.setToolbarHidden(false, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: true)
        let flex = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let listCustomerButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "ListIcon"), style: UIBarButtonItemStyle.plain, target: nil, action: #selector(MapViewController.btnListCustomerClick(_: )))
        let schemaButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "map_icon_active"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(MapViewController.btnSchemaClick(_:)))
        let mapButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "map_icon_active"), style: UIBarButtonItemStyle.plain, target: self, action: nil)
        schemaButton.tintColor = UIColor(netHex: 0x555555)
        listCustomerButton.tintColor = UIColor(netHex: 0x197DAE)
        
        let items = [flex, listCustomerButton, flex, schemaButton, flex, mapButton, flex]
        self.toolbarItems = items
    }
    
    func btnListCustomerClick(_ sender: UIBarButtonItem) {
        let controller = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)!-3]
        self.navigationController?.popToViewController(controller!, animated: true)
    }
    
    func btnSchemaClick(_ sender: UIBarButtonItem) {
         self.navigationController?.popViewController(animated: true)
    }
}
