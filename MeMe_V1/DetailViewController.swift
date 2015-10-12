//
//  DetailViewController.swift
//  MeMe_V2
//
//  Created by Manish Sharma on 10/9/15.
//  Copyright © 2015 CelG Mobile LLC. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    //Array Index passed on from Table or collection View Controllers
    var index: Int!
    //Access stored images in App Delegate
    var memes: [Meme]!{
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
        
    override func viewWillAppear(animated: Bool) {
        imageView.image = memes[index].memedImage
        //Hide tabBar
        tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        //Unhide tabBar
        tabBarController?.tabBar.hidden = false
    }
    
    //Use Edit button to edit MeMed Image using MeMe Editor View Controller
    @IBAction func editMeme(sender: AnyObject) {
        let memeViewController = storyboard!.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        memeViewController.index = index
        navigationController!.pushViewController(memeViewController, animated: true)
    }
    
}