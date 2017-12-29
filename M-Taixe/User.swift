//
//  User.swift
//  M-Taixe
//
//  Created by duong nam minh kha on 7/14/16.
//  Copyright © 2016 kha. All rights reserved.
//

import Foundation
class User{
    var UserName = String()
    var Password = String()
    var DisplayName = String()
    var RoleType = Int()
    var CompanyId = String()
    var AgentId = String()
    var UserId = String()
    var UserGuid = String()
    
    init() {}
    
    init(UserName: String, Password: String, DisplayName: String, RoleType: Int, CompanyId: String, AgentId: String, UserId: String, UserGuid: String) {
        self.UserName = UserName
        self.Password = Password
        self.DisplayName = DisplayName
        self.RoleType = RoleType
        self.CompanyId = CompanyId
        self.AgentId = AgentId
        self.UserId = UserId
        self.UserGuid = UserGuid
    }
}
