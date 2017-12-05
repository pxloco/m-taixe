//
//  CallCell.swift
//  M-Taixe
//
//  Created by duong nam minh kha on 11/5/16.
//  Copyright © 2016 kha. All rights reserved.
//

import UIKit

class CallCell: UITableViewCell {

    @IBOutlet weak var lblCusName: UILabel!
    @IBOutlet weak var lblCusMobile: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
