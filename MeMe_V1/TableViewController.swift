//
//  TableViewController.swift
//  MeMe_V2
//
//  Created by Manish Sharma on 10/9/15.
//  Copyright © 2015 CelG Mobile LLC. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var memes: [Meme]!{
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell") as UITableViewCell!
        cell.imageView?.image = memes[indexPath.row].memedImage
        cell.textLabel?.text = memes[indexPath.row].topText as String
        cell.detailTextLabel?.text = memes[indexPath.row].bottomText as String
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailedViewController = storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        detailedViewController.imageView.image = memes[indexPath.row].memedImage
        detailedViewController.index = indexPath.row
        navigationController!.pushViewController(detailedViewController, animated: true)
    }
}
