//
//  ResultViewController.swift
//  ChoiceMaker
//
//  Created by Michael Green on 01/05/2015.
//  Copyright (c) 2015 Michael Green. All rights reserved.
//

import Foundation
import UIKit

class ResultViewController: UIViewController {
  
  @IBOutlet var resultView: ResultView!
  var result: Choice!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    resultView.result = result
    resultView.parentViewController = self
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    resultView.beginSpin()
  }
}
