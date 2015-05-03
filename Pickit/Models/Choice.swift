//
//  Choice.swift
//  ChoiceMaker
//
//  Created by Michael Green on 27/04/2015.
//  Copyright (c) 2015 Michael Green. All rights reserved.
//

import Foundation

class Choice {

  var name: String
  var selected: Bool
  
  init(name: String, selected: Bool) {
    self.name = name
    self.selected = selected
  }
  
  func dictionary() -> [String:AnyObject] {
    var dictionary = [String:AnyObject]()
    dictionary["name"] = name
    dictionary["selected"] = selected
    return dictionary
  }
}
