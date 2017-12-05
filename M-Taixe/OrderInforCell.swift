//
//  OrderInforCell.swift
//  M-Taixe
//
//  Created by duong nam minh kha on 11/4/16.
//  Copyright © 2016 kha. All rights reserved.
//

import UIKit

class OrderInforCell: UITableViewCell {

    @IBOutlet weak var webviewArrival: UIWebView!
    @IBOutlet weak var webviewDepart: UIWebView!
    @IBOutlet weak var tfCatchAddress: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfMobile: UITextField!
    override func awakeFromNib() {
        webviewDepart.backgroundColor = UIColor.clear
        webviewDepart.isOpaque = false
        webviewDepart.scrollView.isScrollEnabled = false
        webviewDepart.scrollView.bounces = false

        
        webviewArrival.backgroundColor = UIColor.clear
        webviewArrival.isOpaque = false
        webviewArrival.scrollView.isScrollEnabled = false
        webviewArrival.scrollView.bounces = false
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
