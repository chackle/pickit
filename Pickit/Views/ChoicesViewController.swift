//
//  ChoicesViewController.swift
//  ChoiceMaker
//
//  Created by Michael Green on 27/04/2015.
//  Copyright (c) 2015 Michael Green. All rights reserved.
//

import UIKit

class ChoicesViewController: UITableViewController, UITextFieldDelegate {

  @IBOutlet var titleBarTextField: UITextField!
  
  private var keyboardIsShown: Bool!
  private var tapGestureRecognizer: UITapGestureRecognizer!

  var categoriesManager: CategoriesManager!
  var category: Category!
  
  var editingChoice: Choice?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    titleBarTextField.text = category.title
    titleBarTextField.tintColor = UIColor.whiteColor()
    titleBarTextField.sizeToFit()
    titleBarTextField.addTarget(self, action: Selector("textFieldDidChange:"), forControlEvents: UIControlEvents.EditingChanged)
    keyboardIsShown = false
    registerGestureRecognizers()
    registerKeyboardNotifications()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    categoriesManager.saveCategories()
  }
  
  override func viewWillDisappear(animated: Bool) {
    unregisterKeyboardNotifications()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  // MARK: Bar Button Actions
  @IBAction func makeChoice(sender: AnyObject) {
    let selectedChoices = category.selectedChoices()
    let choicePosition = arc4random_uniform(UInt32(selectedChoices.count))
    if !(selectedChoices.count > 1) {
      var alert = UIAlertController(title: "Oops", message: "You have to select more than one choice for a decision!", preferredStyle: UIAlertControllerStyle.Alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
      self.presentViewController(alert, animated: true, completion: nil)
    }
    else {
      let choice = selectedChoices[Int(choicePosition)]
      performSegueWithIdentifier("PresentResults", sender: choice)
    }
    categoriesManager.saveCategories()
  }
  
  // MARK: UITableView Delegate Methods
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.category.choices.count + 1
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell: UITableViewCell!
    if indexPath.row < self.category.choices.count {
      cell = tableView.dequeueReusableCellWithIdentifier("ChoiceCell") as! UITableViewCell
      let choice = self.category.choices[indexPath.row]
      var textField = cell.viewWithTag(1) as! UITextField
      textField.text = choice.name
      textField.addTarget(self, action: Selector("textFieldDidChange:"), forControlEvents: UIControlEvents.EditingChanged)
      cell.accessoryType = choice.selected ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None
    }
    else {
      cell = tableView.dequeueReusableCellWithIdentifier("AddChoiceCell") as! UITableViewCell
    }
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    var cell = tableView.cellForRowAtIndexPath(indexPath)
    if indexPath.row < self.category.choices.count {
      var choice = self.category.choices[indexPath.row]
      choice.selected = !choice.selected
      cell!.accessoryType = choice.selected ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None
      self.view.endEditing(true)
      categoriesManager.saveCategories()
    }
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    
  }
  
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    if indexPath.row < category.choices.count {
      return true
    }
    return false
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == UITableViewCellEditingStyle.Delete {
      category.choices.removeAtIndex(indexPath.row)
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
      categoriesManager.saveCategories()
    }
  }
  
  // MARK: Gesture Recognizer Methods
  func registerGestureRecognizers() {
    var longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("beginEditChoice:"))
    longPressGestureRecognizer.minimumPressDuration = 0.7
    self.tableView.addGestureRecognizer(longPressGestureRecognizer)
    tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("endEditing:"))
    tapGestureRecognizer.cancelsTouchesInView = false
    self.tableView.addGestureRecognizer(tapGestureRecognizer)
  }
  
  func beginEditChoice(sender: UILongPressGestureRecognizer) {
    let state = sender.state
    if state == UIGestureRecognizerState.Began {
      let locationPressed = sender.locationInView(self.tableView)
      let indexPath = self.tableView.indexPathForRowAtPoint(locationPressed)
      if let unwrappedIndexPath = indexPath {
        let cell = self.tableView.cellForRowAtIndexPath(unwrappedIndexPath)
        let textField = cell?.viewWithTag(1)
        textField?.userInteractionEnabled = true
        textField?.becomeFirstResponder()
        editingChoice = category.choices[unwrappedIndexPath.row]
      }
    }
  }
  
  func endEditing(sender: UITapGestureRecognizer) {
    self.tableView.endEditing(true)
    titleBarTextField.resignFirstResponder()
  }
  
  // MARK: Keyboard Shown Functions
  func registerKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().addObserver(
      self,
      selector: "keyboardWasShown:",
      name: UIKeyboardDidShowNotification,
      object: nil)
    
    NSNotificationCenter.defaultCenter().addObserver(
      self,
      selector: "keyboardWasHidden:",
      name: UIKeyboardDidHideNotification,
      object: nil)
  }
  
  func unregisterKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().removeObserver(self,
      name: UIKeyboardDidShowNotification,
      object: nil)
    
    NSNotificationCenter.defaultCenter().removeObserver(self,
      name: UIKeyboardWillHideNotification,
      object: nil)
  }
  
  func keyboardWasShown(notification: NSNotification) {
    tapGestureRecognizer.cancelsTouchesInView = true
  }
  
  func keyboardWasHidden(notification: NSNotification) {
    tapGestureRecognizer.cancelsTouchesInView = false
  }
  
  // MARK: UITextField Delegate Methods
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    if textField.isEqual(titleBarTextField) {
      if count(textField.text) > 30 {
        return false
      }
    }
    
    return true
  }
  
  func textFieldDidChange(textField: UITextField) {
    if textField.isEqual(titleBarTextField) {
      category.title = textField.text
    }
    else if textField.tag == 1 {
      if let unwrappedEditingChoice = editingChoice {
        unwrappedEditingChoice.name = textField.text
      }
    }
    categoriesManager.saveCategories()
  }
  
  func textFieldDidBeginEditing(textField: UITextField) {
    if textField.isEqual(titleBarTextField) {
      textField.frame = CGRectMake(textField.frame.origin.x, textField.frame.origin.y, self.view.frame.size.width, textField.frame.size.height)
    }
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    if textField.isEqual(titleBarTextField) {
      category.title = textField.text.isEmpty ? "Category \(category.id)" : textField.text
      textField.sizeToFit()
    }
    else if textField.tag == 2 {
      if (!textField.text.isEmpty) {
        category.addChoiceWithName(textField.text)
        textField.text = ""
        tableView.reloadData()
      }
    }
    else {
      textField.userInteractionEnabled = false
    }
    categoriesManager.saveCategories()
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "PresentResults" {
      var viewController = segue.destinationViewController as! ResultViewController
      viewController.result = sender as! Choice
    }
  }
}
