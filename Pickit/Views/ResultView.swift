//
//  ResultView.swift
//  ChoiceMaker
//
//  Created by Michael Green on 01/05/2015.
//  Copyright (c) 2015 Michael Green. All rights reserved.
//

import Foundation
import UIKit

class ResultView: UIView {
  
  private let animationDuration: NSTimeInterval = 6
  private let rotationCount: Float = 20
  private let rotationAnimationKey = "rotateView"
  private let flavourTextStrings = ["You should definitely choose...", "Our survey says...", "Obviously the choice should be...", "The votes are in. The winner is..."]
  
  private var view: UIView!
  private var centerView: UIView!
  private var resultLabel: UILabel!
  private var diceImageView: UIImageView!
  private var cancelButton: UIButton!
  private var resultFlavourLabel: UILabel!
  
  var result: Choice!
  var parentViewController: UIViewController!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    xibSetup()
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    xibSetup()
  }
  
  func beginSpin() {
    resultLabel.text = result.name
    if centerView.layer.animationForKey(rotationAnimationKey) == nil {
      var rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
      rotationAnimation.fromValue = 0.0
      rotationAnimation.toValue = Float(M_PI * 2.0) * rotationCount
      rotationAnimation.duration = animationDuration
      rotationAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.5, 0, 0.5, 1)
      centerView.layer.addAnimation(rotationAnimation, forKey: rotationAnimationKey)
      
      UIView.animateWithDuration(animationDuration/2, delay: animationDuration/2, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
        self.resultLabel.alpha = 1
        self.diceImageView.alpha = 0
      }, completion: nil)
    }
  }
  
  func dismiss() {
    parentViewController.dismissViewControllerAnimated(true, completion: nil)
  }
  
  private func randomFlavourText() -> String {
    let position = arc4random_uniform(UInt32(flavourTextStrings.count))
    return flavourTextStrings[Int(position)]
  }
  
  private func xibSetup() {
    view = loadViewFromNib()
    view.frame = bounds
    view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
    addSubview(view)
  }
  
  private func loadViewFromNib() -> UIView {
    let bundle = NSBundle(forClass: self.dynamicType)
    let nib = UINib(nibName: "ResultView", bundle: bundle)
    let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
    centerView = view.viewWithTag(1)
    resultLabel = view.viewWithTag(2) as! UILabel
    diceImageView = view.viewWithTag(3) as! UIImageView
    cancelButton = view.viewWithTag(4) as! UIButton
    cancelButton.addTarget(self, action: Selector("dismiss"), forControlEvents: UIControlEvents.TouchUpInside)
    resultFlavourLabel = view.viewWithTag(5) as! UILabel
    resultFlavourLabel.text = randomFlavourText()
    return view
  }
}