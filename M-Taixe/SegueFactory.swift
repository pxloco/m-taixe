//
//  SegueFactory.swift
//  M-Taixe
//
//  Created by M on 12/9/17.
//  Copyright © 2017 kha. All rights reserved.
//

import Foundation

enum SegueFactory: String {
    case fromCustomerToSchema                     = "fromCustomerToSchema"
    case fromCategoryToEditCategory               = "fromCategoryToEditCategory"
    case fromCategoryToAnalys                     = "fromCategoryToAnalys"
    case fromLoginToTabBarViewController          = "fromLoginToTabBarViewController"
    case showChooseRouteView                      = "showChooseRouteView"
    case fromCategoryToSchema                     = "fromCategoryToSchema"
    case fromLoginToHomeTabBar                    = "fromLoginToHomeTabBar"
    case fromSchemaToEditRoute                    = "fromSchemaToEditRoute"
    case fromCategoryToGoods                      = "fromCategoryToGoods"
    case fromCustomerToAddGoods                   = "fromCustomerToAddGoods"
    case fromGoodsToAddGoods                      = "fromGoodsToAddGoods"
    case fromSchemaToEditDriver                   = "fromSchemaToEditDriver"
    case fromSchemaToChangeCar                    = "fromSchemaToChangeCar"
    case fromSchemaToAddSeat                      = "fromSchemaToAddSeat"
}

