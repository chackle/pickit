//
//  PersistentDataManager.swift
//  ChoiceMaker
//
//  Created by Michael Green on 27/04/2015.
//  Copyright (c) 2015 Michael Green. All rights reserved.
//

import Foundation

class PersistentDataManager {
  
  private let userDefaults: NSUserDefaults
  
  init() {
    userDefaults = NSUserDefaults()
  }
  
  func saveCategoriesData(categories: [Category]) {
    var categoriesData = [[String:AnyObject]]()
    for category in categories {
      categoriesData.append(category.dictionary())
    }
    userDefaults.setObject(categoriesData, forKey: "categoriesData")
  }
  
  func getCategoriesData() -> [[String:AnyObject]] {
    if let categoriesData = userDefaults.objectForKey("categoriesData") as? [[String:AnyObject]] {
      return categoriesData
    }
    return [[String:AnyObject]]()
  }
}