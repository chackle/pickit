//
//  CategoryBuilder.swift
//  ChoiceMaker
//
//  Created by Michael Green on 27/04/2015.
//  Copyright (c) 2015 Michael Green. All rights reserved.
//

import Foundation

class CategoryBuilder {
  
  init() {
    
  }
  
  private func buildCategory(categoryDictionary: [String:AnyObject]) -> Category {
    let id = categoryDictionary["id"] as! Int
    let title = categoryDictionary["title"] as! String
    let choicesData = categoryDictionary["choices"] as! [[String:AnyObject]]
    var category = Category(id: id, title: title)
    for choiceDictionary in choicesData {
      let name = choiceDictionary["name"] as! String
      let selected = choiceDictionary["selected"] as! Bool
      let choice = Choice(name: name, selected: selected)
      category.choices.append(choice)
    }
    return category
  }
  
  func buildCategories(categoriesArray: [[String:AnyObject]]) -> [Category] {
    var categories = [Category]()
    for categoriesDictionary in categoriesArray {
      let category = buildCategory(categoriesDictionary)
      categories.append(category)
    }
    return categories
  }
}