//
//  ViewController.swift
//  ChoiceMaker
//
//  Created by Michael Green on 27/04/2015.
//  Copyright (c) 2015 Michael Green. All rights reserved.
//

import UIKit

class CategoriesViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
  
  let categoriesManager: CategoriesManager
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    self.categoriesManager = CategoriesManager()
    self.categoriesManager.loadCategories()
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init(coder aDecoder: NSCoder) {
    self.categoriesManager = CategoriesManager()
    self.categoriesManager.loadCategories()
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.tableView.reloadData()
    categoriesManager.saveCategories()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: TableView Delegate Methods
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.categoriesManager.categories.count + 1
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell") as! UITableViewCell
    var label = cell.viewWithTag(1) as! UILabel
    if indexPath.row < self.categoriesManager.categories.count {
      let category = self.categoriesManager.categories[indexPath.row]
      label.text = category.title
      label.textColor = UIColor.blackColor()
    }
    else {
      label.text = "Create a new category"
      label.textColor = UIColor.lightGrayColor()
    }
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    self.performSegueWithIdentifier("ShowCategoryChoices", sender: self)
  }
  
  override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    
  }
  
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    if indexPath.row < categoriesManager.categories.count {
      return true
    }
    return false
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == UITableViewCellEditingStyle.Delete {
      categoriesManager.categories.removeAtIndex(indexPath.row)
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
      categoriesManager.saveCategories()
    }
  }
  
  // MARK: Segue Operations
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ShowCategoryChoices" {
      var viewController = segue.destinationViewController as! ChoicesViewController
      if tableView.indexPathForSelectedRow()!.row == self.categoriesManager.categories.count {
        self.categoriesManager.addNewCategory()
      }
      viewController.category = self.categoriesManager.categories[tableView.indexPathForSelectedRow()!.row]
      viewController.categoriesManager = self.categoriesManager
    }
  }
}

