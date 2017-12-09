//
//  SchemaController.swift
//  M-Taixe
//
//  Created by M on 12/9/17.
//  Copyright © 2017 kha. All rights reserved.
//

import UIKit

class SchemaController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // - MARK: User Action
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
