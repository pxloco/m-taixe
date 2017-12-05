//
//  BillCell.swift
//  M-Taixe
//
//  Created by duong nam minh kha on 11/7/16.
//  Copyright © 2016 kha. All rights reserved.
//

import UIKit

class BillCell: UITableViewCell {

    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var lblCatch: UILabel!
    @IBOutlet weak var lblConsignee: UILabel!
    @IBOutlet weak var lblShipper: UILabel!
    @IBOutlet weak var lblBillName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
