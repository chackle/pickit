//
//  CategoriesManager.swift
//  ChoiceMaker
//
//  Created by Michael Green on 27/04/2015.
//  Copyright (c) 2015 Michael Green. All rights reserved.
//

import Foundation

class CategoriesManager {
  
  private let persistentDataManager: PersistentDataManager
  private let categoryBuilder: CategoryBuilder
  
  var categories: [Category]
  
  init() {
    self.categories = [Category]()
    self.persistentDataManager = PersistentDataManager()
    self.categoryBuilder = CategoryBuilder()
  }
  
  func addNewCategory() {
    let titlePrefix = "New Category "
    if let lastCategory = categories.last {
      let categoryId = lastCategory.id + 1
      var category = Category(id: categoryId, title: "\(titlePrefix)\(categoryId)")
      self.categories.append(category)
    }
    else {
      let categoryId = 0
      self.categories.append(Category(id: categoryId, title: "\(titlePrefix)\(categoryId)"))
    }
  }
  
  func loadCategories() {
    categories += categoryBuilder.buildCategories(persistentDataManager.getCategoriesData())
  }
  
  func saveCategories() {
    persistentDataManager.saveCategoriesData(categories)
  }
}
