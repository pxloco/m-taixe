//
//  InformationCell.swift
//  M-Taixe
//
//  Created by duong nam minh kha on 7/18/16.
//  Copyright © 2016 kha. All rights reserved.
//

import UIKit

class InformationCell: UITableViewCell {

    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var lblInfor: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btnLogoutClick(_ sender: UIButton) {
    
    }
}
