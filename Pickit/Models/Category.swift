//
//  Category.swift
//  ChoiceMaker
//
//  Created by Michael Green on 27/04/2015.
//  Copyright (c) 2015 Michael Green. All rights reserved.
//

import Foundation

class Category {
  
  var id: Int
  var title: String
  var choices: [Choice]
  
  init(id: Int, title: String) {
    self.id = id
    self.title = title
    self.choices = [Choice]()
  }
  
  func selectedChoices() -> [Choice] {
    var selectedChoices = [Choice]()
    for choice in choices {
      if choice.selected {
        selectedChoices.append(choice)
      }
    }
    return selectedChoices
  }
  
  func addChoiceWithName(name: String) {
    let choice = Choice(name: name, selected: true)
    self.choices.append(choice)
  }
  
  func dictionary() -> [String:AnyObject] {
    var dictionary = [String:AnyObject]()
    dictionary["id"] = id
    dictionary["title"] = title
    var choicesDictionary = [[String:AnyObject]]()
    for choice in choices {
      choicesDictionary.append(choice.dictionary())
    }
    dictionary["choices"] = choicesDictionary
    return dictionary
  }
}
