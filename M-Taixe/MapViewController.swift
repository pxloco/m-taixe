//
//  MapViewController.swift
//  M-Taixe
//
//  Created by M on 12/17/17.
//  Copyright © 2017 kha. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var topbar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func InitUI() {
        AppUtils.addShadowToView(view: topbar, width: 1, height: 2, color: UIColor.gray.cgColor, opacity: 0.5, radius: 2)
    }
}
