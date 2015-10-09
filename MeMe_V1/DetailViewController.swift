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
    var index: Int!
    var memes: [Meme]!{
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(animated: Bool) {
        imageView.image = memes[index].memedImage
    }
    
    @IBAction func editMeme(sender: AnyObject) {
        let memeViewController = storyboard!.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        memeViewController.topTextField.text = memes[index].topText as String
        memeViewController.bottomTextField.text = memes[index].bottomText as String
        memeViewController.imageView.image = memes[index].image
        presentViewController(memeViewController, animated: true, completion: nil)
    }
    
}