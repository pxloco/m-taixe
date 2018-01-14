//
//  EditDriverViewController.swift
//  M-Taixe
//
//  Created by M on 1/14/18.
//  Copyright © 2018 kha. All rights reserved.
//

import UIKit

class EditDriverViewController: UIViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var bienSoLabel: UILabel!
    @IBOutlet var startTimeLabel: UIView!
    @IBOutlet weak var driverTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - User Action
    
    @IBAction func cancelAction(_ sender: Any) {
    }
    
    @IBAction func saveAction(_ sender: Any) {
    }
    
    
    @IBAction func searchAction(_ sender: Any) {
    }
    
}

