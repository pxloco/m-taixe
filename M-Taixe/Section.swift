//
//  Section.swift
//  M-Taixe
//
//  Created by M on 1/18/18.
//  Copyright © 2018 kha. All rights reserved.
//

import Foundation

class Section {
    var name: String!
    var arrChild: [Section]!
    var locationId: String!
    var expanded: Bool
    
    init(name:  String, arrChild: [Section], locationId: String, expanded: Bool) {
        self.name = name
        self.arrChild = arrChild
        self.locationId = locationId
        self.expanded = expanded
    }
}
