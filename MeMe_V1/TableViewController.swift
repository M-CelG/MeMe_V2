//
//  TableViewController.swift
//  MeMe_V2
//
//  Created by Manish Sharma on 10/9/15.
//  Copyright © 2015 CelG Mobile LLC. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {
    //Access stored Images in App delegate
    var memes: [Meme]!{
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    
    override func viewWillAppear(animated: Bool) {
        //Reload images after new image has been saved
        tableView.reloadData()
        //Ensure tabbar controller is no longer hidden
        tabBarController?.tabBar.hidden = false
    }
    
    //Action outlet from Table view to MeMe Editor View Controller
    @IBAction func memeEditor(sender: AnyObject) {
        let memeEditorViewController = storyboard!.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        navigationController!.pushViewController(memeEditorViewController, animated: true)
    }

    //Table view DataSource to return number of rows in the table view
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    //Table view delegate to create table view cells
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell") as UITableViewCell!
        cell.imageView?.image = memes[indexPath.row].memedImage
        cell.textLabel?.text = memes[indexPath.row].topText as String
        cell.detailTextLabel?.text = memes[indexPath.row].bottomText as String
        
        return cell
    }
    
    //Table view delegate to bring Detail View Controller
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailedViewController = storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        detailedViewController.index = indexPath.row
        navigationController!.pushViewController(detailedViewController, animated: true)
    }
}
